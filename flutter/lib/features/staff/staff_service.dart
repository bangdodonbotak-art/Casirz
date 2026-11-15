// Casirz ERP — Fase 5 (Modul D Staf).
// Logika staf: karyawan, absensi PIN, rekap kehadiran, payroll.
//
// - Absensi PAKAI PIN saja (keputusan Dony — BUKAN selfie, tanpa kamera).
// - Gaji: bulanan = gaji pokok; harian = tarif harian x hari hadir.
//   Potongan/tambahan manual WAJIB disertai alasan (kolom payrolls.note)
//   — tidak ada rumus potongan karangan.
// - Proses gaji memanggil AccountingService.paySalary (D 5130 / K 1000|
//   1010, idempotent per employee+period) — JANGAN tulis jurnal manual.
// - Karyawan nonaktif = tombstone (isActive 0): riwayat absensi +
//   payroll tetap bisa dibaca; proses gaji baru DITOLAK.
import 'package:drift/drift.dart';
import 'package:intl/intl.dart';

import '../../core/accounting_service.dart';
import '../../core/db.dart';
import '../../core/money.dart';
import '../../core/sync.dart';
import 'auth.dart';

/// Awal hari (tengah malam lokal) dalam epoch ms — kunci baris absensi.
int dayStartMs(DateTime d) =>
    DateTime(d.year, d.month, d.day).millisecondsSinceEpoch;

/// Rentang epoch ms satu periode 'yyyy-MM' (awal bulan s.d. awal bulan
/// berikut, eksklusif).
({int start, int end}) monthRange(String period) {
  final parts = period.split('-');
  if (parts.length != 2) {
    throw ArgumentError('Periode harus format yyyy-MM, dapat: $period');
  }
  final year = int.parse(parts[0]);
  final month = int.parse(parts[1]);
  final start = DateTime(year, month);
  final end = month == 12
      ? DateTime(year + 1, 1)
      : DateTime(year, month + 1);
  return (
    start: start.millisecondsSinceEpoch,
    end: end.millisecondsSinceEpoch,
  );
}

/// Label periode Indonesia: '2026-11' -> 'November 2026'.
String periodLabel(String period) {
  final r = monthRange(period);
  return DateFormat('MMMM yyyy', 'id_ID')
      .format(DateTime.fromMillisecondsSinceEpoch(r.start));
}

/// 'yyyy-MM' bulan ini.
String currentPeriod([DateTime? now]) {
  final d = now ?? DateTime.now();
  return '${d.year}-${d.month.toString().padLeft(2, '0')}';
}

/// Jam masuk dari settings ('HH:mm', default '08:00').
Future<(int, int)> getWorkStart(AppDatabase db) async {
  final raw = await db.getSetting('workStartTime') ?? '08:00';
  final parts = raw.split(':');
  final h = int.tryParse(parts[0]) ?? 8;
  final m = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;
  return (h.clamp(0, 23), m.clamp(0, 59));
}

/// Simpan jam masuk ('HH:mm').
Future<void> setWorkStart(AppDatabase db, String hhmm) async {
  final parts = hhmm.split(':');
  if (parts.length != 2 ||
      int.tryParse(parts[0]) == null ||
      int.tryParse(parts[1]) == null) {
    throw ArgumentError('Jam masuk harus format HH:mm (contoh 08:00).');
  }
  final h = int.parse(parts[0]);
  final m = int.parse(parts[1]);
  if (h < 0 || h > 23 || m < 0 || m > 59) {
    throw ArgumentError('Jam masuk tidak valid: $hhmm');
  }
  await db.setSetting(
    'workStartTime',
    '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}',
  );
}

/// Format menit kerja: 540 -> '9 jam'; 510 -> '8,5 jam'.
String fmtWorkMinutes(int minutes) {
  final hours = minutes / 60;
  final text = NumberFormat('#,##0.#', 'id_ID').format(hours);
  return '$text jam';
}

/// Rekap kehadiran satu karyawan satu periode.
class AttendanceRecap {
  const AttendanceRecap({
    required this.daysPresent,
    required this.totalMinutes,
    required this.lateDays,
    required this.notCheckedOutDays,
    required this.rows,
  });

  /// Hari hadir (ada check-in).
  final int daysPresent;

  /// Total menit kerja (hanya hari yang sudah check-out; hari lupa
  /// check-out dihitung 0 menit — JANGAN dikarang jamnya).
  final int totalMinutes;

  /// Hari telat (check-in setelah jam masuk).
  final int lateDays;

  /// Hari lupa check-out.
  final int notCheckedOutDays;

  final List<AttendanceRow> rows;
}

/// Hitung gaji satu periode (murni hitung — tanpa tulis DB).
class PayrollCalc {
  const PayrollCalc({
    required this.pokok,
    required this.additions,
    required this.deductions,
  });

  /// Gaji pokok periode: bulanan = baseSalary; harian = tarif x hari hadir.
  final int pokok;
  final int additions;
  final int deductions;

  int get gross => pokok + additions;
  int get net => gross - deductions;
}

class StaffService {
  // ------------------------------------------------------------------
  // Karyawan
  // ------------------------------------------------------------------

  static const List<String> roles = ['owner', 'manager', 'kasir'];
  static const List<String> salaryTypes = ['bulanan', 'harian'];

  /// Tambah karyawan baru (PIN kosong — Owner yang mengatur lewat UI).
  /// Mengembalikan id karyawan.
  static Future<String> createEmployee(
    AppDatabase db, {
    required String name,
    required String role,
    String salaryType = 'bulanan',
    int baseSalary = 0,
  }) async {
    if (name.trim().isEmpty) {
      throw ArgumentError('Nama karyawan wajib diisi.');
    }
    if (!roles.contains(role)) {
      throw ArgumentError('Peran harus owner/manager/kasir.');
    }
    if (!salaryTypes.contains(salaryType)) {
      throw ArgumentError('Tipe gaji harus bulanan/harian.');
    }
    if (baseSalary < 0) {
      throw ArgumentError('Gaji pokok tidak boleh negatif.');
    }
    final deviceId = await db.deviceId();
    final id = newId();
    await db.transaction(() async {
      final now = nowMs();
      await db.into(db.employees).insert(
            EmployeesCompanion.insert(
              id: id,
              name: name.trim(),
              role: role,
              pinHash: '',
              salaryType: Value(salaryType),
              baseSalary: Value(baseSalary),
              updatedAt: now,
              deviceId: deviceId,
            ),
          );
      await Outbox.write(
        db,
        table: 'employees',
        rowId: id,
        operation: 'insert',
        payload: {
          'id': id,
          'name': name.trim(),
          'role': role,
          'salaryType': salaryType,
          'baseSalary': baseSalary,
        },
      );
    });
    return id;
  }

  /// Ubah data karyawan (hanya field yang diisi). PIN TIDAK diubah di
  /// sini — atur PIN lewat AuthService.setPin (hanya Owner, via UI).
  static Future<void> updateEmployee(
    AppDatabase db,
    String employeeId, {
    String? name,
    String? role,
    String? salaryType,
    int? baseSalary,
  }) async {
    if (name != null && name.trim().isEmpty) {
      throw ArgumentError('Nama karyawan wajib diisi.');
    }
    if (role != null && !roles.contains(role)) {
      throw ArgumentError('Peran harus owner/manager/kasir.');
    }
    if (salaryType != null && !salaryTypes.contains(salaryType)) {
      throw ArgumentError('Tipe gaji harus bulanan/harian.');
    }
    if (baseSalary != null && baseSalary < 0) {
      throw ArgumentError('Gaji pokok tidak boleh negatif.');
    }
    final employee = await (db.select(db.employees)
          ..where((e) => e.id.equals(employeeId)))
        .getSingleOrNull();
    if (employee == null) {
      throw ArgumentError('Karyawan tidak ditemukan: $employeeId');
    }
    await db.transaction(() async {
      await (db.update(db.employees)..where((e) => e.id.equals(employeeId)))
          .write(
        EmployeesCompanion(
          name: name == null ? const Value.absent() : Value(name.trim()),
          role: role == null ? const Value.absent() : Value(role),
          salaryType:
              salaryType == null ? const Value.absent() : Value(salaryType),
          baseSalary:
              baseSalary == null ? const Value.absent() : Value(baseSalary),
          updatedAt: Value(nowMs()),
        ),
      );
      await Outbox.write(
        db,
        table: 'employees',
        rowId: employeeId,
        operation: 'update',
        payload: {'id': employeeId},
      );
    });
  }

  /// Nonaktifkan / aktifkan kembali karyawan (tombstone isActive — baris
  /// TIDAK dihapus; riwayat absensi + payroll tetap ada).
  static Future<void> setEmployeeActive(
    AppDatabase db,
    String employeeId,
    bool active,
  ) async {
    final employee = await (db.select(db.employees)
          ..where((e) => e.id.equals(employeeId)))
        .getSingleOrNull();
    if (employee == null) {
      throw ArgumentError('Karyawan tidak ditemukan: $employeeId');
    }
    await (db.update(db.employees)..where((e) => e.id.equals(employeeId)))
        .write(
      EmployeesCompanion(
        isActive: Value(active ? 1 : 0),
        updatedAt: Value(nowMs()),
      ),
    );
    await Outbox.write(
      db,
      table: 'employees',
      rowId: employeeId,
      operation: 'update',
      payload: {'id': employeeId, 'isActive': active ? 1 : 0},
    );
  }

  /// Semua karyawan (termasuk nonaktif) — untuk layar Staf.
  static Future<List<Employee>> allEmployees(AppDatabase db) async {
    return (db.select(db.employees)
          ..where((e) => e.isDeleted.equals(0))
          ..orderBy([(e) => OrderingTerm.asc(e.name)]))
        .get();
  }

  // ------------------------------------------------------------------
  // Absensi PIN
  // ------------------------------------------------------------------

  /// Baris absensi satu karyawan satu hari (null bila belum ada).
  static Future<AttendanceRow?> attendanceForDay(
    AppDatabase db,
    String employeeId,
    DateTime day,
  ) async {
    return (db.select(db.attendance)
          ..where(
            (a) =>
                a.employeeId.equals(employeeId) &
                a.date.equals(dayStartMs(day)),
          ))
        .getSingleOrNull();
  }

  /// Check-in: pilih nama -> PIN -> tercatat waktu. PIN diverifikasi
  /// lewat [auth] (kunci 3x salah berlaku di sini juga).
  static Future<AttendanceRow> clockIn(
    AppDatabase db, {
    required String employeeId,
    required String pin,
    DateTime? now,
    AuthService? auth,
  }) async {
    final at = now ?? DateTime.now();
    final authService = auth ?? AuthService();
    final ok = await authService.verifyPin(db, employeeId, pin);
    if (!ok) {
      throw StateError('PIN salah. Coba lagi.');
    }
    final employee = await (db.select(db.employees)
          ..where((e) => e.id.equals(employeeId)))
        .getSingleOrNull();
    if (employee == null) {
      throw ArgumentError('Karyawan tidak ditemukan: $employeeId');
    }
    if (employee.isActive != 1) {
      throw StateError(
        '${employee.name} sudah nonaktif — tidak bisa absen.',
      );
    }
    final existing = await attendanceForDay(db, employeeId, at);
    if (existing != null && existing.clockIn != null) {
      throw StateError(
        '${employee.name} sudah check-in hari ini '
        '(${_fmtTime(existing.clockIn!)}).',
      );
    }
    final deviceId = await db.deviceId();
    final rowId = existing?.id ?? newId();
    final row = AttendanceRow(
      id: rowId,
      employeeId: employeeId,
      date: dayStartMs(at),
      clockIn: at.millisecondsSinceEpoch,
      clockOut: null,
      pinVerified: 1,
      updatedAt: nowMs(),
      deviceId: deviceId,
    );
    await db.transaction(() async {
      if (existing == null) {
        await db.into(db.attendance).insert(
              AttendanceCompanion.insert(
                id: rowId,
                employeeId: employeeId,
                date: dayStartMs(at),
                clockIn: Value(at.millisecondsSinceEpoch),
                pinVerified: const Value(1),
                updatedAt: nowMs(),
                deviceId: deviceId,
              ),
            );
        await Outbox.write(
          db,
          table: 'attendance',
          rowId: rowId,
          operation: 'insert',
          payload: {'id': rowId, 'employeeId': employeeId},
        );
      } else {
        // Baris hari ini sudah ada (tanpa check-in) — satu-satunya
        // update yang diizinkan tabel APPEND attendance (BLUEPRINT §3.2).
        await (db.update(db.attendance)..where((a) => a.id.equals(rowId)))
            .write(
          AttendanceCompanion(
            clockIn: Value(at.millisecondsSinceEpoch),
            pinVerified: const Value(1),
            updatedAt: Value(nowMs()),
          ),
        );
        await Outbox.write(
          db,
          table: 'attendance',
          rowId: rowId,
          operation: 'update',
          payload: {'id': rowId, 'employeeId': employeeId},
        );
      }
    });
    return row;
  }

  /// Check-out: PIN lagi -> tercatat waktu.
  static Future<AttendanceRow> clockOut(
    AppDatabase db, {
    required String employeeId,
    required String pin,
    DateTime? now,
    AuthService? auth,
  }) async {
    final at = now ?? DateTime.now();
    final authService = auth ?? AuthService();
    final ok = await authService.verifyPin(db, employeeId, pin);
    if (!ok) {
      throw StateError('PIN salah. Coba lagi.');
    }
    final employee = await (db.select(db.employees)
          ..where((e) => e.id.equals(employeeId)))
        .getSingleOrNull();
    if (employee == null) {
      throw ArgumentError('Karyawan tidak ditemukan: $employeeId');
    }
    final existing = await attendanceForDay(db, employeeId, at);
    if (existing == null || existing.clockIn == null) {
      throw StateError(
        '${employee.name} belum check-in hari ini — check-in dulu.',
      );
    }
    if (existing.clockOut != null) {
      throw StateError(
        '${employee.name} sudah check-out hari ini '
        '(${_fmtTime(existing.clockOut!)}).',
      );
    }
    if (at.millisecondsSinceEpoch < existing.clockIn!) {
      throw StateError('Waktu check-out tidak boleh sebelum check-in.');
    }
    await db.transaction(() async {
      await (db.update(db.attendance)
            ..where((a) => a.id.equals(existing.id)))
          .write(
        AttendanceCompanion(
          clockOut: Value(at.millisecondsSinceEpoch),
          updatedAt: Value(nowMs()),
        ),
      );
      await Outbox.write(
        db,
        table: 'attendance',
        rowId: existing.id,
        operation: 'update',
        payload: {'id': existing.id, 'employeeId': employeeId},
      );
    });
    return existing.copyWith(
      clockOut: Value(at.millisecondsSinceEpoch),
      updatedAt: nowMs(),
    );
  }

  /// Menit kerja satu baris: 0 + flag bila belum check-out (JANGAN
  /// dikarang jamnya).
  static int workMinutes(AttendanceRow row) {
    if (row.clockIn == null || row.clockOut == null) return 0;
    return (row.clockOut! - row.clockIn!) ~/ 60000;
  }

  /// True bila baris ini lupa check-out.
  static bool isNotCheckedOut(AttendanceRow row) =>
      row.clockIn != null && row.clockOut == null;

  /// Rekap kehadiran satu karyawan satu periode ('yyyy-MM').
  /// Telat = check-in setelah jam masuk ([workStart], default 08:00).
  static Future<AttendanceRecap> recap(
    AppDatabase db,
    String employeeId,
    String period, {
    (int, int)? workStart,
  }) async {
    final start = workStart ?? await getWorkStart(db);
    final r = monthRange(period);
    final rows = await (db.select(db.attendance)
          ..where(
            (a) =>
                a.employeeId.equals(employeeId) &
                a.date.isBiggerOrEqualValue(r.start) &
                a.date.isSmallerThanValue(r.end),
          )
          ..orderBy([(a) => OrderingTerm.asc(a.date)]))
        .get();
    var daysPresent = 0;
    var totalMinutes = 0;
    var lateDays = 0;
    var notCheckedOut = 0;
    for (final row in rows) {
      if (row.clockIn == null) continue;
      daysPresent++;
      totalMinutes += workMinutes(row);
      if (isNotCheckedOut(row)) notCheckedOut++;
      final day = DateTime.fromMillisecondsSinceEpoch(row.date);
      final startMs = DateTime(
        day.year,
        day.month,
        day.day,
        start.$1,
        start.$2,
      ).millisecondsSinceEpoch;
      if (row.clockIn! > startMs) lateDays++;
    }
    return AttendanceRecap(
      daysPresent: daysPresent,
      totalMinutes: totalMinutes,
      lateDays: lateDays,
      notCheckedOutDays: notCheckedOut,
      rows: rows,
    );
  }

  /// Absensi hari ini untuk semua karyawan aktif (dipakai tab Absensi).
  static Future<Map<String, AttendanceRow?>> todayAttendance(
    AppDatabase db, {
    DateTime? now,
  }) async {
    final day = now ?? DateTime.now();
    final employees = await (db.select(db.employees)
          ..where((e) => e.isActive.equals(1) & e.isDeleted.equals(0)))
        .get();
    final out = <String, AttendanceRow?>{};
    for (final e in employees) {
      out[e.id] = await attendanceForDay(db, e.id, day);
    }
    return out;
  }

  // ------------------------------------------------------------------
  // Payroll
  // ------------------------------------------------------------------

  /// Hitung gaji periode dari data karyawan + hari hadir.
  /// - Bulanan: pokok = baseSalary (tidak tergantung hari hadir).
  /// - Harian: pokok = tarif harian x hari hadir.
  static PayrollCalc computePay({
    required Employee employee,
    required int daysPresent,
    int additions = 0,
    int deductions = 0,
  }) {
    if (additions < 0 || deductions < 0) {
      throw ArgumentError('Tambahan/potongan tidak boleh negatif.');
    }
    final pokok = employee.salaryType == 'harian'
        ? employee.baseSalary * daysPresent
        : employee.baseSalary;
    return PayrollCalc(
      pokok: pokok,
      additions: additions,
      deductions: deductions,
    );
  }

  /// Payroll satu karyawan satu periode (null bila belum diproses).
  static Future<Payroll?> payrollFor(
    AppDatabase db,
    String employeeId,
    String period,
  ) async {
    return (db.select(db.payrolls)
          ..where(
            (p) =>
                p.employeeId.equals(employeeId) & p.period.equals(period),
          ))
        .getSingleOrNull();
  }

  /// Semua payroll satu periode (untuk daftar per periode).
  static Future<List<Payroll>> payrollsForPeriod(
    AppDatabase db,
    String period,
  ) async {
    return (db.select(db.payrolls)
          ..where((p) => p.period.equals(period))
          ..orderBy([(p) => OrderingTerm.asc(p.updatedAt)]))
        .get();
  }

  /// Proses gaji satu karyawan satu periode:
  /// hitung dari kehadiran -> panggil paySalary (D 5130 / K 1000|1010)
  /// -> catat tambahan + alasan di baris payroll.
  /// Idempotent: periode yang sama diproses 2x -> throw, jurnal tetap 1.
  /// Karyawan nonaktif -> throw.
  static Future<String> processPayroll(
    AppDatabase db, {
    required String employeeId,
    required String period,
    int additions = 0,
    String additionsNote = '',
    int deductions = 0,
    String deductionsNote = '',
    String payFrom = 'tunai',
    DateTime? now,
  }) async {
    if (payFrom != 'tunai' && payFrom != 'bank') {
      throw ArgumentError('payFrom harus tunai/bank.');
    }
    final employee = await (db.select(db.employees)
          ..where((e) => e.id.equals(employeeId)))
        .getSingleOrNull();
    if (employee == null) {
      throw ArgumentError('Karyawan tidak ditemukan: $employeeId');
    }
    if (employee.isActive != 1) {
      throw StateError(
        'Gaji ${employee.name} tidak bisa diproses: karyawan nonaktif.',
      );
    }
    final existing = await payrollFor(db, employeeId, period);
    if (existing != null) {
      throw StateError(
        'Gaji ${employee.name} periode ${periodLabel(period)} sudah '
        'diproses (bersih ${fmt(existing.netPay)}). Tidak diproses ulang.',
      );
    }
    final attendance = await recap(db, employeeId, period);
    final calc = computePay(
      employee: employee,
      daysPresent: attendance.daysPresent,
      additions: additions,
      deductions: deductions,
    );
    if (calc.net < 0) {
      throw ArgumentError(
        'Gaji bersih negatif — potongan melebihi gaji kotor.',
      );
    }
    final payrollId = await AccountingService.paySalary(
      db,
      employeeId: employeeId,
      period: period,
      baseSalary: calc.gross,
      deductions: deductions,
      payFrom: payFrom,
    );
    // Tambahan + alasan dicatat di baris payroll yang BARU dibuat di
    // atas (satu operasi proses gaji yang sama; paySalary tidak punya
    // parameter tambahan/alasan dan signature-nya beku — jadi alasan
    // ditulis di sini, segera setelah insert, bukan di proses lain).
    final noteParts = <String>[];
    if (additions > 0) {
      noteParts.add(
        'Tambahan ${fmt(additions)}'
        '${additionsNote.trim().isEmpty ? '' : ': ${additionsNote.trim()}'}',
      );
    }
    if (deductions > 0) {
      noteParts.add(
        'Potongan ${fmt(deductions)}'
        '${deductionsNote.trim().isEmpty ? '' : ': ${deductionsNote.trim()}'}',
      );
    }
    if (additions > 0 || noteParts.isNotEmpty) {
      await (db.update(db.payrolls)..where((p) => p.id.equals(payrollId)))
          .write(
        PayrollsCompanion(
          additions: Value(additions),
          note: Value(
            noteParts.isEmpty ? null : noteParts.join('; '),
          ),
        ),
      );
    }
    return payrollId;
  }

  /// Teks slip gaji (dibagikan via share_plus — BUKAN PDF).
  static String slipText({
    required String storeName,
    required Employee employee,
    required Payroll payroll,
    required int daysPresent,
    required int totalMinutes,
    required int lateDays,
  }) {
    final buf = StringBuffer();
    buf.writeln('SLIP GAJI — $storeName');
    buf.writeln('Periode: ${periodLabel(payroll.period)}');
    buf.writeln('Nama: ${employee.name} (${roleFromString(employee.role).label})');
    buf.writeln(
      'Tipe gaji: ${employee.salaryType == 'harian' ? 'Harian' : 'Bulanan'}',
    );
    buf.writeln(
      'Gaji pokok: ${fmt(payroll.baseSalary - payroll.additions)}',
    );
    if (employee.salaryType == 'harian') {
      buf.writeln('Tarif harian: ${fmt(employee.baseSalary)}');
    }
    buf.writeln(
      'Hadir: $daysPresent hari (${fmtWorkMinutes(totalMinutes)}'
      '${lateDays > 0 ? ', telat $lateDays hari' : ''})',
    );
    if (payroll.additions > 0) {
      buf.writeln('Tambahan: ${fmt(payroll.additions)}');
    }
    if (payroll.deductions > 0) {
      buf.writeln('Potongan: ${fmt(payroll.deductions)}');
    }
    if (payroll.note != null && payroll.note!.isNotEmpty) {
      buf.writeln('Catatan: ${payroll.note}');
    }
    buf.writeln('Gaji bersih: ${fmt(payroll.netPay)}');
    if (payroll.paidAt != null) {
      final paid = DateTime.fromMillisecondsSinceEpoch(payroll.paidAt!);
      buf.writeln(
        'Dibayar: ${DateFormat('dd MMM yyyy HH:mm', 'id_ID').format(paid)}',
      );
    }
    buf.writeln('Status: Diproses');
    return buf.toString();
  }

  static String _fmtTime(int epochMs) {
    final d = DateTime.fromMillisecondsSinceEpoch(epochMs);
    return DateFormat('HH:mm', 'id_ID').format(d);
  }
}
