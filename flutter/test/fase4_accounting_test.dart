// Casirz ERP — Fase 4 (Modul C Akuntansi) tests.
// Akun 1110 + seed oracle baru + modal/aset/OPEX + laporan + CSV/PDF
// + logWastage (id baris stockMoves yang benar).
import 'package:casirz/core/accounting_service.dart';
import 'package:casirz/core/bom.dart';
import 'package:casirz/core/db.dart';
import 'package:casirz/core/ledger.dart';
import 'package:casirz/core/reports.dart';
import 'package:casirz/core/sales_service.dart';
import 'package:casirz/core/seed.dart';
import 'package:casirz/features/accounting/report_export.dart';
import 'package:drift/drift.dart' hide Column, isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';

class Fixture {
  Fixture({
    required this.employeeId,
    required this.kopiSusuId,
    required this.airMineralId,
    required this.susuId,
  });
  final String employeeId;
  final String kopiSusuId;
  final String airMineralId;
  final String susuId;
}

Future<Fixture> seedMinimal(AppDatabase db) async {
  final deviceId = await db.deviceId();
  final now = nowMs();
  final employeeId = newId();
  await db.into(db.employees).insert(
        EmployeesCompanion.insert(
          id: employeeId,
          name: 'Kasir 1',
          role: 'kasir',
          pinHash: '',
          updatedAt: now,
          deviceId: deviceId,
        ),
      );

  Future<String> addIngredient(
    String name,
    String unit,
    double qty,
    int totalCost,
  ) async {
    final id = newId();
    await db.into(db.ingredients).insert(
          IngredientsCompanion.insert(
            id: id,
            name: name,
            unit: unit,
            updatedAt: now,
            deviceId: deviceId,
          ),
        );
    await AccountingService.recordStockIn(
      db,
      ingredientId: id,
      qty: qty,
      totalCost: totalCost,
    );
    return id;
  }

  final kopiId = await addIngredient(
    'Biji Kopi House Blend',
    'gram',
    4000,
    600000,
  );
  final susuId = await addIngredient(
    'Susu UHT Full Cream',
    'ml',
    15000,
    270000,
  );
  final gulaId = await addIngredient('Gula Aren Cair', 'ml', 5000, 300000);
  final cupId = await addIngredient('Cup 16oz', 'pcs', 300, 300000);

  final kopiSusuId = newId();
  await db.into(db.products).insert(
        ProductsCompanion.insert(
          id: kopiSusuId,
          name: 'Kopi Susu Gula Aren',
          category: 'Minuman',
          price: 18000,
          cost: 7360,
          updatedAt: now,
          deviceId: deviceId,
        ),
      );
  final recipeId = newId();
  await db.into(db.recipes).insert(
        RecipesCompanion.insert(
          id: recipeId,
          productId: kopiSusuId,
          updatedAt: now,
          deviceId: deviceId,
        ),
      );
  for (final line in [
    (kopiId, 18.0),
    (susuId, 120.0),
    (gulaId, 25.0),
    (cupId, 1.0),
  ]) {
    await db.into(db.recipeLines).insert(
          RecipeLinesCompanion.insert(
            id: newId(),
            recipeId: recipeId,
            ingredientId: line.$1,
            qty: line.$2,
            updatedAt: now,
            deviceId: deviceId,
          ),
        );
  }

  final airMineralId = newId();
  await db.into(db.products).insert(
        ProductsCompanion.insert(
          id: airMineralId,
          name: 'Air Mineral',
          category: 'Minuman',
          price: 5000,
          cost: 2500,
          stock: const Value(100),
          updatedAt: now,
          deviceId: deviceId,
        ),
      );
  return Fixture(
    employeeId: employeeId,
    kopiSusuId: kopiSusuId,
    airMineralId: airMineralId,
    susuId: susuId,
  );
}

Future<List<JournalLine>> journalLines(
  AppDatabase db,
  String refType,
  String refId,
) async {
  final journal = await (db.select(db.journals)
        ..where((j) => j.refType.equals(refType) & j.refId.equals(refId)))
      .getSingle();
  return (db.select(db.journalLines)
        ..where((l) => l.journalId.equals(journal.id)))
      .get();
}

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.memory();
  });

  tearDown(() async {
    await db.close();
  });

  group('akun 1110 (Fase 4)', () {
    test('jual 3x Air Mineral -> HPP D 5000 / K 1110 Rp7.500, 1100 nol',
        () async {
      final f = await seedMinimal(db);
      final saleId = await SaleService.recordSale(
        db,
        date: DateTime.now(),
        channel: 'takeaway',
        lines: [SaleLineInput(productId: f.airMineralId, qty: 3)],
        payments: const [SalePaymentInput(method: 'tunai', amount: 15000)],
        employeeId: f.employeeId,
      );
      expect(await Ledger.getAccountBalance(db, '5000'), 7500);
      expect(await Ledger.getAccountBalance(db, '1110'), -7500);
      // 1100 hanya bergerak oleh stock-in fixture (4 bahan = 1.470.000),
      // tidak tersentuh HPP produk tanpa BOM.
      expect(await Ledger.getAccountBalance(db, '1100'), 1470000);
      final lines = await journalLines(db, 'sale-hpp', saleId);
      final credits = {for (final l in lines) l.accountCode: l.credit};
      expect(credits['1110'], 7500);
      expect(credits.containsKey('1100'), isFalse);
      final bs = await Reports.balanceSheet(db, DateTime.now());
      expect(bs.difference, 0);
    });

    test('jual campuran BOM + tanpa BOM -> kredit 1100 dan 1110 terpisah',
        () async {
      final f = await seedMinimal(db);
      final saleId = await SaleService.recordSale(
        db,
        date: DateTime.now(),
        channel: 'dine-in',
        lines: [
          SaleLineInput(productId: f.kopiSusuId, qty: 2),
          SaleLineInput(productId: f.airMineralId, qty: 1),
        ],
        payments: const [SalePaymentInput(method: 'tunai', amount: 41000)],
        employeeId: f.employeeId,
      );
      // HPP: 2 x 7.360 (BOM -> 1100) + 1 x 2.500 (tanpa BOM -> 1110).
      expect(await Ledger.getAccountBalance(db, '5000'), 17220);
      expect(await Ledger.getAccountBalance(db, '1100'),
          1470000 - 14720);
      expect(await Ledger.getAccountBalance(db, '1110'), -2500);
      final lines = await journalLines(db, 'sale-hpp', saleId);
      final credits = {for (final l in lines) l.accountCode: l.credit};
      expect(credits['1100'], 14720);
      expect(credits['1110'], 2500);
      final bs = await Reports.balanceSheet(db, DateTime.now());
      expect(bs.difference, 0);
    });

    test('void produk tanpa BOM membalik 1110 ke 0', () async {
      final f = await seedMinimal(db);
      final saleId = await SaleService.recordSale(
        db,
        date: DateTime.now(),
        channel: 'takeaway',
        lines: [SaleLineInput(productId: f.airMineralId, qty: 2)],
        payments: const [SalePaymentInput(method: 'tunai', amount: 10000)],
        employeeId: f.employeeId,
      );
      expect(await Ledger.getAccountBalance(db, '1110'), -5000);
      await SaleService.voidSale(db, saleId);
      expect(await Ledger.getAccountBalance(db, '1110'), 0);
      expect(await Ledger.getAccountBalance(db, '5000'), 0);
      final bs = await Reports.balanceSheet(db, DateTime.now());
      expect(bs.difference, 0);
    });
  });

  group('seed oracle baru (Fase 4)', () {
    test('1100 = Σ totalValue bahan persis; 1110 = Rp242.500', () async {
      await SeedDemo.run(db);
      final ingredients = await db.select(db.ingredients).get();
      final sumTotalValue =
          ingredients.fold<int>(0, (s, i) => s + i.totalValue);
      expect(await Ledger.getAccountBalance(db, '1100'), sumTotalValue);
      expect(sumTotalValue, 3000000 - (210360 - 7500));
      expect(await Ledger.getAccountBalance(db, '1110'), 242500);
      // Air Mineral: stok awal 100 - 3 terjual = 97.
      final airMineral = (await db.select(db.products).get())
          .firstWhere((p) => p.name == 'Air Mineral');
      expect(airMineral.stock, 97);
      final bs = await Reports.balanceSheet(db, DateTime.now());
      expect(bs.difference, 0);
      expect(bs.inventoryMaterials, sumTotalValue);
      expect(bs.inventoryGoods, 242500);
    });

    test('Laba Rugi seed: kotor 363.640; bersih setelah OPEX+susut+sewa',
        () async {
      await SeedDemo.run(db);
      final from = DateTime.now().subtract(const Duration(days: 8));
      final to = DateTime.now();
      final pl0 = await Reports.profitLoss(db, from, to);
      expect(pl0.grossRevenue, 574000);
      expect(pl0.hpp, 210360);
      expect(pl0.grossProfit, 363640);
      expect(pl0.netProfit, 363640);

      // OPEX seed dibayar sekarang: Listrik Rp1.000.000.
      await AccountingService.recordExpense(
        db,
        date: DateTime.now(),
        category: 'Listrik',
        amount: 1000000,
        accountCode: '5100',
        note: 'Listrik bulan ini',
      );
      // Penyusutan bulan seed (4 aset, total 166.667/bln) + amortisasi
      // sewa bulan seed (30jt/12 = 2.500.000/bln).
      final now = DateTime.now();
      final month =
          '${now.year}-${now.month.toString().padLeft(2, '0')}';
      final depr = await AccountingService.processDepreciation(db, month);
      expect(depr, 166667);
      final amort =
          await AccountingService.processRentAmortization(db, month);
      expect(amort, 2500000);

      final pl = await Reports.profitLoss(db, from, DateTime.now());
      expect(pl.opex, 1000000);
      expect(pl.depreciation, 166667);
      expect(pl.rentAmortization, 2500000);
      // 363.640 - 1.000.000 - 166.667 - 2.500.000 = -3.303.027.
      expect(pl.netProfit, 363640 - 1000000 - 166667 - 2500000);
      final bs = await Reports.balanceSheet(db, DateTime.now());
      expect(bs.difference, 0);
    });

    test('Arus Kas seed: operasi 574.000 + pendanaan 17.000.000',
        () async {
      await SeedDemo.run(db);
      final from = DateTime.now().subtract(const Duration(days: 8));
      final to = DateTime.now();
      final cf = await Reports.cashFlow(db, from, to);
      expect(cf.operating, 574000);
      expect(cf.financing, 17000000);
      expect(cf.investing, 0);
      expect(cf.closingBalance, 17574000);
    });
  });

  group('neraca balance', () {
    test('tanpa seed: modal tunai 1jt -> selisih 0', () async {
      await AccountingService.recordCapital(
        db,
        date: DateTime.now(),
        cash: 1000000,
      );
      final bs = await Reports.balanceSheet(db, DateTime.now());
      expect(bs.cash, 1000000);
      expect(bs.capital, 1000000);
      expect(bs.difference, 0);
    });

    test('dengan seed + OPEX + penyusutan -> selisih tetap 0', () async {
      await SeedDemo.run(db);
      await AccountingService.recordExpense(
        db,
        date: DateTime.now(),
        category: 'Air',
        amount: 200000,
        accountCode: '5110',
        note: 'Air',
      );
      final now = DateTime.now();
      final month =
          '${now.year}-${now.month.toString().padLeft(2, '0')}';
      await AccountingService.processDepreciation(db, month);
      await AccountingService.processRentAmortization(db, month);
      final bs = await Reports.balanceSheet(db, DateTime.now());
      expect(bs.difference, 0);
    });
  });

  group('modal awal', () {
    test('kas + bank -> D 1000/1010, K 3000; sekali saja', () async {
      expect(await AccountingService.hasCapitalRecorded(db), isFalse);
      await AccountingService.recordCapital(
        db,
        date: DateTime.now(),
        cash: 500000,
        bank: 1000000,
      );
      expect(await Ledger.getAccountBalance(db, '1000'), 500000);
      expect(await Ledger.getAccountBalance(db, '1010'), 1000000);
      expect(await Ledger.getAccountBalance(db, '3000'), 1500000);
      expect(await AccountingService.hasCapitalRecorded(db), isTrue);
      // Jurnal modal-awal kedua dengan refId sama -> ditolak (UNIQUE).
      await expectLater(
        AccountingService.recordCapital(
          db,
          date: DateTime.now(),
          cash: 1000,
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('modal nol -> throw', () async {
      await expectLater(
        AccountingService.recordCapital(db, date: DateTime.now()),
        throwsArgumentError,
      );
    });
  });

  group('aset tetap + penyusutan', () {
    test('jadwal 10jt/60 bln: bln ke-3 akumulasi 500.001, akhir 166.647',
        () async {
      final amounts = AccountingService.depreciationScheduleAmounts(
        cost: 10000000,
        residualValue: 0,
        usefulLifeMonths: 60,
      );
      expect(amounts.length, 60);
      expect(amounts[0], 166667);
      expect(amounts[1], 166667);
      expect(amounts[2], 166667);
      expect(amounts.sublist(0, 3).fold<int>(0, (s, a) => s + a), 500001);
      expect(amounts[59], 166647); // bulan terakhir: sisa pembulatan
      expect(amounts.fold<int>(0, (s, a) => s + a), 10000000);
    });

    test('tambah aset -> D 1300; susut 3 bulan -> nilai buku 9.499.999',
        () async {
      final assetId = await AccountingService.recordAsset(
        db,
        name: 'Mesin Kopi Test',
        purchaseDate: DateTime(2026, 1, 10),
        cost: 10000000,
        usefulLifeMonths: 60,
      );
      expect(await Ledger.getAccountBalance(db, '1300'), 10000000);
      expect(await Ledger.getAccountBalance(db, '1000'), -10000000);
      var total = 0;
      for (final m in ['2026-01', '2026-02', '2026-03']) {
        total += await AccountingService.processDepreciation(db, m);
      }
      expect(total, 500001);
      final asset = (await db.select(db.assets).get())
          .firstWhere((a) => a.id == assetId);
      expect(asset.accumulatedDepreciation, 500001);
      expect(AccountingService.bookValue(asset), 9499999);
      // Idempotent: proses ulang bulan yang sama -> 0.
      final again =
          await AccountingService.processDepreciation(db, '2026-03');
      expect(again, 0);
      final asset2 = (await db.select(db.assets).get())
          .firstWhere((a) => a.id == assetId);
      expect(asset2.accumulatedDepreciation, 500001);
      final bs = await Reports.balanceSheet(db, DateTime.now());
      expect(bs.difference, 0);
    });

    test('aset residu: 10jt, residu 1jt, 60 bln -> 150.000/bln', () {
      final amounts = AccountingService.depreciationScheduleAmounts(
        cost: 10000000,
        residualValue: 1000000,
        usefulLifeMonths: 60,
      );
      expect(amounts[0], 150000);
      expect(amounts.fold<int>(0, (s, a) => s + a), 9000000);
    });
  });

  group('beban OPEX', () {
    test('kategori -> akun benar; gaji manual -> D 5130', () async {
      expect(
        AccountingService.expenseAccountForCategory('Listrik'),
        '5100',
      );
      expect(
        AccountingService.expenseAccountForCategory('Gaji Staf'),
        '5130',
      );
      expect(
        AccountingService.expenseAccountForCategory('Internet/WiFi'),
        '5120',
      );
      expect(
        () => AccountingService.expenseAccountForCategory('Tidak Ada'),
        throwsArgumentError,
      );
      await AccountingService.recordExpense(
        db,
        date: DateTime.now(),
        category: 'Gaji Staf',
        amount: 1500000,
        accountCode: '5130',
        note: 'Gaji Kasir 1',
        payFrom: 'bank',
      );
      expect(await Ledger.getAccountBalance(db, '5130'), 1500000);
      expect(await Ledger.getAccountBalance(db, '1010'), -1500000);
      final pl = await Reports.profitLoss(
        db,
        DateTime.fromMillisecondsSinceEpoch(0),
        DateTime.now(),
      );
      expect(pl.opex, 1500000);
    });

    test('beban bukan akun Beban -> throw', () async {
      await expectLater(
        AccountingService.recordExpense(
          db,
          date: DateTime.now(),
          category: 'X',
          amount: 1000,
          accountCode: '1100',
          note: 'x',
        ),
        throwsArgumentError,
      );
    });
  });

  group('filter tanggal laporan', () {
    test('rentang tanpa transaksi -> 0; 1 hari terakhir seed -> 93.000',
        () async {
      await SeedDemo.run(db);
      final now = DateTime.now();
      // Rentang 30-40 hari lalu: tidak ada transaksi seed.
      final empty = await Reports.profitLoss(
        db,
        now.subtract(const Duration(days: 40)),
        now.subtract(const Duration(days: 30)),
      );
      expect(empty.grossRevenue, 0);
      expect(empty.hpp, 0);
      // 1 hari terakhir: T14 (54.000) + T15 (39.000) = 93.000.
      // HPP: T14 19.720 + T15 12.900 = 32.620.
      final day = await Reports.profitLoss(
        db,
        DateTime(now.year, now.month, now.day)
            .subtract(const Duration(days: 1)),
        now,
      );
      expect(day.grossRevenue, 93000);
      expect(day.hpp, 32620);
      expect(day.grossProfit, 60380);
    });
  });

  group('logWastage (Fase 4)', () {
    test('moveId = id baris stockMoves yang sebenarnya', () async {
      final f = await seedMinimal(db);
      final result = await db.transaction(() async {
        return Bom.logWastage(
          db,
          ingredientId: f.susuId,
          qty: 100,
          reason: 'Susu tumpah',
        );
      });
      expect(result.amount, 1800);
      final rows = await (db.select(db.stockMoves)
            ..where((m) => m.id.equals(result.moveId)))
          .get();
      expect(rows.length, 1);
      expect(rows.first.refId, result.moveId);
      expect(rows.first.type, 'wastage');
    });

    test('recordWastage: outbox memakai id baris stockMoves', () async {
      final f = await seedMinimal(db);
      await AccountingService.recordWastage(
        db,
        ingredientId: f.susuId,
        qty: 100,
        reason: 'Susu tumpah',
      );
      final moves = await (db.select(db.stockMoves)
            ..where((m) => m.type.equals('wastage')))
          .get();
      expect(moves.length, 1);
      final outbox = await (db.select(db.syncOutbox)
            ..where(
              (o) =>
                  o.table.equals('stock_moves') &
                  o.rowId.equals(moves.first.id),
            ))
          .get();
      expect(outbox.length, 1);
    });
  });

  group('export CSV + PDF', () {
    test('CSV berisi angka yang benar dari jurnal', () async {
      await SeedDemo.run(db);
      final from = DateTime.now().subtract(const Duration(days: 8));
      final to = DateTime.now();
      final pl = await Reports.profitLoss(db, from, to);
      final plCsv = profitLossCsv(pl, 'test');
      expect(plCsv, contains('574000'));
      expect(plCsv, contains('363640'));
      expect(plCsv, contains('Laba Bersih'));
      final bs = await Reports.balanceSheet(db, to);
      final bsCsv = balanceSheetCsv(bs, 'test');
      expect(bsCsv, contains('242500'));
      expect(bsCsv, contains('Selisih Balance'));
      expect(bsCsv, contains(',0')); // selisih balance 0
      final cf = await Reports.cashFlow(db, from, to);
      final cfCsv = cashFlowCsv(cf, 'test');
      expect(cfCsv, contains('574000'));
      expect(cfCsv, contains('17000000'));
      expect(cfCsv, contains('17574000'));
    });

    test('PDF laporan menghasilkan bytes PDF valid', () async {
      final bytes = await reportPdfBytes(
        title: 'Laporan Laba Rugi',
        subtitle: 'Periode: test',
        rows: const [
          ReportPdfRow('Pendapatan Kotor', 574000),
          ReportPdfRow('Laba Bersih', 363640, bold: true),
        ],
      );
      expect(bytes.isNotEmpty, isTrue);
      // Header file PDF: %PDF- (isi teks di dalam stream PDF terkompresi/
      // ter-encode, jadi angka tidak dicari mentah di bytes).
      expect(String.fromCharCodes(bytes.sublist(0, 5)), '%PDF-');
      expect(bytes.length, greaterThan(500));
    });
  });
}
