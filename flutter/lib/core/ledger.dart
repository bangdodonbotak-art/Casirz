// Casirz ERP — Fase 1 Core Engine.
// REA ledger: satu-satunya jalan ke laporan (BLUEPRINT-FLUTTER.md §5.1, §7).
//
// CATATAN ADAPTASI DRIFT (dilaporkan ke koordinator, bukan perubahan diam-diam):
// Blueprint §5.1 menulis signature `postJournal(Transaction tx, ...)`.
// Di Drift 2.31 kelas `Transaction` adalah `@internal` (tidak diekspor
// publik) dan `db.transaction()` callback-nya TIDAK menerima handle
// transaksi — `Future<T> transaction<T>(Future<T> Function() action)`.
// Yang terjadi di dalam closure otomatis dirutekan Drift ke transaksi
// yang sedang dibuka (mekanisme Zone). Karena itu parameter di sini
// bertipe `AppDatabase db`: bila dipanggil di dalam
// `db.transaction(() async { ... })`, semua tulis ikut transaksi
// pemanggil dan gagal di satu titik = rollback semua; bila dipanggil di
// luar transaksi, tulis berjalan standalone (tanggung jawab pemanggil).
// Aturan beku tetap dipegang: Ledger TIDAK PERNAH memanggil
// `db.transaction()` sendiri — kecuali varian `postJournalStandalone`
// yang memang untuk event yang HANYA jurnal.
//
// Aturan posting:
// - Jurnal seimbang (total debit == total kredit), kalau tidak -> throw
//   [JurnalTidakSeimbang]; tidak ada baris yang tersisa (rollback oleh
//   transaksi pemanggil / standalone).
// - Satu baris tidak boleh debit > 0 DAN kredit > 0 sekaligus.
// - UNIQUE(refType, refId): satu event = satu jurnal (idempotensi).
// - Jurnal TIDAK PERNAH diedit/dihapus. Salah catat -> jurnal pembalik.
import 'package:drift/drift.dart';

import 'accounts.dart';
import 'db.dart';
import 'errors.dart';
import 'sync.dart';

/// Satu baris jurnal.
class JournalLineInput {
  const JournalLineInput({
    required this.accountCode,
    required this.debit, // int Rp, >= 0
    required this.credit, // int Rp, >= 0
  });
  final String accountCode;
  final int debit;
  final int credit;
}

class Ledger {
  /// Menulis jurnal ke dalam transaksi yang SUDAH DIBUKA pemanggil.
  /// Panggil HANYA di dalam `db.transaction(() async { ... })`.
  /// Throw [JurnalTidakSeimbang] jika total debit != total kredit,
  /// [StateError] jika refType+refId sudah punya jurnal (idempotensi).
  /// Mengembalikan id jurnal (UUID).
  static Future<String> postJournal(
    AppDatabase db, {
    required DateTime date,
    required String memo,
    required String refType,
    required String refId,
    required List<JournalLineInput> lines,
    String? reversesJournalId,
    bool isReversal = false,
  }) async {
    _validateLines(lines);
    final totalDebit = lines.fold<int>(0, (s, l) => s + l.debit);
    final totalCredit = lines.fold<int>(0, (s, l) => s + l.credit);
    if (totalDebit != totalCredit) {
      throw JurnalTidakSeimbang(
        'Jurnal $refType:$refId tidak seimbang: '
        'debit Rp$totalDebit != kredit Rp$totalCredit.',
      );
    }
    if (totalDebit <= 0) {
      throw JurnalTidakSeimbang(
        'Jurnal $refType:$refId bernilai nol — tidak ada yang dijurnal.',
      );
    }

    final deviceId = await _deviceIdInTx(db);
    final now = nowMs();

    // Idempotensi: satu event = satu jurnal.
    final existing = await (db.select(db.journals)
          ..where(
            (j) => j.refType.equals(refType) & j.refId.equals(refId),
          ))
        .getSingleOrNull();
    if (existing != null) {
      throw StateError(
        'Jurnal sudah ada untuk $refType:$refId '
        '(jurnal ${existing.id}). Satu event = satu jurnal.',
      );
    }

    final journalId = newId();
    await db.into(db.journals).insert(
          JournalsCompanion.insert(
            id: journalId,
            date: date.millisecondsSinceEpoch,
            memo: memo,
            refType: refType,
            refId: refId,
            reversesJournalId: Value(reversesJournalId),
            isReversal: Value(isReversal ? 1 : 0),
            updatedAt: now,
            deviceId: deviceId,
          ),
        );
    for (final line in lines) {
      await db.into(db.journalLines).insert(
            JournalLinesCompanion.insert(
              id: newId(),
              journalId: journalId,
              accountCode: line.accountCode,
              debit: Value(line.debit),
              credit: Value(line.credit),
              updatedAt: now,
              deviceId: deviceId,
            ),
          );
    }
    return journalId;
  }

  /// Varian untuk event yang HANYA jurnal (OPEX, penyusutan, amortisasi):
  /// membuka transaksi sendiri. DILARANG dipakai dari dalam transaksi lain.
  /// Juga menulis outbox (journals + journalLines) dalam transaksi yang sama.
  static Future<String> postJournalStandalone(
    AppDatabase db, {
    required DateTime date,
    required String memo,
    required String refType,
    required String refId,
    required List<JournalLineInput> lines,
    String? reversesJournalId,
    bool isReversal = false,
  }) {
    return db.transaction(() async {
      final journalId = await postJournal(
        db,
        date: date,
        memo: memo,
        refType: refType,
        refId: refId,
        lines: lines,
        reversesJournalId: reversesJournalId,
        isReversal: isReversal,
      );
      await Outbox.write(
        db,
        table: 'journals',
        rowId: journalId,
        operation: 'insert',
        payload: {
          'id': journalId,
          'date': date.millisecondsSinceEpoch,
          'memo': memo,
          'refType': refType,
          'refId': refId,
        },
      );
      return journalId;
    });
  }

  /// Saldo satu akun s.d. tanggal [upTo] (null = semua).
  /// Signed int: positif = saldo sesuai posisi normal akun
  /// (aset/beban positif = debit; kewajiban/ekuitas/pendapatan positif
  /// = kredit). Akun 4100 Diskon (normal debit) positif = total diskon.
  static Future<int> getAccountBalance(
    AppDatabase db,
    String accountCode, {
    DateTime? upTo,
  }) async {
    final balances = await getBalances(db, upTo: upTo);
    return balances[accountCode] ?? 0;
  }

  /// Saldo SEMUA akun (29 akun, default 0) s.d. tanggal [upTo].
  static Future<Map<String, int>> getBalances(
    AppDatabase db, {
    DateTime? upTo,
  }) async {
    final upToMs = upTo?.millisecondsSinceEpoch;
    final rows = await db
        .select(db.journalLines)
        .join([
          innerJoin(
            db.journals,
            db.journals.id.equalsExp(db.journalLines.journalId),
          ),
        ])
        .get();
    final result = <String, int>{
      for (final a in ChartOfAccounts.all) a.code: 0,
    };
    for (final row in rows) {
      final line = row.readTable(db.journalLines);
      final journal = row.readTable(db.journals);
      if (upToMs != null && journal.date > upToMs) continue;
      final def = ChartOfAccounts.byCode(line.accountCode);
      final signed = def.normal == Normal.debit
          ? line.debit - line.credit
          : line.credit - line.debit;
      result[line.accountCode] = (result[line.accountCode] ?? 0) + signed;
    }
    return result;
  }

  /// True bila sudah ada jurnal untuk refType+refId (cek idempotensi).
  static Future<bool> journalExists(
    AppDatabase db, {
    required String refType,
    required String refId,
  }) async {
    final row = await (db.select(db.journals)
          ..where((j) => j.refType.equals(refType) & j.refId.equals(refId)))
        .getSingleOrNull();
    return row != null;
  }

  static void _validateLines(List<JournalLineInput> lines) {
    if (lines.isEmpty) {
      throw JurnalTidakSeimbang('Jurnal tanpa baris.');
    }
    for (final line in lines) {
      if (!ChartOfAccounts.exists(line.accountCode)) {
        throw ArgumentError(
          'Kode akun tidak dikenal: ${line.accountCode}',
        );
      }
      if (line.debit < 0 || line.credit < 0) {
        throw JurnalTidakSeimbang(
          'Baris ${line.accountCode}: debit/kredit tidak boleh negatif.',
        );
      }
      if (line.debit > 0 && line.credit > 0) {
        throw JurnalTidakSeimbang(
          'Baris ${line.accountCode}: satu baris tidak boleh debit > 0 '
          'DAN kredit > 0 sekaligus.',
        );
      }
      if (line.debit == 0 && line.credit == 0) {
        throw JurnalTidakSeimbang(
          'Baris ${line.accountCode}: debit dan kredit keduanya nol.',
        );
      }
    }
  }

  /// Device id di dalam transaksi: baca settings, buat bila belum ada.
  static Future<String> _deviceIdInTx(AppDatabase db) async {
    final row = await (db.select(db.settings)
          ..where((s) => s.id.equals('deviceId')))
        .getSingleOrNull();
    if (row != null && row.value.isNotEmpty) return row.value;
    final id = newId();
    await db.into(db.settings).insertOnConflictUpdate(
          SettingsCompanion.insert(id: 'deviceId', value: id),
        );
    return id;
  }
}
