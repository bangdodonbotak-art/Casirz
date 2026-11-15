// Casirz ERP — Fase 7.
// Backup / restore manual (BLUEPRINT-FLUTTER.md §11 butir 8).
//
// Format `casirz-backup-v1`: SATU file JSON berisi SEMUA tabel Drift
// (master + transaksi + outbox + watermark + konflik) — beda dari
// `casirz-export-v1.json` (format migrasi web v2, §9 — hanya produk /
// pelanggan / promo / penjualan / karyawan, TANPA jurnal dan TANPA
// stok bahan; TIDAK cocok untuk backup penuh, jadi tidak dipakai di
// sini). Bentuk file backup:
//
//   {
//     "format": "casirz-backup-v1",
//     "exportedAt": "2026-11-15T10:00:00.000Z",
//     "tables": {
//       "products": [ {"id": "...", "name": "...", ...}, ... ],
//       "sales": [ ... ],
//       ...
//     }
//   }
//
// Aturan import (sama seperti migrasi §9): VALIDASI DULU, TULIS
// BELAKANGAN — format salah / struktur rusak -> dibatalkan + pesan
// error, bukan data setengah. Import jalan dalam SATU transaksi Drift:
// hapus semua data lama (anak dulu) lalu isi dari file (induk dulu,
// foreign key aman). Setting `deviceId` TIDAK ditimpa (identitas device
// ini dipertahankan — restore di HP baru tetap memakai id device baru).
//
// CATATAN JUJUR — file backup TIDAK terenkripsi. Ini JSON biasa yang
// bisa dibaca siapa pun yang memegang filenya. "Enkripsi sederhana"
// (XOR / base64) sengaja TIDAK dipalsukan sebagai enkripsi — itu bukan
// enkripsi. Simpan file di tempat yang hanya Dony yang bisa buka
// (Drive pribadi / HP sendiri), jangan kirim ke grup/WA umum.
// Enkripsi pakai kata sandi dicatat sebagai open item (butuh passphrase
// + kunci turunan, dikerjakan bila Dony minta).
//
// Pengingat mingguan: [needsBackupReminder] true bila belum pernah
// backup atau backup terakhir > 7 hari — ditampilkan sebagai BANNER
// di Pengaturan (bukan notifikasi sistem).
import 'dart:convert';

import 'db.dart';

/// File backup tidak valid (format / struktur salah).
class BackupInvalid implements Exception {
  BackupInvalid(this.message);
  final String message;

  @override
  String toString() => 'BackupInvalid: $message';
}

/// Ringkasan restore (untuk pesan sukses di UI).
class BackupRestoreSummary {
  const BackupRestoreSummary({required this.tables, required this.rows});
  final int tables;
  final int rows;
}

class BackupService {
  BackupService(this.db);

  final AppDatabase db;

  static const String format = 'casirz-backup-v1';

  /// Semua tabel yang ikut backup. Urutan = induk dulu (aman foreign
  /// key saat isi); hapus memakai urutan terbalik (anak dulu).
  static const List<String> tablesParentFirst = [
    'accounts',
    'employees',
    'customers',
    'products',
    'ingredients',
    'promos',
    'shop_tables',
    'shifts',
    'recipes',
    'recipe_lines',
    'orders',
    'order_lines',
    'sales',
    'sale_lines',
    'sale_payments',
    'stock_moves',
    'journals',
    'journal_lines',
    'assets',
    'expenses',
    'attendance',
    'payrolls',
    'stock_opnames',
    'stock_opname_lines',
    'petty_cash',
    'settings',
    'sync_outbox',
    'sync_state',
    'sync_conflicts',
  ];

  /// Nama file saran, mis. casirz-backup-20261115-103000.json
  static String fileNameFor(DateTime when) {
    String two(int n) => n.toString().padLeft(2, '0');
    return 'casirz-backup-${when.year}${two(when.month)}${two(when.day)}'
        '-${two(when.hour)}${two(when.minute)}${two(when.second)}.json';
  }

  /// Export seluruh database ke map JSON (siap jsonEncode).
  Future<Map<String, Object?>> exportJson() async {
    final tables = <String, Object?>{};
    for (final table in tablesParentFirst) {
      final rows = await db.customSelect('SELECT * FROM "$table"').get();
      tables[table] = [
        for (final r in rows) Map<String, Object?>.from(r.data),
      ];
    }
    return {
      'format': format,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'tables': tables,
    };
  }

  /// Export ke string JSON (dipakai UI + test).
  Future<String> exportJsonString() async {
    return jsonEncode(await exportJson());
  }

  /// Restore dari string JSON. Validasi dulu, tulis belakangan.
  /// Throw [BackupInvalid] bila format/struktur salah — database
  /// TIDAK berubah sedikit pun dalam kasus itu.
  Future<BackupRestoreSummary> importJsonString(String jsonStr) async {
    final decoded = jsonDecode(jsonStr);
    if (decoded is! Map<String, dynamic>) {
      throw BackupInvalid('File bukan objek JSON.');
    }
    return importJson(Map<String, Object?>.from(decoded));
  }

  /// Restore dari map yang sudah di-decode.
  Future<BackupRestoreSummary> importJson(
    Map<String, Object?> data,
  ) async {
    if (data['format'] != format) {
      throw BackupInvalid(
        'Format bukan $format (ditemukan: ${data['format']}). '
        'File ini bukan backup Casirz.',
      );
    }
    final rawTables = data['tables'];
    if (rawTables is! Map) {
      throw BackupInvalid('File backup tidak berisi tabel (key "tables").');
    }
    // Validasi SEMUA isi sebelum menulis apa pun.
    final tables = <String, List<Map<String, Object?>>>{};
    for (final entry in rawTables.entries) {
      final table = entry.key;
      if (!tablesParentFirst.contains(table)) {
        throw BackupInvalid('Tabel tidak dikenal di backup: $table.');
      }
      final rows = entry.value;
      if (rows is! List) {
        throw BackupInvalid('Isi tabel $table bukan daftar baris.');
      }
      final parsed = <Map<String, Object?>>[];
      for (final row in rows) {
        if (row is! Map) {
          throw BackupInvalid('Baris di tabel $table bukan objek.');
        }
        final map = Map<String, Object?>.from(row);
        if (map['id'] is! String || (map['id'] as String).isEmpty) {
          throw BackupInvalid('Baris di tabel $table tidak punya id.');
        }
        parsed.add(map);
      }
      tables[table] = parsed;
    }

    var restored = 0;
    await db.transaction(() async {
      // Hapus semua data lama — anak dulu (urutan terbalik).
      // Kecuali settings.deviceId: identitas device INI dipertahankan
      // (jangan ikut terhapus — kalau terhapus lalu tidak diisi ulang
      // dari file, device mendapat id baru dan tie-break LWW berubah).
      for (final table in tablesParentFirst.reversed) {
        if (table == 'settings') {
          await db.customStatement(
            'DELETE FROM "settings" WHERE "id" != \'deviceId\'',
          );
        } else {
          await db.customStatement('DELETE FROM "$table"');
        }
      }
      // Isi dari file — induk dulu.
      for (final table in tablesParentFirst) {
        final columns = await _columns(table);
        for (final row in tables[table] ?? const []) {
          // deviceId = identitas device INI — jangan ditimpa backup.
          if (table == 'settings' && row['id'] == 'deviceId') continue;
          final filtered = <String, Object?>{};
          for (final e in row.entries) {
            if (columns.contains(e.key)) {
              filtered[e.key] = _normalize(e.value);
            }
          }
          if (filtered.isEmpty) continue;
          final cols = filtered.keys.toList();
          final names = cols.map((c) => '"$c"').join(', ');
          final placeholders = List.filled(cols.length, '?').join(', ');
          await db.customStatement(
            'INSERT OR REPLACE INTO "$table" ($names) '
            'VALUES ($placeholders)',
            [for (final c in cols) filtered[c]],
          );
          restored++;
        }
      }
    });
    return BackupRestoreSummary(tables: tables.length, rows: restored);
  }

  // -- pengingat backup mingguan --------------------------------------------

  /// Jam backup sukses terakhir (null = belum pernah backup).
  Future<DateTime?> lastBackupAt() async {
    final raw = await db.getSetting('lastBackupAt');
    final ms = raw == null ? null : int.tryParse(raw);
    return ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
  }

  /// True bila belum pernah backup ATAU backup terakhir > 7 hari.
  /// Dipakai banner di Pengaturan (bukan notifikasi sistem).
  Future<bool> needsBackupReminder() async {
    final last = await lastBackupAt();
    if (last == null) return true;
    return DateTime.now().difference(last).inDays >= 7;
  }

  /// Catat backup sukses (dipanggil UI setelah file tersimpan).
  Future<void> markBackedUp() async {
    await db.setSetting('lastBackupAt', nowMs().toString());
  }

  // -- util -----------------------------------------------------------------

  final Map<String, Set<String>> _columnsCache = {};

  Future<Set<String>> _columns(String table) async {
    final cached = _columnsCache[table];
    if (cached != null) return cached;
    final rows =
        await db.customSelect('PRAGMA table_info("$table")').get();
    final names = <String>{
      for (final r in rows) r.data['name'] as String,
    };
    _columnsCache[table] = names;
    return names;
  }

  static Object? _normalize(Object? value) {
    if (value is bool) return value ? 1 : 0;
    if (value is num || value is String || value == null) return value;
    return value.toString();
  }
}
