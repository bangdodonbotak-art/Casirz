// Casirz ERP — Fase 2 (Modul A Kasir+).
// Service shift & laci kas. Engine Fase 1 TIDAK punya service shift —
// service ini DIBUAT di fitur (bukan mengubah lib/core): memakai API
// engine yang sudah ada (Ledger.postJournal,
// AccountingService.fillPettyCash / recordCashDifference tidak dipakai
// di sini supaya jurnal selisih + update shift atomik dalam SATU
// transaksi — recordCashDifference membuka transaksi sendiri).
//
// Aturan (BLUEPRINT §7.2):
// - Buka shift WAJIB Opening Float (modal kasir harian). Satu shift
//   open dalam satu waktu.
// - Kas harapan = openingFloat + penjualan tunai netto shift ini
//   (tunai diterima − kembalian) − isi petty dari laci.
//   Belanja DARI petty tidak mengurangi laci (uang sudah keluar saat
//   isi petty), jadi tidak masuk rumus.
// - Tutup shift: selisih = kas fisik − kas harapan. Kurang:
//   D 5220 / K 1000; lebih: D 1000 / K 5220. Selisih 0 = tanpa jurnal.
// - Isi petty: D 1030 / K 1000 (pakai engine fillPettyCash).
// - Belanja dari petty: D 51xx / K 1030 + baris expenses. Akun beban
//   dipilih dari 51xx (Listrik 5100, Air 5110, Internet 5120,
//   Kebersihan 5150, Marketing 5160, Lain-lain 5170).
// - Baris pettyCash: amount POSITIF = isi petty (uang masuk ke petty),
//   NEGATIF = belanja dari petty. Konvensi ini ditulis di sini dan di
//   laporan Fase 2.
import 'package:drift/drift.dart';

import '../../core/accounts.dart';
import '../../core/db.dart';
import '../../core/ledger.dart';
import '../../core/sync.dart';
import '../../core/accounting_service.dart';

/// Akun beban yang boleh dipakai untuk belanja petty (51xx).
const Map<String, String> pettyExpenseAccounts = {
  '5100': 'Beban Listrik',
  '5110': 'Beban Air',
  '5120': 'Beban Internet',
  '5150': 'Beban Kebersihan',
  '5160': 'Beban Marketing',
  '5170': 'Beban Lain-lain',
};

class ShiftCloseResult {
  const ShiftCloseResult({
    required this.expectedCash,
    required this.actualCash,
    required this.cashDiff,
  });
  final int expectedCash;
  final int actualCash;
  final int cashDiff; // actual - expected (negatif = kurang)
}

class ShiftService {
  /// Shift yang sedang open (null bila tidak ada).
  static Future<Shift?> activeShift(AppDatabase db) async {
    final rows = await (db.select(db.shifts)
          ..where((s) => s.status.equals('open'))
          ..orderBy([(s) => OrderingTerm.desc(s.openedAt)]))
        .get();
    return rows.isEmpty ? null : rows.first;
  }

  /// Buka shift baru. Throw bila sudah ada shift open.
  /// [employeeId] = karyawan yang login (dari sesi login, Fase 6).
  /// null = tanpa sesi login (DB kosong, gate terkecuali).
  static Future<String> openShift(
    AppDatabase db, {
    required int openingFloat,
    String? employeeId,
  }) async {
    if (openingFloat < 0) {
      throw ArgumentError('Opening float tidak boleh negatif.');
    }
    final deviceId = await db.deviceId();
    final id = newId();
    await db.transaction(() async {
      final existing = await activeShift(db);
      if (existing != null) {
        throw StateError(
          'Masih ada shift yang terbuka (dibuka '
          '${DateTime.fromMillisecondsSinceEpoch(existing.openedAt)}). '
          'Tutup dulu sebelum buka shift baru.',
        );
      }
      if (employeeId != null) {
        final employee = await (db.select(db.employees)
              ..where((e) => e.id.equals(employeeId)))
            .getSingleOrNull();
        if (employee == null) {
          throw ArgumentError('Karyawan tidak ditemukan: $employeeId');
        }
      }
      final now = nowMs();
      await db.into(db.shifts).insert(
            ShiftsCompanion.insert(
              id: id,
              openedAt: now,
              status: 'open',
              openingFloat: openingFloat,
              employeeId: Value(employeeId),
              updatedAt: now,
              deviceId: deviceId,
            ),
          );
      await Outbox.write(
        db,
        table: 'shifts',
        rowId: id,
        operation: 'insert',
        payload: {'id': id, 'status': 'open', 'openingFloat': openingFloat},
      );
    });
    return id;
  }

  /// Kas harapan di laci untuk shift ini.
  static Future<int> expectedCash(AppDatabase db, String shiftId) async {
    final shift = await (db.select(db.shifts)
          ..where((s) => s.id.equals(shiftId)))
        .getSingleOrNull();
    if (shift == null) throw ArgumentError('Shift tidak ditemukan.');
    // Penjualan tunai netto shift ini (voided tidak dihitung).
    final sales = await (db.select(db.sales)
          ..where(
            (s) => s.shiftId.equals(shiftId) & s.voided.equals(0),
          ))
        .get();
    var tunaiNet = 0;
    for (final sale in sales) {
      final payments = await (db.select(db.salePayments)
            ..where((p) => p.saleId.equals(sale.id)))
          .get();
      final tunai = payments
          .where((p) => p.method == 'tunai')
          .fold<int>(0, (sum, p) => sum + p.amount);
      tunaiNet += tunai - sale.change;
    }
    // Isi petty dari laci (amount positif) mengurangi kas laci.
    final pettyRows = await (db.select(db.pettyCash)
          ..where((p) => p.shiftId.equals(shiftId)))
        .get();
    final pettyOut = pettyRows
        .where((p) => p.amount > 0)
        .fold<int>(0, (sum, p) => sum + p.amount);
    return shift.openingFloat + tunaiNet - pettyOut;
  }

  /// Tutup shift: hitung selisih, update baris shift, jurnal selisih
  /// (bila != 0) — SEMUA dalam satu transaksi. Mengembalikan hasil
  /// rekonsiliasi.
  static Future<ShiftCloseResult> closeShift(
    AppDatabase db, {
    required String shiftId,
    required int actualCash,
  }) async {
    if (actualCash < 0) {
      throw ArgumentError('Kas fisik tidak boleh negatif.');
    }
    return db.transaction(() async {
      final now = nowMs();
      final shift = await (db.select(db.shifts)
            ..where((s) => s.id.equals(shiftId)))
          .getSingleOrNull();
      if (shift == null) throw ArgumentError('Shift tidak ditemukan.');
      if (shift.status != 'open') {
        throw StateError('Shift ini sudah ditutup.');
      }
      final expected = await expectedCash(db, shiftId);
      final diff = actualCash - expected;
      await (db.update(db.shifts)
            ..where((s) => s.id.equals(shiftId)))
        .write(
          ShiftsCompanion(
            closedAt: Value(now),
            status: const Value('closed'),
            expectedCash: Value(expected),
            actualCash: Value(actualCash),
            cashDiff: Value(diff),
            updatedAt: Value(now),
          ),
        );
      await Outbox.write(
        db,
        table: 'shifts',
        rowId: shiftId,
        operation: 'update',
        payload: {
          'id': shiftId,
          'status': 'closed',
          'expectedCash': expected,
          'actualCash': actualCash,
          'cashDiff': diff,
        },
      );
      if (diff != 0) {
        final amount = diff.abs();
        final kurang = diff < 0;
        final journalId = await Ledger.postJournal(
          db,
          date: DateTime.now(),
          memo: 'Selisih kas tutup shift ${kurang ? 'kurang' : 'lebih'}',
          refType: 'selisih-kas',
          refId: shiftId,
          lines: kurang
              ? [
                  JournalLineInput(
                    accountCode: '5220',
                    debit: amount,
                    credit: 0,
                  ),
                  JournalLineInput(
                    accountCode: '1000',
                    debit: 0,
                    credit: amount,
                  ),
                ]
              : [
                  JournalLineInput(
                    accountCode: '1000',
                    debit: amount,
                    credit: 0,
                  ),
                  JournalLineInput(
                    accountCode: '5220',
                    debit: 0,
                    credit: amount,
                  ),
                ],
        );
        await Outbox.writeJournal(db, journalId);
      }
      return ShiftCloseResult(
        expectedCash: expected,
        actualCash: actualCash,
        cashDiff: diff,
      );
    });
  }

  /// Isi petty cash dari laci (D 1030 / K 1000) — pakai engine.
  static Future<String> fillPetty(
    AppDatabase db, {
    required int amount,
    required String employeeId,
    String? shiftId,
    String note = 'Isi petty cash',
  }) {
    return AccountingService.fillPettyCash(
      db,
      date: DateTime.now(),
      amount: amount,
      employeeId: employeeId,
      shiftId: shiftId,
      note: note,
    );
  }

  /// Belanja dari petty cash (D 51xx / K 1030). [accountCode] harus
  /// akun Beban. Mencatat baris expenses + baris pettyCash negatif
  /// (konvensi: negatif = uang keluar dari petty) + jurnal + outbox,
  /// semua dalam satu transaksi.
  static Future<String> spendPetty(
    AppDatabase db, {
    required int amount,
    required String note,
    required String accountCode,
    required String employeeId,
    String? shiftId,
  }) async {
    if (amount <= 0) {
      throw ArgumentError('Jumlah belanja petty harus > 0.');
    }
    if (note.trim().isEmpty) {
      throw ArgumentError('Alasan belanja petty wajib diisi.');
    }
    final def = ChartOfAccounts.byCode(accountCode);
    if (def.type != AccountType.beban) {
      throw ArgumentError('Akun $accountCode bukan akun Beban.');
    }
    final deviceId = await db.deviceId();
    return db.transaction(() async {
      final now = nowMs();
      final expenseId = newId();
      await db.into(db.expenses).insert(
            ExpensesCompanion.insert(
              id: expenseId,
              date: now,
              category: 'Petty: ${def.name}',
              amount: amount,
              accountCode: accountCode,
              note: note.trim(),
              employeeId: Value(employeeId),
              updatedAt: now,
              deviceId: deviceId,
            ),
          );
      final pettyId = newId();
      await db.into(db.pettyCash).insert(
            PettyCashCompanion.insert(
              id: pettyId,
              shiftId: Value(shiftId),
              date: now,
              amount: -amount, // negatif = keluar dari petty
              note: note.trim(),
              employeeId: employeeId,
              updatedAt: now,
              deviceId: deviceId,
            ),
          );
      final journalId = await Ledger.postJournal(
        db,
        date: DateTime.now(),
        memo: 'Belanja petty: $note',
        refType: 'petty-belanja',
        refId: pettyId,
        lines: [
          JournalLineInput(accountCode: accountCode, debit: amount, credit: 0),
          JournalLineInput(accountCode: '1030', debit: 0, credit: amount),
        ],
      );
      await Outbox.write(
        db,
        table: 'expenses',
        rowId: expenseId,
        operation: 'insert',
        payload: {
          'id': expenseId,
          'category': 'Petty: ${def.name}',
          'amount': amount,
          'accountCode': accountCode,
        },
      );
      await Outbox.write(
        db,
        table: 'petty_cash',
        rowId: pettyId,
        operation: 'insert',
        payload: {'id': pettyId, 'amount': -amount, 'note': note},
      );
      await Outbox.writeJournal(db, journalId);
      return pettyId;
    });
  }

  /// Ringkasan shift: jumlah transaksi + omzet tunai/QRIS/bank/ojol.
  static Future<Map<String, int>> shiftSummary(
    AppDatabase db,
    String shiftId,
  ) async {
    final sales = await (db.select(db.sales)
          ..where((s) => s.shiftId.equals(shiftId) & s.voided.equals(0)))
        .get();
    var tunai = 0;
    var qris = 0;
    var bank = 0;
    var ojol = 0;
    var total = 0;
    for (final sale in sales) {
      total += sale.total;
      final payments = await (db.select(db.salePayments)
            ..where((p) => p.saleId.equals(sale.id)))
          .get();
      for (final p in payments) {
        switch (p.method) {
          case 'tunai':
            tunai += p.amount;
            break;
          case 'ojol':
            ojol += p.amount;
            break;
          // Fase 3: transfer/debit masuk Bank (1010), BUKAN QRIS.
          case 'transfer':
          case 'debit':
            bank += p.amount;
            break;
          default:
            qris += p.amount;
        }
      }
    }
    // Kembalian sudah dikeluarkan dari laci: kurangi dari tunai.
    final change = sales.fold<int>(0, (s, x) => s + x.change);
    return {
      'transactions': sales.length,
      'total': total,
      'tunaiNet': tunai - change,
      'qris': qris,
      'bank': bank,
      'ojol': ojol,
      'change': change,
    };
  }
}
