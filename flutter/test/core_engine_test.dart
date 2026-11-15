// Casirz ERP — Fase 1 Core Engine tests.
// Oracle: BLUEPRINT-FLUTTER.md §10.5 + §13.1.
//
// Setiap test memakai database in-memory baru (AppDatabase.memory()).
// Fixture minimal dibangun lewat jalur resmi (recordStockIn +
// SaleService) supaya jurnal seimbang sejak awal — insert bahan
// mentah tanpa jurnal modal akan membuat Neraca tidak balance
// (bukan bug engine, tapi fixture yang tidak didanai).
import 'package:casirz/core/accounting_service.dart';
import 'package:casirz/core/accounts.dart';
import 'package:casirz/core/bom.dart';
import 'package:casirz/core/db.dart';
import 'package:casirz/core/errors.dart';
import 'package:casirz/core/ledger.dart';
import 'package:casirz/core/migration.dart';
import 'package:casirz/core/money.dart';
import 'package:casirz/core/reports.dart';
import 'package:casirz/core/sales_service.dart';
import 'package:casirz/core/seed.dart';
import 'package:casirz/core/sync.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:flutter_test/flutter_test.dart';

class Fixture {
  Fixture({
    required this.employeeId,
    required this.kopiId,
    required this.susuId,
    required this.gulaId,
    required this.cupId,
    required this.kopiSusuId,
    required this.airMineralId,
  });
  final String employeeId;
  final String kopiId;
  final String susuId;
  final String gulaId;
  final String cupId;
  final String kopiSusuId;
  final String airMineralId;
}

/// Fixture minimal: 4 bahan (kopi 4000g @150, susu 15000ml @18,
// gula aren 5000ml @60, cup 300pcs @1000) + produk Kopi Susu Gula Aren
// + Air Mineral + 1 kasir. Bahan masuk lewat recordStockIn (berjurnal)
// supaya Neraca balance.
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
  final susuId = await addIngredient('Susu UHT Full Cream', 'ml', 15000, 270000);
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
          stock: const Value(50),
          updatedAt: now,
          deviceId: deviceId,
        ),
      );

  return Fixture(
    employeeId: employeeId,
    kopiId: kopiId,
    susuId: susuId,
    gulaId: gulaId,
    cupId: cupId,
    kopiSusuId: kopiSusuId,
    airMineralId: airMineralId,
  );
}

Future<double> stockOf(AppDatabase db, String ingredientId) async {
  final row = await (db.select(db.ingredients)
        ..where((i) => i.id.equals(ingredientId)))
      .getSingle();
  return row.stockQty;
}

Future<int> totalValueOf(AppDatabase db, String ingredientId) async {
  final row = await (db.select(db.ingredients)
        ..where((i) => i.id.equals(ingredientId)))
      .getSingle();
  return row.totalValue;
}

void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase.memory();
  });

  tearDown(() async {
    await db.close();
  });

  group('money + accounts', () {
    test('fmt / round3 / toIntRp', () {
      expect(fmt(1500000), 'Rp1.500.000');
      expect(fmt(0), 'Rp0');
      expect(fmt(-5000), '-Rp5.000');
      expect(round3(0.30000000000000004), 0.3);
      expect(round3(1.23456), 1.235);
      expect(toIntRp(10.5), 11);
      expect(fmtQty(1500), '1.500');
      expect(fmtQty(250), '250');
    });

    test('bagan akun: 30 akun, kode 1000-5220 (1110 Fase 4)', () {
      expect(ChartOfAccounts.all.length, 30);
      expect(ChartOfAccounts.byCode('1000').name, 'Kas Tunai / Laci');
      expect(ChartOfAccounts.byCode('1100').type, AccountType.aset);
      expect(ChartOfAccounts.byCode('1110').name,
          'Persediaan Barang Dagangan');
      expect(ChartOfAccounts.byCode('1110').type, AccountType.aset);
      expect(ChartOfAccounts.byCode('1110').normal, Normal.debit);
      expect(ChartOfAccounts.byCode('1310').normal, Normal.kredit);
      expect(ChartOfAccounts.byCode('4000').normal, Normal.kredit);
      expect(ChartOfAccounts.byCode('4100').normal, Normal.debit);
      expect(() => ChartOfAccounts.byCode('9999'), throwsArgumentError);
    });

    test('akun ter-seed saat onCreate', () async {
      final accounts = await db.select(db.accounts).get();
      expect(accounts.length, 30);
      expect(
        accounts.map((a) => a.code).toSet(),
        containsAll(['1000', '1100', '1110', '3000', '4000', '5000', '5220']),
      );
    });
  });

  group('penjualan (kasus uji §13.1 no. 1)', () {
    test('jual 2x Kopi Susu Gula Aren: stok, HPP, jurnal, neraca', () async {
      final f = await seedMinimal(db);
      final saleId = await SaleService.recordSale(
        db,
        date: DateTime.now(),
        channel: 'dine-in',
        lines: [SaleLineInput(productId: f.kopiSusuId, qty: 2)],
        payments: const [SalePaymentInput(method: 'tunai', amount: 36000)],
        employeeId: f.employeeId,
      );

      // Stok: kopi -36g, susu -240ml, gula aren -50ml, cup -2pcs.
      expect(await stockOf(db, f.kopiId), 3964);
      expect(await stockOf(db, f.susuId), 14760);
      expect(await stockOf(db, f.gulaId), 4950);
      expect(await stockOf(db, f.cupId), 298);

      // HPP snapshot per baris: 2 x Rp7.360 = Rp14.720.
      final lines = await (db.select(db.saleLines)
            ..where((l) => l.saleId.equals(saleId)))
          .get();
      expect(lines.length, 1);
      expect(lines.first.hppPerUnit, 7360);
      expect(lines.first.hppPerUnit * lines.first.qty, 14720);

      // Jurnal seimbang: kas +36000 di atas -1.470.000 (stock-in fixture
      // dibayar tunai), pendapatan 36000, HPP 14720.
      expect(await Ledger.getAccountBalance(db, '1000'), -1470000 + 36000);
      expect(await Ledger.getAccountBalance(db, '4000'), 36000);
      expect(await Ledger.getAccountBalance(db, '5000'), 14720);
      expect(await Ledger.getAccountBalance(db, '1100'), 1470000 - 14720);

      // Semua jurnal seimbang (debit == kredit per jurnal).
      final journals = await db.select(db.journals).get();
      expect(journals.length, 6); // 4 stock-in + sale + sale-hpp
      for (final j in journals) {
        final jLines = await (db.select(db.journalLines)
              ..where((l) => l.journalId.equals(j.id)))
            .get();
        final d = jLines.fold<int>(0, (s, l) => s + l.debit);
        final c = jLines.fold<int>(0, (s, l) => s + l.credit);
        expect(d, c, reason: 'jurnal ${j.refType}:${j.refId}');
        expect(d, greaterThan(0));
      }

      // Neraca selisih 0.
      final bs = await Reports.balanceSheet(db, DateTime.now());
      expect(bs.difference, 0);
      expect(bs.totalAssets, bs.totalLiabilities + bs.totalEquity);

      // Outbox tertulis.
      expect(await Outbox.pendingCount(db), greaterThan(0));
    });

    test('HPP snapshot tidak berubah saat avgCost berubah', () async {
      final f = await seedMinimal(db);
      final saleId = await SaleService.recordSale(
        db,
        date: DateTime.now(),
        channel: 'dine-in',
        lines: [SaleLineInput(productId: f.kopiSusuId, qty: 1)],
        payments: const [SalePaymentInput(method: 'tunai', amount: 18000)],
        employeeId: f.employeeId,
      );
      // Beli kopi lagi dengan harga beda -> avg berubah.
      await AccountingService.recordStockIn(
        db,
        ingredientId: f.kopiId,
        qty: 1000,
        totalCost: 200000, // Rp200/g, avg baru != 150
      );
      final lines = await (db.select(db.saleLines)
            ..where((l) => l.saleId.equals(saleId)))
          .get();
      expect(lines.first.hppPerUnit, 7360); // tetap snapshot lama
    });

    test('multi-payment tunai + QRIS', () async {
      final f = await seedMinimal(db);
      await SaleService.recordSale(
        db,
        date: DateTime.now(),
        channel: 'dine-in',
        lines: [SaleLineInput(productId: f.kopiSusuId, qty: 1)],
        payments: const [
          SalePaymentInput(method: 'tunai', amount: 10000),
          SalePaymentInput(method: 'qris', amount: 8000),
        ],
        employeeId: f.employeeId,
      );
      final sale = (await db.select(db.sales).get()).single;
      expect(sale.paymentMethod, 'multi');
      expect(sale.paid, 18000);
      expect(sale.change, 0);
      expect(await Ledger.getAccountBalance(db, '1000'), -1470000 + 10000);
      expect(await Ledger.getAccountBalance(db, '1020'), 8000);
      expect(await Ledger.getAccountBalance(db, '4000'), 18000);
    });

    test('penjualan ojol: netto ke 1020 + komisi 4200', () async {
      final f = await seedMinimal(db);
      await SaleService.recordSale(
        db,
        date: DateTime.now(),
        channel: 'ojol',
        lines: [SaleLineInput(productId: f.kopiSusuId, qty: 1)],
        payments: const [SalePaymentInput(method: 'ojol', amount: 14400)],
        employeeId: f.employeeId,
        ojolFee: 3600,
      );
      expect(await Ledger.getAccountBalance(db, '1020'), 14400);
      expect(await Ledger.getAccountBalance(db, '4200'), 3600);
      expect(await Ledger.getAccountBalance(db, '4000'), 18000);
      final bs = await Reports.balanceSheet(db, DateTime.now());
      expect(bs.difference, 0);
    });

    test('pembayaran kurang -> throw, tidak ada sisa', () async {
      final f = await seedMinimal(db);
      await expectLater(
        SaleService.recordSale(
          db,
          date: DateTime.now(),
          channel: 'dine-in',
          lines: [SaleLineInput(productId: f.kopiSusuId, qty: 1)],
          payments: const [SalePaymentInput(method: 'tunai', amount: 10000)],
          employeeId: f.employeeId,
        ),
        throwsA(isA<PembayaranTidakCocok>()),
      );
      expect(await db.select(db.sales).get(), isEmpty);
      expect(await stockOf(db, f.kopiId), 4000); // stok utuh
    });
  });

  group('stok minus (§13.1 no. 2)', () {
    test('jual saat stok minus: tetap berhasil, HPP tetap benar', () async {
      final f = await seedMinimal(db);
      // Habiskan kopi sampai minus: jual 250x (butuh 4500g, stok 4000g).
      await SaleService.recordSale(
        db,
        date: DateTime.now(),
        channel: 'dine-in',
        lines: [SaleLineInput(productId: f.kopiSusuId, qty: 250)],
        payments: const [
          SalePaymentInput(method: 'tunai', amount: 4500000),
        ],
        employeeId: f.employeeId,
      );
      final kopiStock = await stockOf(db, f.kopiId);
      expect(kopiStock, -500); // 4000 - 250*18 = -500
      expect(kopiStock, lessThan(0));
      // HPP tetap dari avgCostMilli terakhir: 250 x 7360.
      expect(await Ledger.getAccountBalance(db, '5000'), 250 * 7360);
      // avgCostMilli TIDAK berubah saat konsumsi.
      final kopi = await (db.select(db.ingredients)
            ..where((i) => i.id.equals(f.kopiId)))
          .getSingle();
      expect(kopi.avgCostMilli, 150000);
      // totalValue boleh negatif apa adanya.
      expect(await totalValueOf(db, f.kopiId), lessThan(0));
      final bs = await Reports.balanceSheet(db, DateTime.now());
      expect(bs.difference, 0);
    });
  });

  group('ledger', () {
    test('postJournal Debit != Credit -> throw, tanpa sisa', () async {
      await expectLater(
        Ledger.postJournalStandalone(
          db,
          date: DateTime.now(),
          memo: 'tes tidak seimbang',
          refType: 'tes',
          refId: 'tes-1',
          lines: const [
            JournalLineInput(accountCode: '1000', debit: 10000, credit: 0),
            JournalLineInput(accountCode: '4000', debit: 0, credit: 9000),
          ],
        ),
        throwsA(isA<JurnalTidakSeimbang>()),
      );
      expect(await db.select(db.journals).get(), isEmpty);
      expect(await db.select(db.journalLines).get(), isEmpty);
    });

    test('satu baris debit+credit sekaligus -> throw', () async {
      await expectLater(
        Ledger.postJournalStandalone(
          db,
          date: DateTime.now(),
          memo: 'tes',
          refType: 'tes',
          refId: 'tes-2',
          lines: const [
            JournalLineInput(accountCode: '1000', debit: 1000, credit: 1000),
          ],
        ),
        throwsA(isA<JurnalTidakSeimbang>()),
      );
    });

    test('refType+refId ganda -> throw (idempotensi)', () async {
      const lines = [
        JournalLineInput(accountCode: '1000', debit: 5000, credit: 0),
        JournalLineInput(accountCode: '4000', debit: 0, credit: 5000),
      ];
      await Ledger.postJournalStandalone(
        db,
        date: DateTime.now(),
        memo: 'tes',
        refType: 'tes',
        refId: 'tes-3',
        lines: lines,
      );
      await expectLater(
        Ledger.postJournalStandalone(
          db,
          date: DateTime.now(),
          memo: 'tes ulang',
          refType: 'tes',
          refId: 'tes-3',
          lines: lines,
        ),
        throwsA(isA<StateError>()),
      );
      expect((await db.select(db.journals).get()).length, 1);
    });

    test('rollback penuh: jurnal + stok batal bila transaksi gagal',
        () async {
      final f = await seedMinimal(db);
      final before = await stockOf(db, f.kopiId);
      await expectLater(
        db.transaction(() async {
          await Ledger.postJournal(
            db,
            date: DateTime.now(),
            memo: 'tes rollback',
            refType: 'tes',
            refId: 'tes-rollback',
            lines: const [
              JournalLineInput(accountCode: '1000', debit: 1000, credit: 0),
              JournalLineInput(accountCode: '4000', debit: 0, credit: 1000),
            ],
          );
          await Bom.deductBOM(
            db,
            productId: f.kopiSusuId,
            qty: 1,
            saleId: 'tes-rollback',
          );
          throw Exception('gagal sengaja');
        }),
        throwsException,
      );
      expect(await db.select(db.journals).get(), hasLength(4)); // hanya stock-in
      expect(await stockOf(db, f.kopiId), before);
    });
  });

  group('void (§5.2)', () {
    test('void: jurnal pembalik + stok kembali', () async {
      final f = await seedMinimal(db);
      final saleId = await SaleService.recordSale(
        db,
        date: DateTime.now(),
        channel: 'dine-in',
        lines: [SaleLineInput(productId: f.kopiSusuId, qty: 2)],
        payments: const [SalePaymentInput(method: 'tunai', amount: 36000)],
        employeeId: f.employeeId,
      );
      expect(await stockOf(db, f.kopiId), 3964);

      await SaleService.voidSale(db, saleId);

      // Stok kembali persis.
      expect(await stockOf(db, f.kopiId), 4000);
      expect(await stockOf(db, f.susuId), 15000);
      expect(await stockOf(db, f.gulaId), 5000);
      expect(await stockOf(db, f.cupId), 300);
      // Saldo penjualan + HPP kembali nol (jurnal pembalik).
      expect(await Ledger.getAccountBalance(db, '1000'), -1470000);
      expect(await Ledger.getAccountBalance(db, '4000'), 0);
      expect(await Ledger.getAccountBalance(db, '5000'), 0);
      expect(await Ledger.getAccountBalance(db, '1100'), 1470000);
      // Jurnal pembalik tercatat.
      final reversals = await (db.select(db.journals)
            ..where((j) => j.isReversal.equals(1)))
          .get();
      expect(reversals.length, 2);
      expect(reversals.map((j) => j.refType).toSet(),
          {'sale-void', 'sale-hpp-void'});
      // stockMoves void-kembali ada.
      final voidMoves = await (db.select(db.stockMoves)
            ..where((m) => m.type.equals('void-kembali')))
          .get();
      expect(voidMoves.length, 4);
      // Neraca tetap balance.
      final bs = await Reports.balanceSheet(db, DateTime.now());
      expect(bs.difference, 0);
    });

    test('void kedua -> throw', () async {
      final f = await seedMinimal(db);
      final saleId = await SaleService.recordSale(
        db,
        date: DateTime.now(),
        channel: 'dine-in',
        lines: [SaleLineInput(productId: f.kopiSusuId, qty: 1)],
        payments: const [SalePaymentInput(method: 'tunai', amount: 18000)],
        employeeId: f.employeeId,
      );
      await SaleService.voidSale(db, saleId);
      await expectLater(
        SaleService.voidSale(db, saleId),
        throwsA(isA<PenjualanSudahDibatalkan>()),
      );
    });

    test('void produk tanpa BOM kembalikan products.stock', () async {
      final f = await seedMinimal(db);
      final saleId = await SaleService.recordSale(
        db,
        date: DateTime.now(),
        channel: 'takeaway',
        lines: [SaleLineInput(productId: f.airMineralId, qty: 3)],
        payments: const [SalePaymentInput(method: 'tunai', amount: 15000)],
        employeeId: f.employeeId,
      );
      final afterSale = await (db.select(db.products)
            ..where((p) => p.id.equals(f.airMineralId)))
          .getSingle();
      expect(afterSale.stock, 47);
      await SaleService.voidSale(db, saleId);
      final afterVoid = await (db.select(db.products)
            ..where((p) => p.id.equals(f.airMineralId)))
          .getSingle();
      expect(afterVoid.stock, 50);
    });
  });

  group('moving average (§4.2)', () {
    test('beli 1000g @150.000 lalu 500g @90.000 -> avg Rp160/g', () async {
      final deviceId = await db.deviceId();
      final ingId = newId();
      await db.into(db.ingredients).insert(
            IngredientsCompanion.insert(
              id: ingId,
              name: 'Biji Kopi House Blend',
              unit: 'gram',
              updatedAt: nowMs(),
              deviceId: deviceId,
            ),
          );
      await AccountingService.recordStockIn(
        db,
        ingredientId: ingId,
        qty: 1000,
        totalCost: 150000,
      );
      var ing = await (db.select(db.ingredients)
            ..where((i) => i.id.equals(ingId)))
          .getSingle();
      expect(ing.avgCostMilli, 150000); // Rp150/g
      expect(ing.totalValue, 150000);
      await AccountingService.recordStockIn(
        db,
        ingredientId: ingId,
        qty: 500,
        totalCost: 90000,
      );
      ing = await (db.select(db.ingredients)
            ..where((i) => i.id.equals(ingId)))
          .getSingle();
      expect(ing.stockQty, 1500);
      expect(ing.totalValue, 240000);
      expect(ing.avgCostMilli, 160000); // Rp160/g
    });

    test('stockIn qty 0 -> throw (hindari bagi nol)', () async {
      final f = await seedMinimal(db);
      await expectLater(
        AccountingService.recordStockIn(
          db,
          ingredientId: f.kopiId,
          qty: 0,
          totalCost: 1000,
        ),
        throwsArgumentError,
      );
    });
  });

  group('penyusutan idempotent', () {
    test('proses 2x bulan yang sama: jurnal tidak ganda', () async {
      final deviceId = await db.deviceId();
      final assetId = newId();
      await db.into(db.assets).insert(
            AssetsCompanion.insert(
              id: assetId,
              name: 'Mesin Kopi',
              purchaseDate: DateTime(2026, 11, 1).millisecondsSinceEpoch,
              cost: 10000000,
              residualValue: 0,
              usefulLifeMonths: 60,
              updatedAt: nowMs(),
              deviceId: deviceId,
            ),
          );
      final first = await AccountingService.processDepreciation(db, '2026-11');
      expect(first, 166667); // 10jt / 60 bln, dibulatkan
      final second =
          await AccountingService.processDepreciation(db, '2026-11');
      expect(second, 0);
      final journals = await (db.select(db.journals)
            ..where((j) => j.refType.equals('penyusutan')))
          .get();
      expect(journals.length, 1);
      expect(journals.single.refId, 'asset:$assetId:2026-11');
      final asset = await (db.select(db.assets)
            ..where((a) => a.id.equals(assetId)))
          .getSingle();
      expect(asset.accumulatedDepreciation, 166667);
      expect(asset.lastDepreciationMonth, '2026-11');
      expect(await Ledger.getAccountBalance(db, '5180'), 166667);
      expect(await Ledger.getAccountBalance(db, '1310'), 166667);
    });

    test('amortisasi sewa idempotent: 30jt/12 bln = 2,5jt/bln', () async {
      await db.setSetting('rentTotal', '30000000');
      await db.setSetting('rentMonths', '12');
      await db.setSetting('rentStartMonth', '2026-11');
      // Dana sewa muka dulu (kalau tidak, 1200 jadi minus — tetap balance,
      // tapi test ini fokus ke jurnal amortisasi).
      await AccountingService.recordCapital(
        db,
        date: DateTime(2026, 11, 1),
        rentPrepaid: 30000000,
        refId: 'modal-sewa-tes',
      );
      final first =
          await AccountingService.processRentAmortization(db, '2026-11');
      expect(first, 2500000);
      final second =
          await AccountingService.processRentAmortization(db, '2026-11');
      expect(second, 0);
      expect(await Ledger.getAccountBalance(db, '5190'), 2500000);
      expect(await Ledger.getAccountBalance(db, '1200'), 27500000);
    });
  });

  group('wastage + opname', () {
    test('wastage susu 100ml -> D 5210 Rp1.800', () async {
      final f = await seedMinimal(db);
      final amount = await AccountingService.recordWastage(
        db,
        ingredientId: f.susuId,
        qty: 100,
        reason: 'Susu tumpah',
      );
      expect(amount, 1800);
      expect(await stockOf(db, f.susuId), 14900);
      expect(await Ledger.getAccountBalance(db, '5210'), 1800);
      expect(await Ledger.getAccountBalance(db, '1100'), 1470000 - 1800);
    });

    test('opname susut 50g kopi -> D 5200 Rp7.500', () async {
      final f = await seedMinimal(db);
      final opnameId = await AccountingService.createOpnameDraft(
        db,
        employeeId: f.employeeId,
        actualByIngredient: {f.kopiId: 3950},
      );
      await AccountingService.postOpname(db, opnameId);
      expect(await stockOf(db, f.kopiId), 3950);
      expect(await Ledger.getAccountBalance(db, '5200'), 7500);
      // Posting ulang -> throw.
      await expectLater(
        AccountingService.postOpname(db, opnameId),
        throwsA(isA<StateError>()),
      );
    });
  });

  group('seed demo (§10.5 oracle)', () {
    test('omzet 574.000, HPP 210.360, laba kotor 363.640', () async {
      await SeedDemo.run(db);
      final from = DateTime.now().subtract(const Duration(days: 8));
      final to = DateTime.now();
      final pl = await Reports.profitLoss(db, from, to);
      expect(pl.grossRevenue, 574000);
      expect(pl.hpp, 210360);
      expect(pl.grossProfit, 363640);
      expect(pl.netProfit, 363640); // belum ada OPEX/penyusutan
      expect(pl.discount, 0);
      expect(pl.ojolFee, 0);

      final bs = await Reports.balanceSheet(db, DateTime.now());
      expect(bs.difference, 0);
      expect(bs.capital, 60000000);
      expect(bs.bank, 17000000);
      expect(bs.prepaidRent, 30000000);
      expect(bs.fixedAssets, 10000000);
      // Persediaan = 1100 + 1110 (Fase 4): bahan 3.000.000 - HPP bahan
      // 202.860 (= 210.360 - 7.500 HPP Air Mineral) = 2.797.140, ditambah
      // barang dagangan 250.000 - 3 x 2.500 = 242.500.
      expect(bs.inventoryMaterials, 3000000 - (210360 - 7500));
      expect(bs.inventoryGoods, 250000 - 3 * 2500);
      expect(bs.inventory, (3000000 - (210360 - 7500)) + (250000 - 7500));
      // Saldo 1100 = Σ totalValue bahan persis (selisih Rp7.500 lama hilang).
      expect(await Ledger.getAccountBalance(db, '1100'),
          3000000 - (210360 - 7500));
      expect(await Ledger.getAccountBalance(db, '1110'), 242500);
      expect(bs.cash, 288000); // tunai: T1+T3+T4+T7+T8+T11+T12+T15
      expect(bs.qris, 286000); // QRIS+ojol: T2+T5+T6+T9+T10+T13+T14

      // Arus kas: operasi 574.000, pendanaan 17.000.000 (modal bank).
      final cf = await Reports.cashFlow(db, from, to);
      expect(cf.operating, 574000);
      expect(cf.financing, 17000000);
      expect(cf.investing, 0);
      expect(cf.openingBalance, 0);
      expect(cf.closingBalance, 17574000);
      expect(cf.netChange, 17574000);
    });

    test('11 bahan total tepat Rp3.000.000, 10 menu', () async {
      await SeedDemo.run(db);
      final ingredients = await db.select(db.ingredients).get();
      expect(ingredients.length, 11);
      final totalValue =
          ingredients.fold<int>(0, (s, i) => s + i.totalValue);
      // Nilai awal 3jt dikurangi HPP bahan (210.360 - 7.500 HPP Air Mineral
      // yang tanpa BOM — sejak Fase 4 HPP produk tanpa BOM dijurnal ke
      // 1110, jadi tidak mengurangi totalValue bahan mana pun; saldo
      // akun 1100 kini = Σ totalValue bahan persis).
      expect(totalValue, 3000000 - (210360 - 7500));
      final products = await db.select(db.products).get();
      expect(products.length, 10);
      final sales = await db.select(db.sales).get();
      expect(sales.length, 15);
      // HPP Kopi Susu Gula Aren Rp7.360.
      final kopi = products.firstWhere(
        (p) => p.name == 'Kopi Susu Gula Aren',
      );
      expect(await Bom.hppPerUnit(db, kopi.id), 7360);
    });

    test('seed 2x: reset & isi ulang, tidak duplikat', () async {
      await SeedDemo.run(db);
      await SeedDemo.run(db);
      expect((await db.select(db.sales).get()).length, 15);
      expect((await db.select(db.products).get()).length, 10);
      expect((await db.select(db.ingredients).get()).length, 11);
      final from = DateTime.now().subtract(const Duration(days: 8));
      final pl = await Reports.profitLoss(db, from, DateTime.now());
      expect(pl.grossRevenue, 574000);
      expect(pl.hpp, 210360);
      final bs = await Reports.balanceSheet(db, DateTime.now());
      expect(bs.difference, 0);
    });
  });

  group('migrasi (§9)', () {
    const exportJson = '''
{
  "format": "casirz-export-v1",
  "exportedAt": "2026-11-15T08:00:00Z",
  "storeName": "Casirz",
  "products": [
    {"id": "p1", "name": "Kopi Susu Gula Aren", "category": "Minuman",
     "price": 18000, "cost": 9000, "stock": 50}
  ],
  "customers": [{"id": "c1", "name": "Budi", "phone": "0812", "points": 10}],
  "promos": [{"id": "pr1", "code": "HEMAT10", "type": "persen", "value": 10}],
  "sales": [
    {"id": "s1", "code": "CSZ-20261114-0001", "date": 1763078400000,
     "total": 36000, "paymentMethod": "tunai",
     "items": [{"productId": "p1", "qty": 2, "price": 18000}]}
  ],
  "employees": [{"id": "e1", "name": "Kasir Lama", "role": "kasir"}]
}
''';

    test('import valid: saldo awal + historis tanpa jurnal', () async {
      final summary =
          await Migration.importFromJsonString(db, exportJson);
      expect(summary.products, 1);
      expect(summary.customers, 1);
      expect(summary.sales, 1);
      expect(summary.openingBalance, 450000); // 9000 x 50
      expect(await db.getSetting('migrated'), '1');

      // Saldo awal: D 1100 / K 3100.
      expect(await Ledger.getAccountBalance(db, '1100'), 450000);
      expect(await Ledger.getAccountBalance(db, '3100'), 450000);

      // Penjualan historis TIDAK masuk Laba Rugi baru.
      final pl = await Reports.profitLoss(
        db,
        DateTime.fromMillisecondsSinceEpoch(0),
        DateTime.now(),
      );
      expect(pl.grossRevenue, 0);
      // Tapi barisnya tersimpan (label "Data lama" di UI nanti).
      expect((await db.select(db.sales).get()).length, 1);
      final lines = await db.select(db.saleLines).get();
      expect(lines.length, 1);
      expect(lines.first.hppPerUnit, 9000); // = products.cost
      final bs = await Reports.balanceSheet(db, DateTime.now());
      expect(bs.difference, 0);
    });

    test('format salah -> throw, tidak ada data masuk', () async {
      await expectLater(
        Migration.importFromJsonString(db, '{"format": "lain"}'),
        throwsA(isA<MigrasiTidakValid>()),
      );
      expect(await db.select(db.products).get(), isEmpty);
      expect(await db.getSetting('migrated'), isNull);
    });

    test('produk tidak dikenal di penjualan -> throw', () async {
      const bad = '''
{"format": "casirz-export-v1",
 "products": [{"id": "p1", "name": "A", "price": 1000, "cost": 500, "stock": 1}],
 "sales": [{"id": "s1", "code": "X-1", "date": 1, "total": 1000,
   "paymentMethod": "tunai",
   "items": [{"productId": "tidak-ada", "qty": 1, "price": 1000}]}]}
''';
      await expectLater(
        Migration.importFromJsonString(db, bad),
        throwsA(isA<MigrasiTidakValid>()),
      );
      expect(await db.select(db.products).get(), isEmpty);
    });

    test('database tidak kosong -> migrasi ditolak', () async {
      await Migration.importFromJsonString(db, exportJson);
      await expectLater(
        Migration.importFromJsonString(db, exportJson),
        throwsA(isA<StateError>()),
      );
    });
  });

  group('sync outbox', () {
    test('tulis lokal ikut menulis outbox', () async {
      final f = await seedMinimal(db);
      final before = await Outbox.pendingCount(db);
      await SaleService.recordSale(
        db,
        date: DateTime.now(),
        channel: 'dine-in',
        lines: [SaleLineInput(productId: f.kopiSusuId, qty: 1)],
        payments: const [SalePaymentInput(method: 'tunai', amount: 18000)],
        employeeId: f.employeeId,
      );
      final after = await Outbox.pendingCount(db);
      expect(after, greaterThan(before));
    });

    test('delete dilarang untuk tabel APPEND', () async {
      await expectLater(
        Outbox.write(
          db,
          table: 'sales',
          rowId: 'x',
          operation: 'delete',
          payload: {'id': 'x'},
        ),
        throwsArgumentError,
      );
    });

    test('Supabase belum aktif -> throw', () {
      expect(
        () => SupabaseClient.notYetEnabled(),
        throwsA(isA<StateError>()),
      );
    });

    test('stub sync: push/pull throw, status terbaca', () async {
      final engine = StubSyncEngine(db);
      await expectLater(engine.pushPending(), throwsA(isA<StateError>()));
      await expectLater(engine.pullDelta(), throwsA(isA<StateError>()));
      final status = await engine.statusStream.first;
      expect(status.pendingCount, 0);
      expect(status.lastSyncAt, isNull);
    });
  });
}
