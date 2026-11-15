// Casirz ERP — Fase 5 (Modul D Staf).
// Provider Riverpod untuk sesi login + refresh layar Staf.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/session.dart';
import '../pos/pos_providers.dart';

/// Sesi login (satu sesi per aplikasi). Di-override nilainya di app.dart
/// supaya SessionNotifier memakai database yang sama dengan aplikasi.
final sessionProvider =
    StateNotifierProvider<SessionNotifier, SessionState>((ref) {
  return SessionNotifier(ref.watch(databaseProvider));
});

/// Dinaikkan tiap ada perubahan data staf (karyawan/absensi/payroll)
/// supaya layar Staf me-refresh FutureProvider-nya.
final staffVersionProvider = StateProvider<int>((ref) => 0);
