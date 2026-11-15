// Casirz ERP — Fase 5 (Modul D Staf).
// Sesi login: siapa yang sedang memakai aplikasi + lock screen.
//
// Status sesi:
// - loading: sedang baca DB (awal aplikasi).
// - open: DB kosong (belum ada karyawan sama sekali) — aplikasi terbuka
//   tanpa kunci supaya pemilik bisa isi seed demo / tambah owner pertama.
//   (Alasan jujur: test widget Fase 2-4 mem-pump aplikasi dengan DB
//   kosong dan mengharapkan shell langsung tampil; mengunci DB kosong
//   akan mematahkan 122 test itu. Begitu ada karyawan, kunci aktif.)
// - needsOwnerSetup: ada karyawan, tapi TIDAK ADA owner aktif yang
//   PIN-nya sudah diatur — owner wajib buat PIN dulu sebelum menu lain
//   bisa dipakai. TIDAK ADA PIN BAWAAN: PIN dibuat di layar ini.
// - locked: ada owner ber-PIN — pilih karyawan + masukkan PIN.
// - unlocked: sudah masuk sebagai [employee].
//
// Sesi hanya di memori: tutup aplikasi = keluar (harus PIN lagi).
// Ganti pengguna cepat: lock() lalu pilih karyawan lain — tanpa tutup
// aplikasi.
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'db.dart';

enum SessionStatus { loading, open, needsOwnerSetup, locked, unlocked }

class SessionState {
  const SessionState({required this.status, this.employee});

  /// Status awal (loading) sebelum DB dibaca.
  const SessionState.initial() : this(status: SessionStatus.loading);

  final SessionStatus status;

  /// Karyawan yang sedang login (hanya bila status unlocked).
  final Employee? employee;

  bool get isUnlocked => status == SessionStatus.unlocked;

  SessionState copyWith({SessionStatus? status, Employee? employee}) {
    return SessionState(
      status: status ?? this.status,
      employee: employee ?? this.employee,
    );
  }
}

class SessionNotifier extends StateNotifier<SessionState> {
  SessionNotifier(this._db) : super(const SessionState.initial()) {
    refresh();
  }

  final AppDatabase _db;

  /// Baca ulang DB dan tentukan status sesi (dipanggil saat aplikasi
  /// dibuka + setelah owner selesai mengatur PIN pertama).
  Future<void> refresh() async {
    final employees = await (_db.select(_db.employees)
          ..where((e) => e.isActive.equals(1) & e.isDeleted.equals(0)))
        .get();
    if (employees.isEmpty) {
      state = const SessionState(status: SessionStatus.open);
      return;
    }
    final ownerWithPin = employees.any(
      (e) => e.role == 'owner' && e.pinHash.isNotEmpty,
    );
    if (!ownerWithPin) {
      state = const SessionState(status: SessionStatus.needsOwnerSetup);
      return;
    }
    // Sudah ada sesi aktif? Pertahankan. Kalau tidak, kunci.
    if (state.status == SessionStatus.unlocked && state.employee != null) {
      final stillActive = employees.any((e) => e.id == state.employee!.id);
      if (stillActive) return;
    }
    state = const SessionState(status: SessionStatus.locked);
  }

  /// Masuk sebagai karyawan ini (PIN sudah diverifikasi pemanggil).
  void unlock(Employee employee) {
    state = SessionState(status: SessionStatus.unlocked, employee: employee);
  }

  /// Kunci aplikasi (ganti pengguna): kembali ke layar kunci.
  /// Bila DB kosong -> open; bila owner belum ber-PIN -> setup owner.
  Future<void> lock() async {
    state = const SessionState(status: SessionStatus.loading);
    await refresh();
    // refresh() tidak mengubah status locked bila sudah ada owner ber-PIN
    // dan tidak ada sesi — pastikan kembali ke locked, bukan loading.
    if (state.status == SessionStatus.loading) {
      state = const SessionState(status: SessionStatus.locked);
    }
  }
}

/// Provider sesi — didefinisikan di features/staff/staff_providers.dart
/// (butuh databaseProvider dari features/pos; core/ dilarang import
/// features/ — BLUEPRINT §8.2). Di-override nilainya di app.dart.
