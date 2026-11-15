// Casirz ERP — Fase 3 Bagian A (patch engine) tests.
// Prasyarat Fase 3 (Adendum pasca-Fase 2 butir 2–3):
// 1. Akrual poin ATOMIK di dalam transaksi recordSale
//    (1 poin / Rp10.000, floor(total/10000)) — rollback penjualan
//    tidak meninggalkan poin; tidak ada lagi jalur akrual terpisah.
// 2. Metode bayar 'transfer'/'debit' -> akun 1010 Bank;
//    QRIS/E-Wallet tetap 1020; tunai 1000; ojol netto 1020.
// 3. Void membalik poin yang diakrual penjualan itu.
import 'package:casirz/core/accounting_service.dart';
import 'package:casirz/core/db.dart';
import 'package:casirz/core/sales_service.dart';
import 'package:casirz/features/pos/cart.dart';
import 'package:casirz/features/pos/customer_service.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';

/// Fixture minimal (pola sama seperti test Fase 1/2): 4 bahan +
/// Kopi Susu Gula Aren (HPP Rp7.360) + Air Mineral + 1 kasir.
Future<(String, String, String)> seedMinimal(AppDatabase db) async {
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
          stock: Value(100),
          updatedAt: now,
          deviceId: deviceId,
        ),
      );
  return (employeeId, kopiSusuId, airMineralId);
}

Future<String> addCustomer(AppDatabase db, String name) =>
    CustomerService.addCustomer(db, name: name);

/// Baris jurnal (akun -> debit) untuk satu event.
Future<Map<String, int>> journalDebits(
  AppDatabase db,
  String refType,
  String refId,
) async {
  final journal = await (db.select(db.journals)
        ..where((j) => j.refType.equals(refType) & j.refId.equals(refId)))
      .getSingle();
  final lines = await (db.select(db.journalLines)
        ..where((l) => l.journalId.equals(journal.id)))
      .get();
  return {for (final l in lines) l.accountCode: l.debit};
}

Future<int> customerPoints(AppDatabase db, String customerId) async {
  final c = await (db.select(db.customers)
        ..where((c) => c.id.equals(customerId)))
      .getSingle();
  return c.points;
}

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.memory();
  });

  tearDown(() async {
    await db.close();
  });

  group('poin atomik di dalam transaksi penjualan', () {
    test('jual 36000 ke pelanggan -> +3 poin, penjualan tercatat', () async {
      final (employeeId, kopiSusuId, _) = await seedMinimal(db);
      final customerId = await addCustomer(db, 'Budi');
      final saleId = await SaleService.recordSale(
        db,
        date: DateTime.now(),
        channel: 'dine-in',
        lines: [SaleLineInput(productId: kopiSusuId, qty: 2)],
        payments: [SalePaymentInput(method: 'tunai', amount: 36000)],
        employeeId: employeeId,
        customerId: customerId,
      );
      expect(await customerPoints(db, customerId), 3);
      final sale = await (db.select(db.sales)
            ..where((s) => s.id.equals(saleId)))
          .getSingle();
      expect(sale.total, 36000);
      // Outbox ikut mencatat update poin (sync tidak ketinggalan).
      final outbox = await (db.select(db.syncOutbox)
            ..where(
              (o) =>
                  o.table.equals('customers') &
                  o.rowId.equals(customerId),
            ))
          .get();
      expect(outbox, isNotEmpty);
    });

    test('rollback (bayar kurang -> throw) tidak meninggalkan poin',
        () async {
      final (employeeId, kopiSusuId, _) = await seedMinimal(db);
      final customerId = await addCustomer(db, 'Budi');
      await expectLater(
        SaleService.recordSale(
          db,
          date: DateTime.now(),
          channel: 'dine-in',
          lines: [SaleLineInput(productId: kopiSusuId, qty: 2)],
          payments: [SalePaymentInput(method: 'tunai', amount: 10000)],
          employeeId: employeeId,
          customerId: customerId,
        ),
        throwsA(isNotNull),
      );
      expect(await customerPoints(db, customerId), 0);
      expect(await db.select(db.sales).get(), isEmpty);
      // Tidak ada jurnal PENJUALAN (jurnal stock-in fixture tetap ada).
      final saleJournals = await (db.select(db.journals)
            ..where((j) => j.refType.equals('sale')))
          .get();
      expect(saleJournals, isEmpty);
    });

    test('tanpa pelanggan -> tidak ada poin, penjualan tetap jalan',
        () async {
      final (employeeId, kopiSusuId, _) = await seedMinimal(db);
      await SaleService.recordSale(
        db,
        date: DateTime.now(),
        channel: 'dine-in',
        lines: [SaleLineInput(productId: kopiSusuId, qty: 2)],
        payments: [SalePaymentInput(method: 'tunai', amount: 36000)],
        employeeId: employeeId,
      );
      expect(await db.select(db.customers).get(), isEmpty);
      expect((await db.select(db.sales).get()).length, 1);
    });

    test('accruePoints: false -> penjualan jalan tanpa poin', () async {
      final (employeeId, kopiSusuId, _) = await seedMinimal(db);
      final customerId = await addCustomer(db, 'Budi');
      await SaleService.recordSale(
        db,
        date: DateTime.now(),
        channel: 'dine-in',
        lines: [SaleLineInput(productId: kopiSusuId, qty: 2)],
        payments: [SalePaymentInput(method: 'tunai', amount: 36000)],
        employeeId: employeeId,
        customerId: customerId,
        accruePoints: false,
      );
      expect(await customerPoints(db, customerId), 0);
    });

    test('void membalik poin: 3 poin -> 0 setelah void', () async {
      final (employeeId, kopiSusuId, _) = await seedMinimal(db);
      final customerId = await addCustomer(db, 'Budi');
      final saleId = await SaleService.recordSale(
        db,
        date: DateTime.now(),
        channel: 'dine-in',
        lines: [SaleLineInput(productId: kopiSusuId, qty: 2)],
        payments: [SalePaymentInput(method: 'tunai', amount: 36000)],
        employeeId: employeeId,
        customerId: customerId,
      );
      expect(await customerPoints(db, customerId), 3);
      await SaleService.voidSale(db, saleId);
      expect(await customerPoints(db, customerId), 0);
    });
  });

  group('metode bayar transfer/debit -> akun 1010 Bank', () {
    test('transfer 36000 -> jurnal D 1010 (bukan 1020)', () async {
      final (employeeId, kopiSusuId, _) = await seedMinimal(db);
      final saleId = await SaleService.recordSale(
        db,
        date: DateTime.now(),
        channel: 'dine-in',
        lines: [SaleLineInput(productId: kopiSusuId, qty: 2)],
        payments: [SalePaymentInput(method: 'transfer', amount: 36000)],
        employeeId: employeeId,
      );
      final debits = await journalDebits(db, 'sale', saleId);
      expect(debits['1010'], 36000);
      expect(debits.containsKey('1020'), isFalse);
      expect(debits.containsKey('1000'), isFalse);
      final sale = await (db.select(db.sales)
            ..where((s) => s.id.equals(saleId)))
          .getSingle();
      expect(sale.paymentMethod, 'transfer');
    });

    test('debit 36000 -> jurnal D 1010', () async {
      final (employeeId, kopiSusuId, _) = await seedMinimal(db);
      final saleId = await SaleService.recordSale(
        db,
        date: DateTime.now(),
        channel: 'dine-in',
        lines: [SaleLineInput(productId: kopiSusuId, qty: 2)],
        payments: [SalePaymentInput(method: 'debit', amount: 36000)],
        employeeId: employeeId,
      );
      final debits = await journalDebits(db, 'sale', saleId);
      expect(debits['1010'], 36000);
      expect(debits.containsKey('1020'), isFalse);
    });

    test('QRIS 36000 tetap D 1020', () async {
      final (employeeId, kopiSusuId, _) = await seedMinimal(db);
      final saleId = await SaleService.recordSale(
        db,
        date: DateTime.now(),
        channel: 'dine-in',
        lines: [SaleLineInput(productId: kopiSusuId, qty: 2)],
        payments: [SalePaymentInput(method: 'qris', amount: 36000)],
        employeeId: employeeId,
      );
      final debits = await journalDebits(db, 'sale', saleId);
      expect(debits['1020'], 36000);
      expect(debits.containsKey('1010'), isFalse);
    });

    test('multi tunai 20000 + transfer 16000 -> D 1000 + D 1010',
        () async {
      final (employeeId, kopiSusuId, _) = await seedMinimal(db);
      final saleId = await SaleService.recordSale(
        db,
        date: DateTime.now(),
        channel: 'dine-in',
        lines: [SaleLineInput(productId: kopiSusuId, qty: 2)],
        payments: [
          SalePaymentInput(method: 'tunai', amount: 20000),
          SalePaymentInput(method: 'transfer', amount: 16000),
        ],
        employeeId: employeeId,
      );
      final debits = await journalDebits(db, 'sale', saleId);
      expect(debits['1000'], 20000);
      expect(debits['1010'], 16000);
      expect(debits.containsKey('1020'), isFalse);
      final sale = await (db.select(db.sales)
            ..where((s) => s.id.equals(saleId)))
          .getSingle();
      expect(sale.paymentMethod, 'multi');
    });

    test('transfer + debit digabung satu baris D 1010', () async {
      final (employeeId, kopiSusuId, _) = await seedMinimal(db);
      final saleId = await SaleService.recordSale(
        db,
        date: DateTime.now(),
        channel: 'dine-in',
        lines: [SaleLineInput(productId: kopiSusuId, qty: 2)],
        payments: [
          SalePaymentInput(method: 'transfer', amount: 20000),
          SalePaymentInput(method: 'debit', amount: 16000),
        ],
        employeeId: employeeId,
      );
      final journal = await (db.select(db.journals)
            ..where((j) => j.refType.equals('sale') & j.refId.equals(saleId)))
          .getSingle();
      final lines = await (db.select(db.journalLines)
            ..where((l) => l.journalId.equals(journal.id)))
          .get();
      final bankLines =
          lines.where((l) => l.accountCode == '1010').toList();
      expect(bankLines.length, 1);
      expect(bankLines.first.debit, 36000);
    });

    test('metode tidak dikenal -> throw', () async {
      final (employeeId, kopiSusuId, _) = await seedMinimal(db);
      await expectLater(
        SaleService.recordSale(
          db,
          date: DateTime.now(),
          channel: 'dine-in',
          lines: [SaleLineInput(productId: kopiSusuId, qty: 2)],
          payments: [SalePaymentInput(method: 'kartu-kredit', amount: 36000)],
          employeeId: employeeId,
        ),
        throwsArgumentError,
      );
    });
  });

  group('pemetaan tampil -> engine (cart.dart)', () {
    test('Debit -> debit, Transfer -> transfer, E-Wallet -> qris', () {
      expect(engineMethodFor('Debit'), 'debit');
      expect(engineMethodFor('Transfer'), 'transfer');
      expect(engineMethodFor('E-Wallet'), 'qris');
      expect(engineMethodFor('QRIS'), 'qris');
      expect(engineMethodFor('Tunai'), 'tunai');
      expect(engineMethodFor('Ojol'), 'ojol');
    });

    test('akun per metode: tunai 1000, transfer/debit 1010, qris/ojol 1020',
        () {
      expect(SaleService.accountForMethod('tunai'), '1000');
      expect(SaleService.accountForMethod('transfer'), '1010');
      expect(SaleService.accountForMethod('debit'), '1010');
      expect(SaleService.accountForMethod('qris'), '1020');
      expect(SaleService.accountForMethod('ojol'), '1020');
    });

    test('metode tampil tidak dikenal -> throw', () {
      expect(() => engineMethodFor('Debit/Transfer'), throwsArgumentError);
    });
  });
}
