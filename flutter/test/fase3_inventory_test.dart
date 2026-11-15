// Casirz ERP — Fase 3 (Modul B Bahan/BOM) tests.
// Service inventory + engine stock-in/wastage/opname + widget stok minus.
import 'package:casirz/core/accounting_service.dart';
import 'package:casirz/core/bom.dart';
import 'package:casirz/core/db.dart';
import 'package:casirz/features/inventory/inventory_service.dart';
import 'package:casirz/shared/widgets/stock_qty_text.dart';
import 'package:drift/drift.dart' hide Column, isNull, isNotNull;
import 'package:flutter/material.dart';
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
          stock: Value(100),
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

Future<Ingredient> ingredient(AppDatabase db, String id) async =>
    (await (db.select(db.ingredients)..where((i) => i.id.equals(id)))
        .getSingle());

/// Baris jurnal (akun -> debit/kredit) untuk satu event.
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

  group('stock-in: moving average + jurnal', () {
    test('1000g @150.000 + 500g @90.000 -> avg Rp160/g', () async {
      final deviceId = await db.deviceId();
      final now = nowMs();
      final id = newId();
      await db.into(db.ingredients).insert(
            IngredientsCompanion.insert(
              id: id,
              name: 'Kopi Test',
              unit: 'gram',
              updatedAt: now,
              deviceId: deviceId,
            ),
          );
      await AccountingService.recordStockIn(
        db,
        ingredientId: id,
        qty: 1000,
        totalCost: 150000,
      );
      expect((await ingredient(db, id)).avgCostMilli, 150000);
      await AccountingService.recordStockIn(
        db,
        ingredientId: id,
        qty: 500,
        totalCost: 90000,
      );
      final ing = await ingredient(db, id);
      expect(ing.stockQty, 1500);
      // (150000 + 90000) * 1000 / 1500 = 160000 mili = Rp160/g.
      expect(ing.avgCostMilli, 160000);
      expect(ing.totalValue, 240000);
    });

    test('stock-in tunai -> jurnal D 1100 / K 1000', () async {
      final f = await seedMinimal(db);
      final moveId = await AccountingService.recordStockIn(
        db,
        ingredientId: f.kopiId,
        qty: 1000,
        totalCost: 150000,
        payFrom: 'tunai',
      );
      final lines = await journalLines(db, 'stock-in', moveId);
      final debits = {for (final l in lines) l.accountCode: l.debit};
      final credits = {for (final l in lines) l.accountCode: l.credit};
      expect(debits['1100'], 150000);
      expect(credits['1000'], 150000);
    });

    test('stock-in bank -> jurnal D 1100 / K 1010', () async {
      final f = await seedMinimal(db);
      final moveId = await AccountingService.recordStockIn(
        db,
        ingredientId: f.kopiId,
        qty: 1000,
        totalCost: 150000,
        payFrom: 'bank',
      );
      final lines = await journalLines(db, 'stock-in', moveId);
      final credits = {for (final l in lines) l.accountCode: l.credit};
      expect(credits['1010'], 150000);
      expect(credits.containsKey('1000'), isFalse);
    });
  });

  group('wastage', () {
    test('susu tumpah 100ml -> stok -100, jurnal D 5210 Rp1.800',
        () async {
      final f = await seedMinimal(db);
      final amount = await AccountingService.recordWastage(
        db,
        ingredientId: f.susuId,
        qty: 100,
        reason: 'Susu tumpah',
      );
      expect(amount, 1800); // 100ml x Rp18/ml
      expect((await ingredient(db, f.susuId)).stockQty, 14900);
      final moves = await (db.select(db.stockMoves)
            ..where(
              (m) =>
                  m.ingredientId.equals(f.susuId) &
                  m.type.equals('wastage'),
            ))
          .get();
      expect(moves.length, 1);
      // Fase 4: moveId yang dikembalikan logWastage ADALAH id baris
      // stockMoves — jurnal wastage memakai refId = id baris itu, dan
      // outbox memakai id yang sama (quirk lama sudah diluruskan).
      expect(moves.first.id, moves.first.refId);
      final lines = await journalLines(db, 'wastage', moves.first.refId);
      final debits = {for (final l in lines) l.accountCode: l.debit};
      final credits = {for (final l in lines) l.accountCode: l.credit};
      expect(debits['5210'], 1800);
      expect(credits['1100'], 1800);
      expect(
        await InventoryService.wastageReason(db, moves.first.refId),
        'Susu tumpah',
      );
    });

    test('wastage qty 0 -> throw', () async {
      final f = await seedMinimal(db);
      await expectLater(
        AccountingService.recordWastage(
          db,
          ingredientId: f.susuId,
          qty: 0,
          reason: 'x',
        ),
        throwsArgumentError,
      );
    });
  });

  group('stok opname', () {
    test('susut 50g kopi -> stok menyesuaikan, jurnal D 5200 Rp7.500',
        () async {
      final f = await seedMinimal(db);
      final opnameId = await AccountingService.createOpnameDraft(
        db,
        employeeId: f.employeeId,
        actualByIngredient: {f.kopiId: 3950},
      );
      await AccountingService.postOpname(db, opnameId);
      expect((await ingredient(db, f.kopiId)).stockQty, 3950);
      final lines = await journalLines(db, 'opname', opnameId);
      final debits = {for (final l in lines) l.accountCode: l.debit};
      final credits = {for (final l in lines) l.accountCode: l.credit};
      expect(debits['5200'], 7500); // 50g x Rp150/g
      expect(credits['1100'], 7500);
      final opname = await (db.select(db.stockOpnames)
            ..where((o) => o.id.equals(opnameId)))
          .getSingle();
      expect(opname.status, 'posted');
    });

    test('surplus 100ml susu -> jurnal D 1100 / K 5200 Rp1.800', () async {
      final f = await seedMinimal(db);
      final opnameId = await AccountingService.createOpnameDraft(
        db,
        employeeId: f.employeeId,
        actualByIngredient: {f.susuId: 15100},
      );
      await AccountingService.postOpname(db, opnameId);
      expect((await ingredient(db, f.susuId)).stockQty, 15100);
      final lines = await journalLines(db, 'opname', opnameId);
      final debits = {for (final l in lines) l.accountCode: l.debit};
      final credits = {for (final l in lines) l.accountCode: l.credit};
      expect(debits['1100'], 1800);
      expect(credits['5200'], 1800);
    });

    test('opname tidak bisa diposting 2x', () async {
      final f = await seedMinimal(db);
      final opnameId = await AccountingService.createOpnameDraft(
        db,
        employeeId: f.employeeId,
        actualByIngredient: {f.kopiId: 3950},
      );
      await AccountingService.postOpname(db, opnameId);
      await expectLater(
        AccountingService.postOpname(db, opnameId),
        throwsStateError,
      );
      // Stok hanya menyesuaikan sekali.
      expect((await ingredient(db, f.kopiId)).stockQty, 3950);
    });

    test('baris draft bisa diedit; baris posted tidak bisa', () async {
      final f = await seedMinimal(db);
      final opnameId = await AccountingService.createOpnameDraft(
        db,
        employeeId: f.employeeId,
        actualByIngredient: {f.kopiId: 3950},
      );
      final line = await (db.select(db.stockOpnameLines)
            ..where((l) => l.opnameId.equals(opnameId)))
          .getSingle();
      expect(line.diffQty, -50);
      await InventoryService.updateOpnameLine(
        db,
        lineId: line.id,
        actualQty: 3900,
      );
      final updated = await (db.select(db.stockOpnameLines)
            ..where((l) => l.id.equals(line.id)))
          .getSingle();
      expect(updated.diffQty, -100);
      await AccountingService.postOpname(db, opnameId);
      await expectLater(
        InventoryService.updateOpnameLine(
          db,
          lineId: line.id,
          actualQty: 4000,
        ),
        throwsStateError,
      );
    });
  });

  group('CRUD bahan + BOM', () {
    test('tambah bahan baru stok 0, edit nama + ambang', () async {
      final id = await InventoryService.addIngredient(
        db,
        name: 'Matcha',
        unit: 'gram',
        lowStockAt: 100,
      );
      final ing = await ingredient(db, id);
      expect(ing.stockQty, 0);
      expect(ing.avgCostMilli, 0);
      await InventoryService.updateIngredient(
        db,
        ingredientId: id,
        name: 'Matcha Latte Bubuk',
        lowStockAt: 200,
      );
      final updated = await ingredient(db, id);
      expect(updated.name, 'Matcha Latte Bubuk');
      expect(updated.lowStockAt, 200);
    });

    test('hapus bahan yang dipakai resep -> ditolak dengan pesan jelas',
        () async {
      final f = await seedMinimal(db);
      await expectLater(
        InventoryService.deleteIngredient(db, f.kopiId),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('Kopi Susu Gula Aren'),
          ),
        ),
      );
      // Bahan tetap ada (tidak terhapus diam-diam).
      expect((await ingredient(db, f.kopiId)).isDeleted, 0);
    });

    test('hapus bahan yang tidak dipakai resep -> tombstone', () async {
      final id = await InventoryService.addIngredient(
        db,
        name: 'Bahan Nganggur',
        unit: 'pcs',
      );
      await InventoryService.deleteIngredient(db, id);
      expect((await ingredient(db, id)).isDeleted, 1);
    });

    test('satuan bahan yang dipakai resep tidak bisa diubah', () async {
      final f = await seedMinimal(db);
      await expectLater(
        InventoryService.updateIngredient(
          db,
          ingredientId: f.kopiId,
          unit: 'ml',
        ),
        throwsStateError,
      );
    });

    test('tambah baris resep ganda -> ditolak; ubah qty mengubah HPP',
        () async {
      final f = await seedMinimal(db);
      expect(await Bom.computeHPP(db, f.kopiSusuId, 1), 7360);
      await expectLater(
        InventoryService.addRecipeLine(
          db,
          productId: f.kopiSusuId,
          ingredientId: f.kopiId,
          qty: 10,
        ),
        throwsStateError,
      );
      // Tambah gula aren 25ml -> 50ml: HPP +1500.
      final lines = await InventoryService.recipeLinesForProduct(
        db,
        f.kopiSusuId,
      );
      final gulaLine = lines.firstWhere(
        (l) => l.ingredientId == f.gulaId,
      );
      await InventoryService.updateRecipeLineQty(
        db,
        lineId: gulaLine.lineId,
        qty: 50,
      );
      expect(await Bom.computeHPP(db, f.kopiSusuId, 1), 8860);
      // Hapus baris gula: HPP -3000 (50ml x Rp60).
      await InventoryService.removeRecipeLine(db, gulaLine.lineId);
      expect(await Bom.computeHPP(db, f.kopiSusuId, 1), 5860);
    });

    test('produk tanpa BOM: tanpa baris resep, HPP = cost', () async {
      final f = await seedMinimal(db);
      expect(
        await InventoryService.recipeLinesForProduct(db, f.airMineralId),
        isEmpty,
      );
      expect(await Bom.computeHPP(db, f.airMineralId, 1), 2500);
    });

    test('biaya baris BOM = qty x avgCost', () async {
      final f = await seedMinimal(db);
      final lines = await InventoryService.recipeLinesForProduct(
        db,
        f.kopiSusuId,
      );
      final kopiLine = lines.firstWhere(
        (l) => l.ingredientId == f.kopiId,
      );
      expect(kopiLine.lineCostRp, 2700); // 18g x Rp150
      expect(lines.fold<int>(0, (s, l) => s + l.lineCostRp), 7360);
    });
  });

  group('widget stok minus', () {
    testWidgets('stok minus: angka merah + badge "Stok Minus"',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                StockQtyText(-5, unit: 'gram'),
                StokMinusBadge(),
              ],
            ),
          ),
        ),
      );
      expect(find.text('Stok Minus'), findsOneWidget);
      final qtyText =
          tester.widget<Text>(find.text('-5 gram'));
      expect(qtyText.style?.color, Colors.red);
    });

    testWidgets('stok normal: tidak ada badge "Stok Minus"',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StockQtyText(100, unit: 'gram', lowStockAt: 50),
          ),
        ),
      );
      expect(find.text('Stok Minus'), findsNothing);
      expect(find.text('100 gram'), findsOneWidget);
    });
  });
}
