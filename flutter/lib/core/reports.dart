// Casirz ERP — Fase 1 Core Engine.
// Laporan — dihitung dari jurnal + sales, BUKAN angka ketik
// (BLUEPRINT-FLUTTER.md §5.6, §7.4).
//
// Laba Rugi: Pendapatan Kotor - Diskon - Komisi Ojol = Pendapatan Bersih
//   - HPP = Laba Kotor
//   - (OPEX + Penyusutan + Amortisasi Sewa + Selisih Stok + Wastage
//      + Selisih Kas) = Laba Bersih.
// Neraca: Aktiva HARUS = Kewajiban + Ekuitas; selisih harus 0.
// Arus Kas: Operasi / Investasi / Pendanaan dari mutasi akun kas
//   (1000+1010+1020+1030), diklasifikasi per refType jurnal:
//   'modal'/'prive' -> pendanaan; 'aset'/'aset-beli' -> investasi;
//   sisanya -> operasi. (Klasifikasi v1 — didokumentasikan, bukan angka
//   karangan: jurnal modal seed masuk pendanaan, penjualan masuk operasi.)
import 'accounts.dart';
import 'db.dart';

import 'package:drift/drift.dart';

/// Laba Rugi satu periode.
class ProfitLoss {
  const ProfitLoss({
    required this.grossRevenue,
    required this.discount,
    required this.ojolFee,
    required this.netRevenue,
    required this.hpp,
    required this.grossProfit,
    required this.opex,
    required this.depreciation,
    required this.rentAmortization,
    required this.stockDiff,
    required this.wastage,
    required this.cashDiff,
    required this.netProfit,
  });
  final int grossRevenue; // 4000 (kredit normal)
  final int discount; // 4100 (debit normal)
  final int ojolFee; // 4200
  final int netRevenue; // kotor - diskon - komisi
  final int hpp; // 5000
  final int grossProfit;
  final int opex; // 5100-5170
  final int depreciation; // 5180
  final int rentAmortization; // 5190
  final int stockDiff; // 5200
  final int wastage; // 5210
  final int cashDiff; // 5220
  final int netProfit;

  double get grossMarginPct =>
      netRevenue == 0 ? 0 : grossProfit / netRevenue * 100;
  double get netMarginPct =>
      netRevenue == 0 ? 0 : netProfit / netRevenue * 100;
}

/// Neraca pada satu tanggal.
class BalanceSheet {
  const BalanceSheet({
    required this.cash,
    required this.bank,
    required this.qris,
    required this.petty,
    required this.inventory,
    required this.inventoryMaterials,
    required this.inventoryGoods,
    required this.prepaidRent,
    required this.fixedAssets,
    required this.accumulatedDepreciation,
    required this.totalAssets,
    required this.payables,
    required this.taxPayable,
    required this.totalLiabilities,
    required this.capital,
    required this.retainedEarnings,
    required this.currentProfit,
    required this.totalEquity,
    required this.difference,
  });
  final int cash; // 1000
  final int bank; // 1010
  final int qris; // 1020
  final int petty; // 1030
  // Persediaan total = 1100 + 1110 (Fase 4). 1100 harus = Σ totalValue
  // bahan persis; 1110 = nilai barang dagangan (produk tanpa BOM).
  final int inventory; // 1100 + 1110 (BOLEH NEGATIF bila stok minus)
  final int inventoryMaterials; // 1100
  final int inventoryGoods; // 1110
  final int prepaidRent; // 1200
  final int fixedAssets; // 1300
  final int accumulatedDepreciation; // 1310
  final int totalAssets;
  final int payables; // 2000
  final int taxPayable; // 2100
  final int totalLiabilities;
  final int capital; // 3000
  final int retainedEarnings; // 3100
  final int currentProfit; // laba tahun berjalan (dari Laba Rugi)
  final int totalEquity;
  /// Selisih Aktiva - (Kewajiban + Ekuitas). HARUS 0.
  final int difference;
}

/// Arus Kas satu periode.
class CashFlow {
  const CashFlow({
    required this.operating,
    required this.investing,
    required this.financing,
    required this.netChange,
    required this.openingBalance,
    required this.closingBalance,
  });
  final int operating;
  final int investing;
  final int financing;
  final int netChange;
  final int openingBalance;
  final int closingBalance;
}

class Reports {
  static const _cashAccounts = {'1000', '1010', '1020', '1030'};
  static const _opexAccounts = {
    '5100',
    '5110',
    '5120',
    '5130',
    '5140',
    '5150',
    '5160',
    '5170',
  };

  static Future<ProfitLoss> profitLoss(
    AppDatabase db,
    DateTime from,
    DateTime to,
  ) async {
    final b = await _balancesInRange(
      db,
      from.millisecondsSinceEpoch,
      to.millisecondsSinceEpoch,
    );
    final grossRevenue = b['4000'] ?? 0;
    final discount = b['4100'] ?? 0;
    final ojolFee = b['4200'] ?? 0;
    final netRevenue = grossRevenue - discount - ojolFee;
    final hpp = b['5000'] ?? 0;
    final grossProfit = netRevenue - hpp;
    var opex = 0;
    for (final code in _opexAccounts) {
      opex += b[code] ?? 0;
    }
    final depreciation = b['5180'] ?? 0;
    final rentAmortization = b['5190'] ?? 0;
    final stockDiff = b['5200'] ?? 0;
    final wastage = b['5210'] ?? 0;
    final cashDiff = b['5220'] ?? 0;
    final netProfit = grossProfit -
        (opex +
            depreciation +
            rentAmortization +
            stockDiff +
            wastage +
            cashDiff);
    return ProfitLoss(
      grossRevenue: grossRevenue,
      discount: discount,
      ojolFee: ojolFee,
      netRevenue: netRevenue,
      hpp: hpp,
      grossProfit: grossProfit,
      opex: opex,
      depreciation: depreciation,
      rentAmortization: rentAmortization,
      stockDiff: stockDiff,
      wastage: wastage,
      cashDiff: cashDiff,
      netProfit: netProfit,
    );
  }

  static Future<BalanceSheet> balanceSheet(
    AppDatabase db,
    DateTime asOf,
  ) async {
    final b = await _balancesUpTo(db, asOf.millisecondsSinceEpoch);
    final cash = b['1000'] ?? 0;
    final bank = b['1010'] ?? 0;
    final qris = b['1020'] ?? 0;
    final petty = b['1030'] ?? 0;
    final inventoryMaterials = b['1100'] ?? 0;
    final inventoryGoods = b['1110'] ?? 0;
    final inventory = inventoryMaterials + inventoryGoods;
    final prepaidRent = b['1200'] ?? 0;
    final fixedAssets = b['1300'] ?? 0;
    final accumulatedDepreciation = b['1310'] ?? 0;
    final totalAssets = cash +
        bank +
        qris +
        petty +
        inventory +
        prepaidRent +
        (fixedAssets - accumulatedDepreciation);
    final payables = b['2000'] ?? 0;
    final taxPayable = b['2100'] ?? 0;
    final totalLiabilities = payables + taxPayable;
    final capital = b['3000'] ?? 0;
    final retainedEarnings = b['3100'] ?? 0;
    // Laba tahun berjalan = Laba Rugi sejak awal s.d. asOf.
    final pl = await profitLoss(
      db,
      DateTime.fromMillisecondsSinceEpoch(0),
      asOf,
    );
    final currentProfit = pl.netProfit;
    final totalEquity = capital + retainedEarnings + currentProfit;
    return BalanceSheet(
      cash: cash,
      bank: bank,
      qris: qris,
      petty: petty,
      inventory: inventory,
      inventoryMaterials: inventoryMaterials,
      inventoryGoods: inventoryGoods,
      prepaidRent: prepaidRent,
      fixedAssets: fixedAssets,
      accumulatedDepreciation: accumulatedDepreciation,
      totalAssets: totalAssets,
      payables: payables,
      taxPayable: taxPayable,
      totalLiabilities: totalLiabilities,
      capital: capital,
      retainedEarnings: retainedEarnings,
      currentProfit: currentProfit,
      totalEquity: totalEquity,
      difference: totalAssets - (totalLiabilities + totalEquity),
    );
  }

  static Future<CashFlow> cashFlow(
    AppDatabase db,
    DateTime from,
    DateTime to,
  ) async {
    final fromMs = from.millisecondsSinceEpoch;
    final toMs = to.millisecondsSinceEpoch;
    final opening = await _cashBalanceUpTo(db, fromMs - 1);
    final closing = await _cashBalanceUpTo(db, toMs);

    var operating = 0;
    var investing = 0;
    var financing = 0;
    final journals = await (db.select(db.journals)
          ..where(
            (j) =>
                j.date.isBiggerOrEqualValue(fromMs) &
                j.date.isSmallerOrEqualValue(toMs),
          ))
        .get();
    for (final journal in journals) {
      final lines = await (db.select(db.journalLines)
            ..where((l) => l.journalId.equals(journal.id)))
          .get();
      var cashDelta = 0;
      for (final line in lines) {
        if (_cashAccounts.contains(line.accountCode)) {
          // Kas naik bila debit (aset normal debit).
          cashDelta += line.debit - line.credit;
        }
      }
      if (cashDelta == 0) continue;
      if (journal.refType == 'modal' || journal.refType == 'prive') {
        financing += cashDelta;
      } else if (journal.refType == 'aset' ||
          journal.refType == 'aset-beli') {
        investing += cashDelta;
      } else {
        operating += cashDelta;
      }
    }
    return CashFlow(
      operating: operating,
      investing: investing,
      financing: financing,
      netChange: operating + investing + financing,
      openingBalance: opening,
      closingBalance: closing,
    );
  }

  /// Saldo kas (1000+1010+1020+1030) s.d. [upToMs] (inklusif).
  static Future<int> _cashBalanceUpTo(AppDatabase db, int upToMs) async {
    final b = await _balancesUpTo(db, upToMs);
    var total = 0;
    for (final code in _cashAccounts) {
      total += b[code] ?? 0;
    }
    return total;
  }

  /// Saldo signed semua akun s.d. [upToMs] (inklusif).
  static Future<Map<String, int>> _balancesUpTo(
    AppDatabase db,
    int upToMs,
  ) async {
    return _aggregate(db, (journalDate) => journalDate <= upToMs);
  }

  /// Saldo signed semua akun untuk jurnal dalam [fromMs, toMs] (inklusif).
  static Future<Map<String, int>> _balancesInRange(
    AppDatabase db,
    int fromMs,
    int toMs,
  ) async {
    return _aggregate(
      db,
      (journalDate) => journalDate >= fromMs && journalDate <= toMs,
    );
  }

  static Future<Map<String, int>> _aggregate(
    AppDatabase db,
    bool Function(int journalDateMs) include,
  ) async {
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
      if (!include(journal.date)) continue;
      final def = ChartOfAccounts.byCode(line.accountCode);
      final signed = def.normal == Normal.debit
          ? line.debit - line.credit
          : line.credit - line.debit;
      result[line.accountCode] = (result[line.accountCode] ?? 0) + signed;
    }
    return result;
  }
}
