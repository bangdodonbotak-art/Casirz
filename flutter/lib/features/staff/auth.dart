// Casirz ERP — Fase 5 (Modul D Staf).
// RBAC + PIN: peran, hak akses menu, hash PIN (SHA-256 + salt acak),
// verifikasi PIN dengan penguncian 3x salah -> kunci 1 menit.
//
// TIDAK ADA PIN BAWAAN: pinHash kosong ('') = PIN belum diatur. Owner
// mengatur PIN tiap karyawan lewat UI (termasuk PIN owner sendiri saat
// pertama kali). Jangan pernah mengarang PIN default.
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db.dart';

/// Peran karyawan (kolom employees.role: 'owner' | 'manager' | 'kasir').
enum StaffRole { owner, manager, kasir }

/// Parse peran dari string DB. Throw bila tidak dikenal.
StaffRole roleFromString(String role) {
  switch (role) {
    case 'owner':
      return StaffRole.owner;
    case 'manager':
      return StaffRole.manager;
    case 'kasir':
      return StaffRole.kasir;
    default:
      throw ArgumentError('Peran tidak dikenal: $role');
  }
}

extension StaffRoleX on StaffRole {
  /// Nama peran seperti di DB.
  String get code => name;

  /// Label Indonesia untuk UI.
  String get label {
    switch (this) {
      case StaffRole.owner:
        return 'Owner';
      case StaffRole.manager:
        return 'Manager';
      case StaffRole.kasir:
        return 'Kasir';
    }
  }

  /// Menu utama yang BOLEH dibuka peran ini (dipakai shell untuk
  /// menyembunyikan menu + menampilkan pesan kunci pada menu terkunci).
  /// - Owner: semua menu.
  /// - Manager: POS + Meja + Transaksi + Bahan Baku (+opname) + Laporan
  ///   (lihat saja) + Shift + Staf (lihat + absensi) + Pengaturan.
  ///   TIDAK boleh: Akuntansi (Modal/Aset) + ubah PIN orang lain.
  /// - Kasir: POS + Meja + Transaksi (lihat saja) + Shift. TIDAK boleh:
  ///   Akuntansi, Staf, Bahan Baku/opname, Laporan, Pengaturan.
  bool canAccess(MenuId menu) {
    switch (menu) {
      case MenuId.kasir:
      case MenuId.meja:
      case MenuId.transaksi:
      case MenuId.shift:
        return true;
      case MenuId.bahan:
      case MenuId.laporan:
      case MenuId.staf:
      case MenuId.pengaturan:
        return this != StaffRole.kasir;
      case MenuId.akuntansi:
      case MenuId.dashboard:
        return this == StaffRole.owner;
    }
  }

  /// Atur/ubah PIN karyawan lain + tambah/edit/nonaktifkan karyawan:
  /// hanya Owner.
  bool get canManageEmployees => this == StaffRole.owner;

  /// Proses gaji (mem-posting jurnal D 5130 / K 1000|1010): hanya Owner.
  /// Manager boleh LIHAT payroll + slip, tidak boleh memproses.
  bool get canProcessPayroll => this == StaffRole.owner;

  bool get canViewPayroll => this != StaffRole.kasir;
}

/// Menu yang dijaga RBAC (id stabil untuk pesan kunci).
enum MenuId { kasir, meja, transaksi, bahan, akuntansi, laporan, staf, shift, pengaturan, dashboard }

extension MenuIdX on MenuId {
  String get label {
    switch (this) {
      case MenuId.kasir:
        return 'Kasir';
      case MenuId.meja:
        return 'Meja';
      case MenuId.transaksi:
        return 'Transaksi';
      case MenuId.bahan:
        return 'Bahan Baku';
      case MenuId.akuntansi:
        return 'Akuntansi';
      case MenuId.laporan:
        return 'Laporan';
      case MenuId.staf:
        return 'Staf';
      case MenuId.shift:
        return 'Shift & Laci Kas';
      case MenuId.pengaturan:
        return 'Pengaturan';
      case MenuId.dashboard:
        return 'Command Center';
    }
  }

  /// Alasan kunci untuk peran yang tidak boleh — tampil di UI, bukan
  /// tombol mati tanpa penjelasan.
  String lockedReason(StaffRole role) {
    switch (this) {
      case MenuId.akuntansi:
        return 'Menu Akuntansi (modal, aset, jurnal) hanya untuk Owner. '
            'Peran Anda saat ini: ${role.label}.';
      case MenuId.dashboard:
        return 'Menu Command Center hanya untuk Owner. '
            'Peran Anda saat ini: ${role.label}.';
      case MenuId.bahan:
      case MenuId.laporan:
      case MenuId.staf:
      case MenuId.pengaturan:
        return 'Menu $label hanya untuk Owner dan Manager. '
            'Peran Anda saat ini: ${role.label}.';
      case MenuId.kasir:
      case MenuId.meja:
      case MenuId.transaksi:
      case MenuId.shift:
        return 'Menu $label terbuka untuk semua peran.';
    }
  }
}

/// PIN belum diatur untuk karyawan ini.
class PinNotSetException implements Exception {
  PinNotSetException(this.employeeName);
  final String employeeName;
  @override
  String toString() =>
      'PIN $employeeName belum diatur. Minta Owner mengatur PIN di menu Staf.';
}

/// PIN terkunci sementara setelah 3x salah.
class PinLockedException implements Exception {
  PinLockedException(this.lockedUntil);
  final DateTime lockedUntil;
  @override
  String toString() =>
      'PIN terkunci sementara setelah 3x salah. Coba lagi setelah '
      '${lockedUntil.hour.toString().padLeft(2, '0')}:'
      '${lockedUntil.minute.toString().padLeft(2, '0')}.';
}

/// Autentikasi PIN karyawan.
///
/// Format simpan di employees.pinHash: `saltHex:hashHex`, dengan
/// hashHex = SHA-256(salt + UTF-8 PIN). Salt 16 byte acak per karyawan,
/// jadi PIN yang sama di dua karyawan menghasilkan hash berbeda.
/// TIDAK PERNAH menyimpan PIN mentah.
class AuthService {
  AuthService({DateTime Function()? now}) : _now = now ?? DateTime.now;

  final DateTime Function() _now;

  /// Maksimal salah beruntun sebelum kunci.
  static const int maxAttempts = 3;

  /// Lama kunci setelah 3x salah.
  static const Duration lockDuration = Duration(minutes: 1);

  /// Sisa percobaan salah sebelum kunci (untuk pesan UI).
  static const int attemptsLeftAfterOneFail = maxAttempts - 1;

  final Map<String, int> _failCounts = {};
  final Map<String, DateTime> _lockedUntil = {};

  /// True bila karyawan ini sedang terkunci (dan kunci belum kedaluwarsa).
  bool isLocked(String employeeId) {
    final until = _lockedUntil[employeeId];
    if (until == null) return false;
    if (_now().isAfter(until) || _now().isAtSameMomentAs(until)) {
      _lockedUntil.remove(employeeId);
      _failCounts.remove(employeeId);
      return false;
    }
    return true;
  }

  /// Sisa waktu kunci (null bila tidak terkunci).
  Duration? lockRemaining(String employeeId) {
    final until = _lockedUntil[employeeId];
    if (until == null || !isLocked(employeeId)) return null;
    return until.difference(_now());
  }

  /// Jumlah salah beruntun saat ini (0 bila belum pernah / sudah reset).
  int failCount(String employeeId) => _failCounts[employeeId] ?? 0;

  /// Validasi format PIN: 4-6 digit angka saja. Throw bila tidak valid.
  static void validatePinFormat(String pin) {
    if (pin.length < 4 || pin.length > 6) {
      throw ArgumentError('PIN harus 4-6 digit.');
    }
    if (!RegExp(r'^[0-9]{4,6}$').hasMatch(pin)) {
      throw ArgumentError('PIN hanya boleh berisi angka 0-9.');
    }
  }

  /// Hash satu PIN dengan salt hex. Dipakai setPin + test.
  static String hashPin(String pin, String saltHex) {
    final salt = _hexToBytes(saltHex);
    final digest = sha256.convert([...salt, ...utf8.encode(pin)]);
    return digest.toString();
  }

  /// Buat nilai pinHash baru untuk satu PIN (salt acak tiap panggil).
  static String createPinHash(String pin) {
    validatePinFormat(pin);
    final salt = List<int>.generate(16, (_) => Random.secure().nextInt(256));
    final saltHex = _bytesToHex(salt);
    return '$saltHex:${hashPin(pin, saltHex)}';
  }

  /// True bila nilai pinHash cocok dengan PIN (format `salt:hash`).
  /// Nilai kosong / format lama / tanpa salt -> false (tidak pernah lolos).
  static bool checkPinHash(String pin, String stored) {
    final parts = stored.split(':');
    if (parts.length != 2 || parts[0].isEmpty || parts[1].isEmpty) {
      return false;
    }
    return hashPin(pin, parts[0]) == parts[1];
  }

  /// True bila karyawan sudah punya PIN (pinHash tidak kosong).
  static bool isPinSet(Employee employee) => employee.pinHash.isNotEmpty;

  /// Atur/ubah PIN karyawan (disimpan HASH, bukan mentah). Mengembalikan
  /// nilai pinHash baru (pemanggil yang menulis ke DB, atau pakai
  /// [setPin] yang langsung menulis).
  static String newPinHash(String pin) => createPinHash(pin);

  /// Tulis PIN baru karyawan ke DB. Validasi format dulu.
  Future<void> setPin(AppDatabase db, String employeeId, String pin) async {
    validatePinFormat(pin);
    final employee = await (db.select(db.employees)
          ..where((e) => e.id.equals(employeeId)))
        .getSingleOrNull();
    if (employee == null) {
      throw ArgumentError('Karyawan tidak ditemukan: $employeeId');
    }
    await (db.update(db.employees)..where((e) => e.id.equals(employeeId)))
        .write(
      EmployeesCompanion(
        pinHash: Value(createPinHash(pin)),
        updatedAt: Value(nowMs()),
      ),
    );
    _failCounts.remove(employeeId);
    _lockedUntil.remove(employeeId);
  }

  /// Verifikasi PIN karyawan.
  /// - PIN belum diatur -> throw [PinNotSetException].
  /// - Terkunci (3x salah, <1 menit) -> throw [PinLockedException].
  /// - PIN benar -> true (penghitung salah di-reset).
  /// - PIN salah -> false; salah ke-3 -> throw [PinLockedException].
  Future<bool> verifyPin(
    AppDatabase db,
    String employeeId,
    String pin,
  ) async {
    if (isLocked(employeeId)) {
      throw PinLockedException(_lockedUntil[employeeId]!);
    }
    final employee = await (db.select(db.employees)
          ..where((e) => e.id.equals(employeeId)))
        .getSingleOrNull();
    if (employee == null) {
      throw ArgumentError('Karyawan tidak ditemukan: $employeeId');
    }
    if (employee.pinHash.isEmpty) {
      throw PinNotSetException(employee.name);
    }
    if (checkPinHash(pin, employee.pinHash)) {
      _failCounts.remove(employeeId);
      _lockedUntil.remove(employeeId);
      return true;
    }
    final fails = (_failCounts[employeeId] ?? 0) + 1;
    _failCounts[employeeId] = fails;
    if (fails >= maxAttempts) {
      final until = _now().add(lockDuration);
      _lockedUntil[employeeId] = until;
      throw PinLockedException(until);
    }
    return false;
  }

  static String _bytesToHex(List<int> bytes) =>
      bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

  static List<int> _hexToBytes(String hex) {
    final out = <int>[];
    for (var i = 0; i < hex.length; i += 2) {
      out.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }
    return out;
  }
}

/// Provider AuthService (satu instance per aplikasi; di-override di test
/// bila perlu jam palsu untuk uji kunci 1 menit).
final authServiceProvider = Provider<AuthService>((ref) => AuthService());
