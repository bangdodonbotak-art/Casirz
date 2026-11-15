// Casirz ERP — Fase 2.
// Entry point: buka database lokal, muat tema tersimpan, jalankan app.
// Database lokal (Drift/SQLite) = sumber kebenaran; UI tidak pernah
// bicara ke internet langsung (BLUEPRINT-FLUTTER.md §1.1).
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'core/db.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Data locale id_ID untuk DateFormat('...', 'id_ID') di semua halaman
  // (tanpa ini DateFormat locale Indonesia throw LocaleDataException —
  // bug laten yang baru ketahuan saat halaman Laporan dipump di test).
  await initializeDateFormatting('id_ID', null);
  final db = AppDatabase.open();
  final savedTheme = await db.getSetting('themeMode');
  runApp(CasirzApp(db: db, initialDark: savedTheme == 'dark'));
}
