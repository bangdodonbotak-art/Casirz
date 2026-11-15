// Casirz ERP — Fase 7.
// Sync engine aktif: kuras outbox (push) + tarik delta (pull) lewat
// transport abstrak, supaya bisa dites dengan fake transport tanpa
// Supabase sungguhan.
//
// ATURAN BEKU (BLUEPRINT-FLUTTER.md §5.3, §11):
// - Push FIFO (paling lama dulu), BERHENTI di gagal pertama — urutan
//   penting: penjualan tidak boleh sampai ke server sebelum produknya.
// - Pull delta per tabel memakai watermark syncState.lastPulledAt
//   (hanya yang berubah yang diunduh).
// - APPEND (sales, saleLines, stockMoves, journals, ...) = INSERT OR
//   IGNORE by UUID, tidak pernah UPDATE/DELETE. Pengecualian tercatat:
//   flag void (sales.voided/voidedAt) dan clock-in/out (attendance)
//   BOLEH diperbarui saat pull bila baris remote lebih baru — keduanya
//   menaikkan updatedAt saat berubah (lihat voidSale / clockOut).
// - MASTER = last-write-wins by updatedAt, seri -> deviceId penentu
//   (string deviceId yang lebih besar menang); yang kalah dicatat di
//   tabel syncConflicts + daftar [RealSyncEngine.conflicts].
// - Hapus = tombstone (_deleted = 1); baris tidak pernah dihapus fisik
//   sebelum semua device sempat menariknya.
// - Database lokal = sumber kebenaran; UI tidak pernah bicara ke
//   jaringan — hanya engine ini yang memakai transport.
//
// KONVENSI NAMA KOLOM JARAK JAUH: tabel + kolom Supabase memakai nama
// yang SAMA PERSIS dengan kolom SQLite lokal — yaitu snake_case hasil
// codegen Drift (mis. `updated_at`, `device_id`, `_deleted`,
// `sale_lines`, `sale_id`). Skema Supabase (saat dibuat nanti) WAJIB
// mengikuti konvensi ini — tidak ada pemetaan nama di transport.
// (AWAS: nama Dart-nya camelCase — `updatedAt` di Dart = `updated_at`
// di SQLite. Jangan tertukar.)
//
// CATATAN JUJUR — payload outbox Fase 1-6 SEBAGIAN (mis. payload sales
// hanya berisi id/code/date/channel/total/paid/change). Karena itu push
// TIDAK mengirim payload outbox mentah: engine membaca BARIS LENGKAP
// dari SQLite lokal (berdasar table + rowId outbox) lalu mendorongnya.
// Outbox tetap jadi antrean + penanda urutan; isinya bukan sumber data
// push. Bila baris lokal sudah tidak ada, entri outbox ditandai done
// (tidak ada yang bisa dikirim) supaya antrean tidak macet.
//
// Sync NONAKTIF bila tidak ada transport (config Supabase kosong):
// push/pull/syncNow mengembalikan SyncResult(0, 0, 0) tanpa mencoba
// koneksi apa pun. UI menampilkan "Sinkronisasi belum diaktifkan".
import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import 'db.dart';
import 'supabase_config.dart';
import 'sync.dart';

// ---------------------------------------------------------------------------
// Registri tabel yang ikut sync — urutan = urutan pull (induk dulu supaya
// foreign key terpenuhi: products sebelum sale_lines, journals sebelum
// journal_lines, dst.). `true` = kelas APPEND, `false` = kelas MASTER
// (BLUEPRINT §3.1). settings / sync_outbox / sync_state / sync_conflicts
// TIDAK ikut sync: settings lokal per device; tiga lainnya metadata sync.
// ---------------------------------------------------------------------------
const Map<String, bool> syncTableIsAppend = {
  'accounts': false,
  'employees': false,
  'customers': false,
  'products': false,
  'ingredients': false,
  'promos': false,
  'shop_tables': false,
  'shifts': false,
  'recipes': false,
  'recipe_lines': false,
  'orders': false,
  'order_lines': false,
  'sales': true,
  'sale_lines': true,
  'sale_payments': true,
  'stock_moves': true,
  'journals': true,
  'journal_lines': true,
  'assets': false,
  'expenses': true,
  'attendance': true,
  'payrolls': true,
  'stock_opnames': false,
  'stock_opname_lines': false,
  'petty_cash': false,
};

// ---------------------------------------------------------------------------
// Transport — abstraksi supaya engine bisa dites dengan fake.
// ---------------------------------------------------------------------------
abstract class SyncTransport {
  /// Dorong satu baris LENGKAP (map kolom SQLite -> nilai) ke server.
  /// Throw bila gagal (jaringan / server) — engine berhenti di situ.
  Future<void> pushRow(String table, Map<String, Object?> row);

  /// Tarik baris yang berubah sejak [sinceMs] (watermark updatedAt).
  /// Mengembalikan baris lengkap (map kolom SQLite -> nilai).
  Future<List<Map<String, Object?>>> pullDelta(String table, int sinceMs);
}

// ---------------------------------------------------------------------------
// Transport Supabase (PostgREST). Inisialisasi HANYA bila config ada;
// konstruktor throw StateError "Supabase belum dikonfigurasi" bila
// config kosong. Supabase.initialize() dipanggil malas (lazy) saat
// push/pull pertama — bukan saat konstruksi, bukan saat aplikasi dibuka.
// ---------------------------------------------------------------------------
class SupabaseTransport implements SyncTransport {
  SupabaseTransport(this.config) {
    config.requireConfigured();
  }

  final SupabaseConfig config;

  var _initialized = false;

  Future<sb.SupabaseClient> _client() async {
    if (!_initialized) {
      await sb.Supabase.initialize(
        url: config.url,
        // publishableKey = anon key (parameter `anonKey` sudah deprecated
        // di supabase_flutter 2.18 — JANGAN pakai service_role key).
        publishableKey: config.anonKey,
      );
      _initialized = true;
    }
    return sb.Supabase.instance.client;
  }

  @override
  Future<void> pushRow(String table, Map<String, Object?> row) async {
    final client = await _client();
    // Upsert berdasar primary key (id UUID v4) — push bisa diulang
    // dengan aman tanpa duplikat.
    await client.from(table).upsert(row);
  }

  @override
  Future<List<Map<String, Object?>>> pullDelta(
    String table,
    int sinceMs,
  ) async {
    final client = await _client();
    final data = await client
        .from(table)
        .select()
        .gt('updated_at', sinceMs)
        .order('updated_at', ascending: true);
    return (data as List)
        .map((e) => Map<String, Object?>.from(e as Map))
        .toList();
  }
}

// ---------------------------------------------------------------------------
// Satu konflik MASTER yang kalah last-write-wins (data lokal menang).
// Disimpan juga ke tabel syncConflicts (lihat [RealSyncEngine]).
// ---------------------------------------------------------------------------
class SyncConflict {
  const SyncConflict({
    required this.table,
    required this.rowId,
    required this.localUpdatedAt,
    required this.remoteUpdatedAt,
    required this.localDeviceId,
    required this.remoteDeviceId,
    required this.reason,
  });

  final String table;
  final String rowId;
  final int localUpdatedAt;
  final int remoteUpdatedAt;
  final String localDeviceId;
  final String remoteDeviceId;
  final String reason;
}

/// Engine sync aktif (menggantikan [StubSyncEngine]).
///
/// Tanpa transport ([RealSyncEngine(db)]) engine NONAKTIF: semua
/// operasi mengembalikan [SyncResult] nol tanpa koneksi apa pun.
class RealSyncEngine implements SyncEngine {
  RealSyncEngine(this.db, {SyncTransport? transport})
      : _transport = transport;

  final AppDatabase db;
  final SyncTransport? _transport;

  /// True bila ada transport (config Supabase terisi).
  bool get isEnabled => _transport != null;

  /// Konflik yang tercatat sejak engine ini dibuat (akumulasi antar
  /// pull). Riwayat lengkap yang persisten ada di tabel syncConflicts.
  List<SyncConflict> get conflicts => List.unmodifiable(_conflicts);
  final List<SyncConflict> _conflicts = [];

  final _statusController = StreamController<SyncStatus>.broadcast();

  // Cache daftar kolom per tabel (PRAGMA table_info) — supaya baris
  // remote yang membawa kolom tak dikenal tidak merusak SQL.
  final Map<String, Set<String>> _columnsCache = {};

  /// Konflik persisten terbaru (untuk layar Pengaturan).
  Future<List<SyncConflictRow>> recentConflicts({int limit = 50}) async {
    return (db.select(db.syncConflicts)
          ..orderBy([(c) => OrderingTerm.desc(c.createdAt)])
          ..limit(limit))
        .get();
  }

  /// Status saat ini (untuk badge + test, tanpa menunggu stream).
  Future<SyncStatus> currentStatus() async {
    return SyncStatus(
      pendingCount: await Outbox.pendingCount(db),
      lastSyncAt: await _readLastSyncAt(),
    );
  }

  /// Minta badge/UI membaca ulang status (dipanggil setelah sync).
  Future<void> refreshStatus() => _emitStatus();

  @override
  Stream<SyncStatus> get statusStream async* {
    yield await currentStatus();
    yield* _statusController.stream;
  }

  Future<void> _emitStatus() async {
    if (_statusController.isClosed) return;
    _statusController.add(await currentStatus());
  }

  // -- push ---------------------------------------------------------------

  @override
  Future<SyncResult> pushPending() async {
    if (!isEnabled) {
      return const SyncResult(pushed: 0, pulled: 0, failed: 0);
    }
    final pending = await (db.select(db.syncOutbox)
          ..where(
            (o) => o.status.equals('pending') | o.status.equals('failed'),
          )
          ..orderBy([(o) => OrderingTerm.asc(o.createdAt)]))
        .get();
    var pushed = 0;
    for (final entry in pending) {
      // Tabel tak dikenal (outbox rusak / tabel lama): tandai failed
      // lalu LANJUT — satu baris rusak tidak boleh memacetkan antrean
      // selamanya. (Beda dengan gagal jaringan di bawah: itu berhenti.)
      if (!syncTableIsAppend.containsKey(entry.table)) {
        await _markOutbox(entry.id, 'failed', entry.attempts + 1);
        continue;
      }
      // Baca baris LENGKAP dari SQLite (payload outbox hanya sebagian).
      final row = await _readLocalRow(entry.table, entry.rowId);
      if (row == null) {
        // Baris lokal sudah tidak ada — tidak ada yang bisa dikirim.
        await _markOutbox(entry.id, 'done', entry.attempts + 1);
        continue;
      }
      try {
        await _transport!.pushRow(entry.table, row);
      } catch (_) {
        // Gagal pertama (biasanya jaringan putus): tandai failed dan
        // BERHENTI — urutan FIFO harus dipertahankan.
        await _markOutbox(entry.id, 'failed', entry.attempts + 1);
        await _emitStatus();
        return SyncResult(pushed: pushed, pulled: 0, failed: 1);
      }
      await _markOutbox(entry.id, 'done', entry.attempts + 1);
      pushed++;
    }
    await _recordSuccessfulSync();
    await _emitStatus();
    return SyncResult(pushed: pushed, pulled: 0, failed: 0);
  }

  // -- pull ---------------------------------------------------------------

  @override
  Future<SyncResult> pullDelta() async {
    if (!isEnabled) {
      return const SyncResult(pushed: 0, pulled: 0, failed: 0);
    }
    var pulled = 0;
    var failed = 0;
    for (final table in syncTableIsAppend.keys) {
      final watermark = await _watermark(table);
      late final List<Map<String, Object?>> rows;
      try {
        rows = await _transport!.pullDelta(table, watermark);
      } catch (_) {
        // Satu tabel gagal ditarik bukan fatal global — tabel lain
        // tetap dicoba. Gagal total (jaringan mati) berarti semua
        // tabel gagal, failed = jumlah tabel.
        failed++;
        continue;
      }
      var maxSeen = watermark;
      await db.transaction(() async {
        for (final row in rows) {
          final updatedAt = _asInt(row['updated_at']);
          if (updatedAt != null && updatedAt > maxSeen) {
            maxSeen = updatedAt;
          }
          if (await _applyRow(table, row)) pulled++;
        }
        // Watermark maju ke updatedAt terbesar yang DITERIMA (bukan
        // hanya yang diterapkan) — duplikat/konflik tidak ditarik ulang.
        if (maxSeen > watermark) await _setWatermark(table, maxSeen);
      });
    }
    if (failed == 0) await _recordSuccessfulSync();
    await _emitStatus();
    return SyncResult(pushed: 0, pulled: pulled, failed: failed);
  }

  @override
  Future<SyncResult> syncNow() async {
    if (!isEnabled) {
      return const SyncResult(pushed: 0, pulled: 0, failed: 0);
    }
    final push = await pushPending();
    // Bila kirim gagal, JANGAN tarik — server belum punya data lokal
    // terbaru; menarik dulu bisa menimpa lewat LWW sebelum kirim.
    if (push.failed > 0) return push;
    final pull = await pullDelta();
    return SyncResult(
      pushed: push.pushed,
      pulled: pull.pulled,
      failed: pull.failed,
    );
  }

  /// Tutup stream status (dipanggil saat aplikasi dimatikan).
  void dispose() {
    _statusController.close();
  }

  // -- terapan baris remote (pull) ----------------------------------------

  /// Terapkan satu baris remote ke SQLite lokal. Mengembalikan true
  /// bila data lokal berubah (dihitung sebagai `pulled`).
  Future<bool> _applyRow(
    String table,
    Map<String, Object?> row,
  ) async {
    final id = row['id'];
    final updatedAt = _asInt(row['updated_at']);
    if (id is! String || id.isEmpty || updatedAt == null) return false;
    final columns = await _columns(table);
    final filtered = <String, Object?>{};
    for (final e in row.entries) {
      if (columns.contains(e.key)) filtered[e.key] = _normalize(e.value);
    }
    filtered['id'] = id;
    filtered['updated_at'] = updatedAt;
    if (filtered.length < 2) return false;

    final existing = await db
        .customSelect(
          'SELECT "updated_at", "device_id" FROM "$table" WHERE "id" = ?',
          variables: [Variable<String>(id)],
        )
        .getSingleOrNull();
    if (existing == null) {
      await _insertRow(table, filtered, orIgnore: true);
      return true;
    }
    final localUpdatedAt = _asInt(existing.data['updated_at']) ?? 0;
    final localDeviceId = existing.data['device_id'] as String? ?? '';

    if (syncTableIsAppend[table]!) {
      return _applyAppendFlags(table, filtered, localUpdatedAt);
    }

    // MASTER: last-write-wins. Seri -> deviceId (string lebih besar menang).
    final remoteDeviceId = row['device_id'] as String? ?? '';
    final remoteWins = updatedAt > localUpdatedAt ||
        (updatedAt == localUpdatedAt &&
            remoteDeviceId.compareTo(localDeviceId) > 0);
    if (remoteWins) {
      await _updateRow(table, filtered);
      return true;
    }
    // Kalah — catat konflik, data lokal dipertahankan apa adanya.
    final conflict = SyncConflict(
      table: table,
      rowId: id,
      localUpdatedAt: localUpdatedAt,
      remoteUpdatedAt: updatedAt,
      localDeviceId: localDeviceId,
      remoteDeviceId: remoteDeviceId,
      reason: updatedAt == localUpdatedAt
          ? 'Seri updatedAt — deviceId lokal lebih besar, baris remote ditolak.'
          : 'Baris remote lebih lama (updatedAt $updatedAt < $localUpdatedAt), baris remote ditolak.',
    );
    _conflicts.add(conflict);
    await db.into(db.syncConflicts).insert(
          SyncConflictsCompanion.insert(
            id: newId(),
            table: table,
            rowId: id,
            localUpdatedAt: localUpdatedAt,
            remoteUpdatedAt: updatedAt,
            localDeviceId: localDeviceId,
            remoteDeviceId: remoteDeviceId,
            reason: conflict.reason,
            createdAt: nowMs(),
          ),
        );
    return false;
  }

  /// APPEND yang sudah ada: hanya flag yang memang bisa berubah yang
  /// diperbarui (void penjualan, clock-in/out absensi) — dan hanya bila
  /// baris remote lebih baru. Event lain tidak pernah di-UPDATE.
  Future<bool> _applyAppendFlags(
    String table,
    Map<String, Object?> row,
    int localUpdatedAt,
  ) async {
    final incomingUpdatedAt = row['updated_at'] as int;
    if (table == 'sales') {
      if (incomingUpdatedAt <= localUpdatedAt) return false;
      await _updateColumns(
        table,
        row,
        const ['voided', 'voided_at', 'updated_at', 'device_id'],
      );
      return true;
    }
    if (table == 'attendance') {
      if (incomingUpdatedAt < localUpdatedAt) return false;
      await _updateColumns(
        table,
        row,
        const [
          'clock_in',
          'clock_out',
          'pin_verified',
          'updated_at',
          'device_id',
        ],
      );
      return true;
    }
    return false;
  }

  // -- SQL generik ----------------------------------------------------------

  Future<Map<String, Object?>?> _readLocalRow(
    String table,
    String rowId,
  ) async {
    final found = await db
        .customSelect(
          'SELECT * FROM "$table" WHERE "id" = ?',
          variables: [Variable<String>(rowId)],
        )
        .getSingleOrNull();
    if (found == null) return null;
    return Map<String, Object?>.from(found.data);
  }

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

  Future<void> _insertRow(
    String table,
    Map<String, Object?> row, {
    bool orIgnore = false,
  }) async {
    final cols = row.keys.toList();
    final names = cols.map((c) => '"$c"').join(', ');
    final placeholders = List.filled(cols.length, '?').join(', ');
    await db.customStatement(
      'INSERT ${orIgnore ? 'OR IGNORE ' : ''}INTO "$table" '
      '($names) VALUES ($placeholders)',
      [for (final c in cols) row[c]],
    );
  }

  Future<void> _updateRow(String table, Map<String, Object?> row) async {
    final setCols = row.keys.where((c) => c != 'id').toList();
    if (setCols.isEmpty) return;
    final setClause = setCols.map((c) => '"$c" = ?').join(', ');
    await db.customStatement(
      'UPDATE "$table" SET $setClause WHERE "id" = ?',
      [for (final c in setCols) row[c], row['id']],
    );
  }

  /// UPDATE hanya kolom [wanted] yang ada di [row].
  Future<void> _updateColumns(
    String table,
    Map<String, Object?> row,
    List<String> wanted,
  ) async {
    final cols = wanted.where((c) => row.containsKey(c)).toList();
    if (cols.isEmpty) return;
    final setClause = cols.map((c) => '"$c" = ?').join(', ');
    await db.customStatement(
      'UPDATE "$table" SET $setClause WHERE "id" = ?',
      [for (final c in cols) row[c], row['id']],
    );
  }

  // -- outbox / watermark / jam sync ---------------------------------------

  Future<void> _markOutbox(String id, String status, int attempts) async {
    await (db.update(db.syncOutbox)..where((o) => o.id.equals(id))).write(
      SyncOutboxCompanion(
        status: Value(status),
        attempts: Value(attempts),
      ),
    );
  }

  Future<int> _watermark(String table) async {
    final row = await (db.select(db.syncState)
          ..where((s) => s.id.equals(table)))
        .getSingleOrNull();
    return row?.lastPulledAt ?? 0;
  }

  Future<void> _setWatermark(String table, int value) async {
    await db.into(db.syncState).insertOnConflictUpdate(
          SyncStateCompanion.insert(id: table, lastPulledAt: value),
        );
  }

  Future<DateTime?> _readLastSyncAt() async {
    final raw = await db.getSetting('lastSyncAt');
    final ms = raw == null ? null : int.tryParse(raw);
    return ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
  }

  Future<void> _recordSuccessfulSync() async {
    await db.setSetting('lastSyncAt', nowMs().toString());
  }

  // -- normalisasi nilai ----------------------------------------------------

  /// JSON Supabase -> nilai yang bisa diikat ke SQLite. bool jadi 0/1;
  /// tipe lain yang tak dikenal dijadikan string (jangan crash pull).
  static Object? _normalize(Object? value) {
    if (value is bool) return value ? 1 : 0;
    if (value is num || value is String || value == null) return value;
    return value.toString();
  }

  static int? _asInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}

/// Bantuan debug: payload outbox (JSON string) -> map. Dipakai test dan
/// bila suatu saat push perlu isi payload (saat ini push memakai baris
/// lengkap dari SQLite — lihat catatan di atas file ini).
Map<String, Object?> decodeOutboxPayload(String jsonStr) {
  final decoded = jsonDecode(jsonStr);
  if (decoded is! Map<String, dynamic>) return {};
  return Map<String, Object?>.from(decoded);
}
