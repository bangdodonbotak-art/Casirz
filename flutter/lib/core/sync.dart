// Casirz ERP — Fase 1 Core Engine.
// Sync outbox + kontrak sync engine (BLUEPRINT-FLUTTER.md §5.3, §11).
//
// FASE 1: penulis outbox JALAN — setiap tulis bisnis lokal menulis baris
// outbox dalam transaksi Drift yang SAMA (jadi outbox tidak pernah
// ketinggalan dari data). Engine kirim/tarik AKTIF di Fase 7; di sini
// hanya kontrak + stub yang throw jujur bila dipanggil.
// Supabase TIDAK diinisialisasi sebelum Fase 7 (§5.4).
import 'dart:convert';

import 'package:drift/drift.dart';

import 'db.dart';

/// Nama tabel SQLite kelas APPEND (event — tidak bisa diubah).
/// Outbox MELARANG operasi 'delete' untuk tabel-tabel ini.
const Set<String> appendTables = {
  'sales',
  'sale_lines',
  'sale_payments',
  'stock_moves',
  'journals',
  'journal_lines',
  'expenses',
  'attendance',
  'payrolls',
};

/// Penulis antrean sync. Dipanggil di dalam transaksi bisnis yang sama.
class Outbox {
  /// Tulis satu baris outbox (status 'pending').
  /// Throw [ArgumentError] bila operasi 'delete' diminta untuk tabel APPEND.
  static Future<void> write(
    AppDatabase db, {
    required String table,
    required String rowId,
    required String operation,
    required Map<String, Object?> payload,
  }) async {
    if (operation == 'delete' && appendTables.contains(table)) {
      throw ArgumentError(
        'Operasi delete dilarang untuk tabel APPEND: $table. '
        'Event salah catat dikoreksi dengan entri baru, bukan dihapus.',
      );
    }
    final now = nowMs();
    await db.into(db.syncOutbox).insert(
          SyncOutboxCompanion.insert(
            id: newId(),
            table: table,
            rowId: rowId,
            operation: operation,
            payload: jsonEncode(payload),
            status: 'pending',
            createdAt: now,
          ),
        );
  }

  /// Jumlah baris outbox yang masih pending/failed (belum tersinkron).
  static Future<int> pendingCount(AppDatabase db) async {
    final rows = await (db.select(db.syncOutbox)
          ..where(
            (o) => o.status.equals('pending') | o.status.equals('failed'),
          ))
        .get();
    return rows.length;
  }

  /// Tulis outbox untuk satu jurnal + semua barisnya.
  /// Dipanggil service pemilik transaksi SETELAH jurnal diposting.
  static Future<void> writeJournal(AppDatabase db, String journalId) async {
    final journal = await (db.select(db.journals)
          ..where((j) => j.id.equals(journalId)))
        .getSingle();
    await write(
      db,
      table: 'journals',
      rowId: journal.id,
      operation: 'insert',
      payload: {
        'id': journal.id,
        'date': journal.date,
        'memo': journal.memo,
        'refType': journal.refType,
        'refId': journal.refId,
        'reversesJournalId': journal.reversesJournalId,
        'isReversal': journal.isReversal,
      },
    );
    final lines = await (db.select(db.journalLines)
          ..where((l) => l.journalId.equals(journalId)))
        .get();
    for (final line in lines) {
      await write(
        db,
        table: 'journal_lines',
        rowId: line.id,
        operation: 'insert',
        payload: {
          'id': line.id,
          'journalId': line.journalId,
          'accountCode': line.accountCode,
          'debit': line.debit,
          'credit': line.credit,
        },
      );
    }
  }
}

/// Status sync untuk badge UI ("N perubahan belum tersinkron").
class SyncStatus {
  const SyncStatus({required this.pendingCount, required this.lastSyncAt});
  final int pendingCount;
  final DateTime? lastSyncAt; // null = belum pernah sync sukses
}

/// Hasil satu putaran sync.
class SyncResult {
  const SyncResult({
    required this.pushed,
    required this.pulled,
    required this.failed,
  });
  final int pushed;
  final int pulled;
  final int failed;
}

/// Kontrak sync engine — BEKU (BLUEPRINT §5.3). Implementasi aktif Fase 7.
abstract class SyncEngine {
  /// Kuras outbox FIFO (paling lama dulu). BERHENTI di gagal pertama.
  Future<SyncResult> pushPending();

  /// Tarik delta per tabel memakai watermark syncState.lastPulledAt.
  Future<SyncResult> pullDelta();

  /// pushPending() lalu pullDelta().
  Future<SyncResult> syncNow();

  /// Untuk badge "N perubahan belum tersinkron" + jam sync terakhir.
  Stream<SyncStatus> get statusStream;
}

/// Stub Fase 1: status (hitung pending) jalan; kirim/tarik throw jujur.
///
/// JANGAN dipakai untuk sync sungguhan sebelum Fase 7.
class StubSyncEngine implements SyncEngine {
  StubSyncEngine(this.db);
  final AppDatabase db;

  @override
  Stream<SyncStatus> get statusStream async* {
    yield SyncStatus(
      pendingCount: await Outbox.pendingCount(db),
      // Belum pernah tersinkron — sync aktif Fase 7.
      lastSyncAt: null,
    );
  }

  @override
  Future<SyncResult> pushPending() => Future.error(
        StateError(
          'Sync belum aktif. Kuras outbox diaktifkan Fase 7 setelah versi '
          'lokal stabil (lihat BLUEPRINT-FLUTTER.md §5.3).',
        ),
      );

  @override
  Future<SyncResult> pullDelta() => Future.error(
        StateError(
          'Sync belum aktif. Tarik delta diaktifkan Fase 7 setelah versi '
          'lokal stabil (lihat BLUEPRINT-FLUTTER.md §5.3).',
        ),
      );

  @override
  Future<SyncResult> syncNow() => Future.error(
        StateError(
          'Sync belum aktif. Sync diaktifkan Fase 7 setelah versi lokal '
          'stabil (lihat BLUEPRINT-FLUTTER.md §5.3).',
        ),
      );
}

/// Penanda Supabase — BEKU (BLUEPRINT §5.4).
///
/// Supabase dirancang dari awal (skema + outbox), tetapi TIDAK diaktifkan
/// sebelum versi lokal stabil (Fase 7). File/kelas ini HANYA penanda —
/// jangan panggil dari mana pun sebelum Fase 7. Tidak ada
/// `Supabase.initialize()` di mana pun di Fase 1.
class SupabaseClient {
  static Never notYetEnabled() {
    throw StateError(
      'Supabase belum diaktifkan. Aktifasi direncanakan Fase 7 setelah '
      'versi lokal stabil (lihat BLUEPRINT-FLUTTER.md §5.4).',
    );
  }
}
