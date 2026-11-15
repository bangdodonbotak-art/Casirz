// Casirz ERP — Fase 4 (Modul C Akuntansi).
// Riverpod providers akuntansi: aset, beban, jurnal, saldo akun.
// UI hanya baca lewat provider ini; tulis lewat AccountingService.
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/accounting_service.dart';
import '../../core/db.dart';
import '../../core/ledger.dart';
import '../pos/pos_providers.dart';

/// Versi lokal untuk refresh manual setelah tulis (stream aset/beban/
// jurnal sudah live, tapi FutureProvider saldo perlu di-refresh).
final accountingVersionProvider = StateProvider<int>((ref) => 0);

/// Daftar aset tetap (tidak terhapus), urut nama.
final assetsProvider = StreamProvider<List<Asset>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.assets)
        ..where((a) => a.isDeleted.equals(0))
        ..orderBy([(a) => OrderingTerm.asc(a.name)]))
      .watch();
});

/// Daftar beban OPEX, terbaru dulu.
final expensesProvider = StreamProvider<List<Expense>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.expenses)
        ..orderBy([(e) => OrderingTerm.desc(e.date)]))
      .watch();
});

/// Daftar jurnal, terbaru dulu.
final journalsProvider = StreamProvider<List<Journal>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.journals)
        ..orderBy([(j) => OrderingTerm.desc(j.date)]))
      .watch();
});

/// Baris satu jurnal.
final journalLinesProvider =
    FutureProvider.family<List<JournalLine>, String>(
  (ref, journalId) async {
    final db = ref.watch(databaseProvider);
    return (db.select(db.journalLines)
          ..where((l) => l.journalId.equals(journalId)))
        .get();
  },
);

/// Saldo semua akun (signed, sesuai posisi normal).
final balancesProvider = FutureProvider<Map<String, int>>((ref) async {
  ref.watch(accountingVersionProvider);
  final db = ref.watch(databaseProvider);
  return Ledger.getBalances(db);
});

/// Jurnal modal awal pertama (null bila belum dicatat).
final capitalJournalProvider = FutureProvider<Journal?>((ref) async {
  ref.watch(accountingVersionProvider);
  final db = ref.watch(databaseProvider);
  return AccountingService.firstCapitalJournal(db);
});

/// Settings sewa (rentTotal / rentMonths / rentStartMonth).
final rentSettingsProvider =
    FutureProvider<Map<String, String?>>((ref) async {
  ref.watch(accountingVersionProvider);
  final db = ref.watch(databaseProvider);
  return {
    'rentTotal': await db.getSetting('rentTotal'),
    'rentMonths': await db.getSetting('rentMonths'),
    'rentStartMonth': await db.getSetting('rentStartMonth'),
  };
});

/// Satu jurnal + baris-barisnya (untuk daftar jurnal terfilter).
class JournalWithLines {
  const JournalWithLines(this.journal, this.lines);
  final Journal journal;
  final List<JournalLine> lines;
}

/// Query jurnal dalam rentang tanggal, opsional hanya yang menyentuh
/// satu akun. Dipakai JurnalPage (FutureBuilder, bukan StreamProvider —
/// filter berubah-ubah dari UI).
class AccountingQueries {
  static Future<List<JournalWithLines>> journalsWithLines(
    AppDatabase db, {
    String? accountCode,
    required DateTime from,
    required DateTime to,
  }) async {
    final fromMs = DateTime(from.year, from.month, from.day)
        .millisecondsSinceEpoch;
    final toMs = DateTime(to.year, to.month, to.day, 23, 59, 59, 999)
        .millisecondsSinceEpoch;
    final journals = await (db.select(db.journals)
          ..where(
            (j) =>
                j.date.isBiggerOrEqualValue(fromMs) &
                j.date.isSmallerOrEqualValue(toMs),
          )
          ..orderBy([(j) => OrderingTerm.desc(j.date)]))
        .get();
    final result = <JournalWithLines>[];
    for (final journal in journals) {
      final lines = await (db.select(db.journalLines)
            ..where((l) => l.journalId.equals(journal.id)))
          .get();
      if (accountCode != null &&
          !lines.any((l) => l.accountCode == accountCode)) {
        continue;
      }
      result.add(JournalWithLines(journal, lines));
    }
    return result;
  }
}
