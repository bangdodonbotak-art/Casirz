// Casirz ERP — Fase 2 (Modul A Kasir+) tests.
// Logika kasir diuji di sini: kembalian, multi-payment, split bill,
// diskon (tidak boleh bikin total 0), modifier, rekonsiliasi shift,
// poin akrual, HPP estimasi di kasir, struk teks, split/merge order.
//
// Fixture minimal disalin polanya dari test/core_engine_test.dart
// (bahan masuk lewat recordStockIn supaya jurnal seimbang).
import 'package:casirz/core/accounting_service.dart';
import 'package:casirz/core/bom.dart';
import 'package:casirz/core/db.dart';
import 'package:casirz/core/printer/receipt_model.dart';
import 'package:casirz/core/printer/receipt_text.dart';
import 'package:casirz/core/sales_service.dart';
import 'package:casirz/features/pos/cart.dart';
import 'package:casirz/features/pos/customer_service.dart';
import 'package:casirz/features/pos/orders_service.dart';
import 'package:casirz/features/pos/shift_service.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:flutter_test/flutter_test.dart';

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
          stock: const Value(50),
          updatedAt: now,
          deviceId: deviceId,
        ),
      );
  return (employeeId, kopiSusuId, airMineralId);
}

void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase.memory();
  });

  tearDown(() async {
    await db.close();
  });

  group('kembalian + multi-payment', () {
    test('kembalian: bayar 50rb untuk 36rb -> kembali 14rb', () {
      final r = calcChange(paid: 50000, total: 36000);
      expect(r.change, 14000);
      expect(r.remaining, 0);
    });

    test('uang pas -> kembalian 0, sisa 0', () {
      final r = calcChange(paid: 36000, total: 36000);
      expect(r.change, 0);
      expect(r.remaining, 0);
    });

    test('bayar kurang -> sisa kurang, kembalian 0', () {
      final r = calcChange(paid: 20000, total: 36000);
      expect(r.change, 0);
      expect(r.remaining, 16000);
    });

    test('multi-payment tunai 20rb + QRIS 16rb = tagihan 36rb', () {
      final payments = [20000, 16000];
      final paid = payments.fold<int>(0, (s, p) => s + p);
      expect(paid, 36000);
      final r = calcChange(paid: paid, total: 36000);
      expect(r.change, 0);
      expect(r.remaining, 0);
    });
  });

  group('split bill', () {
    test('bagi rata 100rb / 3 orang = 33334 + 33333 + 33333', () {
      final shares = splitEvenly(100000, 3);
      expect(shares, [33334, 33333, 33333]);
      expect(shares.fold<int>(0, (s, v) => s + v), 100000);
    });

    test('bagi rata 36rb / 2 = 18rb + 18rb', () {
      expect(splitEvenly(36000, 2), [18000, 18000]);
    });

    test('bagi rata total ganjil: 99999 / 2 = 50000 + 49999', () {
      final shares = splitEvenly(99999, 2);
      expect(shares, [50000, 49999]);
      expect(shares.fold<int>(0, (s, v) => s + v), 99999);
    });

    test('split per item: jumlah kedua kelompok = total asli', () {
      final a = [
        CartLine(productId: 'p1', name: 'Kopi', basePrice: 18000, qty: 2),
      ];
      final b = [
        CartLine(productId: 'p2', name: 'Teh', basePrice: 8000, qty: 1),
      ];
      final split = splitByItems(a, b);
      expect(split.groupA, 36000);
      expect(split.groupB, 8000);
      expect(split.groupA + split.groupB, 44000);
    });
  });

  group('diskon + promo (total Rp0 ditolak)', () {
    test('diskon 100% di-clamp: total minimal Rp1', () {
      final lines = [
        CartLine(productId: 'p1', name: 'Kopi', basePrice: 18000, qty: 2),
      ];
      final t = computeTotals(lines: lines, promoPercent: 100);
      expect(t.discount, 35999); // subtotal 36000 - 1
      expect(t.total, 1);
      expect(t.total, greaterThan(0));
    });

    test('diskon manual melebihi subtotal di-clamp', () {
      final lines = [
        CartLine(productId: 'p1', name: 'Kopi', basePrice: 18000, qty: 1),
      ];
      final t = computeTotals(lines: lines, discountRp: 999999);
      expect(t.total, 1);
    });

    test('promo 10% dari 36rb = 3600', () {
      final lines = [
        CartLine(productId: 'p1', name: 'Kopi', basePrice: 18000, qty: 2),
      ];
      final t = computeTotals(lines: lines, promoPercent: 10);
      expect(t.discount, 3600);
      expect(t.total, 32400);
    });

    test('promo potongan 5000', () {
      final lines = [
        CartLine(productId: 'p1', name: 'Kopi', basePrice: 18000, qty: 2),
      ];
      final t = computeTotals(lines: lines, promoFixedRp: 5000);
      expect(t.discount, 5000);
      expect(t.total, 31000);
    });

    test('PPN 11% dihitung dari subtotal setelah diskon', () {
      final lines = [
        CartLine(productId: 'p1', name: 'Kopi', basePrice: 18000, qty: 2),
      ];
      final t = computeTotals(
        lines: lines,
        discountRp: 6000,
        ppnEnabled: true,
      );
      // (36000-6000) * 11% = 3300
      expect(t.tax, 3300);
      expect(t.total, 30000 + 3300);
    });

    test('service 5% + PB1 10% digabung', () {
      final lines = [
        CartLine(productId: 'p1', name: 'Kopi', basePrice: 20000, qty: 1),
      ];
      final t = computeTotals(lines: lines, serviceRate: 5, pb1Rate: 10);
      expect(t.serviceCharge, 3000);
      expect(t.total, 23000);
    });
  });

  group('modifier menambah harga', () {
    test('extra topping +3000: 18000 -> 21000', () {
      final line = CartLine(
        productId: 'p1',
        name: 'Kopi',
        basePrice: 18000,
        qty: 1,
        modifiers: const [CartModifier(name: 'Extra Topping', priceDelta: 3000)],
      );
      expect(line.unitPrice, 21000);
      expect(line.lineTotal, 21000);
    });

    test('modifier gratis (level gula) tidak mengubah harga', () {
      final line = CartLine(
        productId: 'p1',
        name: 'Kopi',
        basePrice: 18000,
        qty: 2,
        modifiers: const [CartModifier(name: 'Kurang Manis')],
      );
      expect(line.lineTotal, 36000);
    });

    test('modifier + qty: 2x (18000+3000) = 42000', () {
      final line = CartLine(
        productId: 'p1',
        name: 'Kopi',
        basePrice: 18000,
        qty: 2,
        modifiers: const [CartModifier(name: 'Extra Topping', priceDelta: 3000)],
      );
      expect(line.lineTotal, 42000);
    });
  });

  group('poin pelanggan', () {
    test('floor(total/10000): 36000 -> 3 poin', () {
      expect(pointsForTotal(36000), 3);
    });

    test('9999 -> 0 poin; 10000 -> 1 poin; 100000 -> 10 poin', () {
      expect(pointsForTotal(9999), 0);
      expect(pointsForTotal(10000), 1);
      expect(pointsForTotal(100000), 10);
    });

    test('akrual ke pelanggan: jual 54000 -> +5 poin tersimpan (atomik di recordSale, Fase 3)',
        () async {
      final (employeeId, kopiSusuId, _) = await seedMinimal(db);
      final customerId = await CustomerService.addCustomer(
        db,
        name: 'Budi',
        phone: '0812',
      );
      await SaleService.recordSale(
        db,
        date: DateTime.now(),
        channel: 'dine-in',
        lines: [SaleLineInput(productId: kopiSusuId, qty: 3)],
        payments: [SalePaymentInput(method: 'tunai', amount: 54000)],
        employeeId: employeeId,
        customerId: customerId,
      );
      final c = await (db.select(db.customers)
            ..where((c) => c.id.equals(customerId)))
          .getSingle();
      expect(c.points, 5);
    });
  });

  group('HPP estimasi tampil di kasir (dari Bom.computeHPP)', () {
    test('Kopi Susu Gula Aren = Rp7.360 (sama dengan oracle laporan)', () async {
      final (_, kopiSusuId, _) = await seedMinimal(db);
      final hpp = await Bom.computeHPP(db, kopiSusuId, 1);
      expect(hpp, 7360);
      final hpp2 = await Bom.computeHPP(db, kopiSusuId, 2);
      expect(hpp2, 14720);
    });

    test('Air Mineral tanpa BOM = products.cost Rp2.500', () async {
      final (_, _, airMineralId) = await seedMinimal(db);
      expect(await Bom.computeHPP(db, airMineralId, 1), 2500);
    });
  });

  group('struk teks 58/80mm', () {
    ReceiptModel sample(PaperWidth w) => ReceiptModel(
          storeName: 'Warkop Kekinian',
          saleCode: 'CSZ-20261115-0001',
          date: DateTime(2026, 11, 15, 19, 30),
          lines: const [
            ReceiptLine(name: 'Kopi Susu Gula Aren', qty: 2, price: 18000),
            ReceiptLine(name: 'Air Mineral', qty: 1, price: 5000),
          ],
          subtotal: 41000,
          discount: 0,
          tax: 0,
          serviceCharge: 0,
          ojolFee: 0,
          total: 41000,
          payments: const [
            ReceiptPayment(methodLabel: 'Tunai', amount: 50000),
          ],
          change: 9000,
          paperWidth: w,
          customerName: 'Budi',
          pointsEarned: 4,
          customerPointsTotal: 9,
        );

    test('80mm: tidak ada baris > 42 karakter', () {
      final text = formatReceiptText(sample(PaperWidth.mm80));
      for (final line in text.split('\n')) {
        expect(line.length, lessThanOrEqualTo(42));
      }
      expect(text, contains('Warkop Kekinian'));
      expect(text, contains('Rp41.000'));
      expect(text, contains('Rp9.000')); // kembalian
      expect(text, contains('Poin didapat: 4'));
    });

    test('58mm: tidak ada baris > 32 karakter', () {
      final text = formatReceiptText(sample(PaperWidth.mm58));
      for (final line in text.split('\n')) {
        expect(line.length, lessThanOrEqualTo(32));
      }
      expect(text, contains('CSZ-20261115-0001'));
    });
  });

  group('ojol: komisi + markup', () {
    test('komisi 20% dari 20000 = 4000; diterima 16000', () {
      final lines = [
        CartLine(productId: 'p1', name: 'Indomie', basePrice: 20000, qty: 1),
      ];
      final t = computeTotals(lines: lines, ojolFeePercent: 20);
      expect(t.ojolFee, 4000);
      expect(t.total, 20000);
      // Engine: (paid - change) + fee == total -> paid = total - fee
      expect(t.total - t.ojolFee, 16000);
    });

    test('markup 10%: harga 18000 -> 19800', () {
      final lines = [
        CartLine(productId: 'p1', name: 'Kopi', basePrice: 18000, qty: 1),
      ];
      final t = computeTotals(lines: lines, markupPercent: 10);
      expect(t.subtotal, 19800);
    });
  });

  group('shift & laci kas (rekonsiliasi)', () {
    test('tutup shift tanpa penjualan: harapan = float, selisih 0', () async {
      final (employeeId, _, _) = await seedMinimal(db);
      final shiftId = await ShiftService.openShift(
        db,
        openingFloat: 100000,
        employeeId: employeeId,
      );
      expect(await ShiftService.expectedCash(db, shiftId), 100000);
      final result = await ShiftService.closeShift(
        db,
        shiftId: shiftId,
        actualCash: 100000,
      );
      expect(result.expectedCash, 100000);
      expect(result.cashDiff, 0);
    });

    test('jual tunai 36rb + isi petty 10rb -> harapan 126rb; fisik 121rb -> selisih -5rb (D 5220)',
        () async {
      final (employeeId, kopiSusuId, _) = await seedMinimal(db);
      final shiftId = await ShiftService.openShift(
        db,
        openingFloat: 100000,
        employeeId: employeeId,
      );
      await SaleService.recordSale(
        db,
        date: DateTime.now(),
        channel: 'dine-in',
        lines: [SaleLineInput(productId: kopiSusuId, qty: 2)],
        payments: [SalePaymentInput(method: 'tunai', amount: 36000)],
        employeeId: employeeId,
        shiftId: shiftId,
      );
      await ShiftService.fillPetty(
        db,
        amount: 10000,
        employeeId: employeeId,
        shiftId: shiftId,
      );
      // Harapan: 100000 + 36000 - 10000 = 126000.
      expect(await ShiftService.expectedCash(db, shiftId), 126000);
      final result = await ShiftService.closeShift(
        db,
        shiftId: shiftId,
        actualCash: 121000,
      );
      expect(result.cashDiff, -5000);
      // Jurnal selisih tercatat: D 5220 5000.
      final journals = await (db.select(db.journals)
            ..where((j) => j.refType.equals('selisih-kas')))
          .get();
      expect(journals.length, 1);
      final lines = await (db.select(db.journalLines)
            ..where((l) => l.journalId.equals(journals.first.id)))
          .get();
      final d5220 = lines.where((l) => l.accountCode == '5220').single;
      expect(d5220.debit, 5000);
    });

    test('buka shift kedua saat masih open -> throw', () async {
      final (employeeId, _, _) = await seedMinimal(db);
      await ShiftService.openShift(
        db,
        openingFloat: 50000,
        employeeId: employeeId,
      );
      expect(
        () => ShiftService.openShift(
          db,
          openingFloat: 50000,
          employeeId: employeeId,
        ),
        throwsStateError,
      );
    });

    test('belanja petty wajib ada alasan', () async {
      final (employeeId, _, _) = await seedMinimal(db);
      final shiftId = await ShiftService.openShift(
        db,
        openingFloat: 100000,
        employeeId: employeeId,
      );
      await ShiftService.fillPetty(
        db,
        amount: 20000,
        employeeId: employeeId,
        shiftId: shiftId,
      );
      expect(
        () => ShiftService.spendPetty(
          db,
          amount: 5000,
          note: '   ',
          accountCode: '5170',
          employeeId: employeeId,
          shiftId: shiftId,
        ),
        throwsArgumentError,
      );
      final id = await ShiftService.spendPetty(
        db,
        amount: 5000,
        note: 'Beli sabun cuci piring',
        accountCode: '5150',
        employeeId: employeeId,
        shiftId: shiftId,
      );
      expect(id, isNotEmpty);
      // Jurnal: D 5150 5000 / K 1030 5000.
      final journals = await (db.select(db.journals)
            ..where((j) => j.refType.equals('petty-belanja')))
          .get();
      expect(journals.length, 1);
    });
  });

  group('order: split per item + merge', () {
    test('split: pindah 1 dari 2 item -> dua order, total tetap', () async {
      final (_, kopiSusuId, airMineralId) = await seedMinimal(db);
      final orderId = await OrderService.createOrder(
        db,
        channel: 'dine-in',
      );
      final line1 = await OrderService.addLine(
        db,
        orderId: orderId,
        productId: kopiSusuId,
        qty: 2,
      );
      await OrderService.addLine(
        db,
        orderId: orderId,
        productId: airMineralId,
        qty: 1,
      );
      expect(await OrderService.orderTotal(db, orderId), 41000);
      final newId = await OrderService.splitOrderByItems(
        db,
        orderId: orderId,
        lineIds: [line1],
      );
      expect(await OrderService.orderTotal(db, orderId), 5000);
      expect(await OrderService.orderTotal(db, newId), 36000);
      expect(
        await OrderService.orderTotal(db, orderId) +
            await OrderService.orderTotal(db, newId),
        41000,
      );
      // Merge kembali -> satu order 41000, order baru void.
      await OrderService.mergeOrders(
        db,
        intoOrderId: orderId,
        fromOrderId: newId,
      );
      expect(await OrderService.orderTotal(db, orderId), 41000);
      final merged = await (db.select(db.orders)
            ..where((o) => o.id.equals(newId)))
          .getSingle();
      expect(merged.status, 'void');
    });

    test('split SEMUA item ditolak', () async {
      final (_, kopiSusuId, _) = await seedMinimal(db);
      final orderId = await OrderService.createOrder(
        db,
        channel: 'dine-in',
      );
      final line1 = await OrderService.addLine(
        db,
        orderId: orderId,
        productId: kopiSusuId,
        qty: 1,
      );
      expect(
        () => OrderService.splitOrderByItems(
          db,
          orderId: orderId,
          lineIds: [line1],
        ),
        throwsArgumentError,
      );
    });

    test('meja: tambah meja duplikat ditolak; order buat meja terisi',
        () async {
      final tableId = await OrderService.addTable(db, 'Meja 1');
      expect(
        () => OrderService.addTable(db, 'Meja 1'),
        throwsArgumentError,
      );
      final orderId = await OrderService.createOrder(
        db,
        tableId: tableId,
        channel: 'dine-in',
      );
      final table = await (db.select(db.shopTables)
            ..where((t) => t.id.equals(tableId)))
          .getSingle();
      expect(table.status, 'terisi');
      await OrderService.voidOrder(db, orderId);
      final table2 = await (db.select(db.shopTables)
            ..where((t) => t.id.equals(tableId)))
          .getSingle();
      expect(table2.status, 'kosong');
    });
  });
}
