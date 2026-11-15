// Casirz ERP — Fase 6 (Modul E Owner Command Center) tests.
// Bagian A: pemulihan PIN owner + reset data total + atribusi penjualan
// & shift ke sesi login (employeeId null = "Tanpa login").
// Bagian B: ringkasan hari ini (laba bersih real prorata), BEP,
// jam sibuk, matriks menu, alert stok minus, guard non-Owner.
//
// ANGKA EKSPEKTASI (dihitung dari seed + Reports, bukan karangan):
// - Seed: omzet 7 hari Rp574.000, HPP Rp210.360, laba kotor Rp363.640;
//   modal Rp60.000.000; OPEX bulanan = listrik 1.000.000 + air 200.000
//   + internet 500.000 + gaji 2 kasir @1.500.000 = Rp4.700.000.
// - Prorata harian: OPEX 4.700.000/30 = Rp156.667; penyusutan
//   166.667/30 = Rp5.556; amortisasi sewa 2.500.000/30 = Rp83.333.
// - 2 penjualan hari ini (2x Kopi Susu 36.000 + 1x Indomie Telur
//   18.000): omzet Rp54.000, HPP Rp19.720, laba kotor Rp34.280,
//   laba bersih real = 34.280 − 156.667 − 5.556 − 83.333 = Rp−211.276.
// - BEP seed: 363.640 / 60.000.000 = 0,606% (data 7 hari < 30 hari ->
//   estimasi "belum cukup data").
// - Top-selling seed: Kopi Susu 11, Es Kopi Hitam 5, Es Teh Tubruk 5.
// - Margin seed: Indomie Spesial 15.000, Indomie Telur 13.000,
//   Roti Bakar 11.200, Kopi Susu 10.640, Susu Cokelat 9.200.
import 'dart:ui';

import 'package:casirz/app.dart';
import 'package:casirz/core/db.dart';
import 'package:casirz/core/sales_service.dart';
import 'package:casirz/core/seed.dart';
import 'package:casirz/features/dashboard/dashboard_service.dart';
import 'package:casirz/features/pos/shift_service.dart';
import 'package:casirz/features/staff/auth.dart';
import 'package:casirz/features/staff/staff_service.dart';
import 'package:drift/drift.dart' hide Column, isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<String> productIdByName(AppDatabase db, String name) async {
  final p = await (db.select(db.products)
        ..where((x) => x.name.equals(name)))
      .getSingle();
  return p.id;
}

Future<String> employeeIdByRole(AppDatabase db, String role) async {
  final e = await (db.select(db.employees)
        ..where((x) => x.role.equals(role))
        ..orderBy([(x) => OrderingTerm.asc(x.name)])
        ..limit(1))
      .getSingle();
  return e.id;
}

Future<String> sell(
  AppDatabase db, {
  required String productName,
  required int qty,
  required DateTime date,
  String? employeeId,
}) async {
  final productId = await productIdByName(db, productName);
  final product = await (db.select(db.products)
        ..where((p) => p.id.equals(productId)))
      .getSingle();
  return SaleService.recordSale(
    db,
    date: date,
    channel: 'dine-in',
    lines: [SaleLineInput(productId: productId, qty: qty)],
    payments: [
      SalePaymentInput(method: 'tunai', amount: product.price * qty),
    ],
    employeeId: employeeId,
  );
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  late AppDatabase db;
  var dbClosed = false;

  setUp(() {
    db = AppDatabase.memory();
    dbClosed = false;
  });

  tearDown(() async {
    if (!dbClosed) {
      await db.close();
    }
  });

  Future<void> closeDbInBody() async {
    await db.close();
    dbClosed = true;
  }

  DateTime todayAt(int hour, [int minute = 0]) {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day, hour, minute);
  }

  group('Bagian A — pemulihan PIN oleh owner yang login', () {
    test('owner atur ulang PIN kasir -> kasir masuk dengan PIN baru, PIN lama ditolak',
        () async {
      final auth = AuthService();
      final ownerId = await StaffService.createEmployee(
        db,
        name: 'Owner',
        role: 'owner',
      );
      final kasirId = await StaffService.createEmployee(
        db,
        name: 'Kasir 1',
        role: 'kasir',
      );
      await auth.setPin(db, ownerId, '1234');
      await auth.setPin(db, kasirId, '1111');
      expect(await auth.verifyPin(db, kasirId, '1111'), isTrue);
      // Owner yang sedang login mengatur ulang PIN kasir.
      await auth.setPin(db, kasirId, '2222');
      expect(await auth.verifyPin(db, kasirId, '2222'), isTrue);
      expect(await auth.verifyPin(db, kasirId, '1111'), isFalse);
      // PIN owner sendiri tidak berubah.
      expect(await auth.verifyPin(db, ownerId, '1234'), isTrue);
    });

    test('reset data total: semua data hilang, bagan akun + deviceId tetap',
        () async {
      await SeedDemo.run(db);
      final deviceIdBefore = await db.deviceId();
      expect((await db.select(db.sales).get()).length, 15);
      expect((await db.select(db.employees).get()).length, 3);
      await db.resetAllData();
      expect((await db.select(db.sales).get()).isEmpty, isTrue);
      expect((await db.select(db.employees).get()).isEmpty, isTrue);
      expect((await db.select(db.ingredients).get()).isEmpty, isTrue);
      expect(await db.getSetting('demoSeeded'), isNull);
      expect(await db.deviceId(), deviceIdBefore);
      // Bagan akun (seed onCreate) dipertahankan: 30 akun.
      expect((await db.select(db.accounts).get()).length, 30);
    });
  });

  group('Bagian A — atribusi penjualan & shift ke sesi login', () {
    test('penjualan tercatat atas employeeId sesi login', () async {
      await SeedDemo.run(db);
      final kasirId = await employeeIdByRole(db, 'kasir');
      final saleId = await sell(
        db,
        productName: 'Kopi Susu Gula Aren',
        qty: 1,
        date: todayAt(10),
        employeeId: kasirId,
      );
      final sale = await (db.select(db.sales)
            ..where((s) => s.id.equals(saleId)))
          .getSingle();
      expect(sale.employeeId, kasirId);
    });

    test('tanpa sesi login -> employeeId null (Tanpa login)', () async {
      await SeedDemo.run(db);
      final saleId = await sell(
        db,
        productName: 'Kopi Susu Gula Aren',
        qty: 1,
        date: todayAt(10),
      );
      final sale = await (db.select(db.sales)
            ..where((s) => s.id.equals(saleId)))
          .getSingle();
      expect(sale.employeeId, isNull);
    });

    test('shift dibuka atas employeeId sesi login; tanpa sesi -> null',
        () async {
      await SeedDemo.run(db);
      final kasirId = await employeeIdByRole(db, 'kasir');
      final shiftId = await ShiftService.openShift(
        db,
        openingFloat: 100000,
        employeeId: kasirId,
      );
      final shift = await (db.select(db.shifts)
            ..where((s) => s.id.equals(shiftId)))
          .getSingle();
      expect(shift.employeeId, kasirId);
      await ShiftService.closeShift(
        db,
        shiftId: shiftId,
        actualCash: 100000,
      );
      final shiftId2 = await ShiftService.openShift(
        db,
        openingFloat: 0,
      );
      final shift2 = await (db.select(db.shifts)
            ..where((s) => s.id.equals(shiftId2)))
          .getSingle();
      expect(shift2.employeeId, isNull);
    });

    test('employeeId tidak dikenal tetap ditolak', () async {
      await SeedDemo.run(db);
      await expectLater(
        () => sell(
          db,
          productName: 'Kopi Susu Gula Aren',
          qty: 1,
          date: todayAt(10),
          employeeId: 'tidak-ada',
        ),
        throwsArgumentError,
      );
      await expectLater(
        () => ShiftService.openShift(
          db,
          openingFloat: 0,
          employeeId: 'tidak-ada',
        ),
        throwsArgumentError,
      );
    });
  });

  group('Bagian B — ringkasan hari ini (laba bersih real)', () {
    test('seed + 2 penjualan hari ini: omzet 54.000, laba real -211.276',
        () async {
      await SeedDemo.run(db);
      final kasirId = await employeeIdByRole(db, 'kasir');
      await sell(
        db,
        productName: 'Kopi Susu Gula Aren',
        qty: 2,
        date: todayAt(10),
        employeeId: kasirId,
      );
      await sell(
        db,
        productName: 'Indomie Goreng Telur',
        qty: 1,
        date: todayAt(11),
        employeeId: kasirId,
      );
      final s = await DashboardService.todaySummary(db);
      expect(s.revenue, 54000);
      expect(s.netRevenue, 54000);
      expect(s.hpp, 19720);
      expect(s.grossProfit, 34280);
      expect(s.opexDaily, 156667);
      expect(s.depreciationDaily, 5556);
      expect(s.rentDaily, 83333);
      expect(s.netProfitReal, -211276);
      expect(s.transactions, 2);
      expect(s.avgPerTransaction, 27000);
    });

    test('tanpa penjualan hari ini: omzet 0, transaksi 0, laba real negatif prorata',
        () async {
      await SeedDemo.run(db);
      final s = await DashboardService.todaySummary(db);
      expect(s.revenue, 0);
      expect(s.transactions, 0);
      expect(s.avgPerTransaction, 0);
      // Laba real = 0 - 0 - 156.667 - 5.556 - 83.333.
      expect(s.netProfitReal, -245556);
    });
  });

  group('Bagian B — BEP vs modal awal', () {
    test('seed: modal 60jt, laba kumulatif 363.640, 0,606%, belum cukup data',
        () async {
      await SeedDemo.run(db);
      final bep = await DashboardService.bepProgress(db);
      expect(bep.capital, 60000000);
      expect(bep.cumulativeProfit, 363640);
      expect(bep.percent, closeTo(0.606, 0.001));
      expect(bep.hasEnoughData, isFalse);
      expect(bep.daysOfData, lessThan(30));
      expect(bep.estimatedDate, isNull);
    });

    test('tanpa data: modal 0, persen 0, tanpa estimasi', () async {
      final bep = await DashboardService.bepProgress(db);
      expect(bep.capital, 0);
      expect(bep.cumulativeProfit, 0);
      expect(bep.percent, 0);
      expect(bep.hasEnoughData, isFalse);
      expect(bep.estimatedDate, isNull);
    });
  });

  group('Bagian B — chart jam sibuk', () {
    test('3 penjualan jam 09, 2 jam 19 -> puncak 09', () async {
      await SeedDemo.run(db);
      final kasirId = await employeeIdByRole(db, 'kasir');
      for (var i = 0; i < 3; i++) {
        await sell(
          db,
          productName: 'Kopi Susu Gula Aren',
          qty: 1,
          date: todayAt(9, 10 + i),
          employeeId: kasirId,
        );
      }
      for (var i = 0; i < 2; i++) {
        await sell(
          db,
          productName: 'Es Teh Tubruk',
          qty: 1,
          date: todayAt(19, 5 + i),
          employeeId: kasirId,
        );
      }
      final h = await DashboardService.hourlySales(db);
      expect(h.counts[9], 3);
      expect(h.counts[19], 2);
      expect(h.peakHour, 9);
      expect(h.total, 5);
      expect(h.revenue[9], 3 * 18000);
      expect(h.revenue[19], 2 * 8000);
    });

    test('belum ada penjualan hari ini -> grafik kosong yang jujur',
        () async {
      await SeedDemo.run(db);
      final h = await DashboardService.hourlySales(db);
      expect(h.total, 0);
      expect(h.peakHour, isNull);
      expect(h.counts, List<int>.filled(24, 0));
    });
  });

  group('Bagian B — matriks menu', () {
    test('top-selling seed: Kopi Susu 11, lalu 5, 5', () async {
      await SeedDemo.run(db);
      final m = await DashboardService.menuMatrix(db);
      expect(m.topSelling.length, 5);
      expect(m.topSelling[0].name, 'Kopi Susu Gula Aren');
      expect(m.topSelling[0].qtySold, 11);
      expect(m.topSelling[1].qtySold, 5);
      expect(m.topSelling[2].qtySold, 5);
      expect(m.topSelling[1].name, 'Es Kopi Hitam');
      expect(m.topSelling[2].name, 'Es Teh Tubruk');
    });

    test('margin tertinggi seed: Spesial 15.000 ... Susu Cokelat 9.200',
        () async {
      await SeedDemo.run(db);
      final m = await DashboardService.menuMatrix(db);
      final names = m.topMargin.map((e) => e.name).toList();
      expect(names, [
        'Indomie Goreng Spesial',
        'Indomie Goreng Telur',
        'Roti Bakar Meses',
        'Kopi Susu Gula Aren',
        'Susu Cokelat Meses',
      ]);
      expect(m.topMargin.map((e) => e.marginPerUnit).toList(), [
        15000,
        13000,
        11200,
        10640,
        9200,
      ]);
    });
  });

  group('Bagian B — alert stok bahan', () {
    test('seed: tidak ada alert; jual 300 Kopi Susu -> bahan minus muncul',
        () async {
      await SeedDemo.run(db);
      expect(await DashboardService.stockAlerts(db), isEmpty);
      final kasirId = await employeeIdByRole(db, 'kasir');
      await sell(
        db,
        productName: 'Kopi Susu Gula Aren',
        qty: 300,
        date: todayAt(10),
        employeeId: kasirId,
      );
      final alerts = await DashboardService.stockAlerts(db);
      expect(alerts.isNotEmpty, isTrue);
      expect(alerts.every((a) => a.isMinus), isTrue);
      final names = alerts.map((a) => a.ingredient.name).toList();
      expect(names, contains('Biji Kopi House Blend'));
      expect(names, contains('Susu UHT Full Cream'));
      expect(names, contains('Gula Aren Cair'));
      // Stok benar-benar minus (bukan di-clamp 0).
      final kopi = alerts
          .firstWhere((a) => a.ingredient.name == 'Biji Kopi House Blend');
      expect(kopi.ingredient.stockQty, lessThan(0));
    });

    test('bahan menipis (<= lowStockAt) muncul setelah bahan minus',
        () async {
      await SeedDemo.run(db);
      // Teh Tubruk: stok seed 2000 - 70 terpakai = 1930; ambang 2500.
      final teh = await (db.select(db.ingredients)
            ..where((i) => i.name.equals('Teh Tubruk')))
          .getSingle();
      await (db.update(db.ingredients)
            ..where((i) => i.id.equals(teh.id)))
          .write(IngredientsCompanion(lowStockAt: const Value(2500.0)));
      final kasirId = await employeeIdByRole(db, 'kasir');
      await sell(
        db,
        productName: 'Kopi Susu Gula Aren',
        qty: 300,
        date: todayAt(10),
        employeeId: kasirId,
      );
      final alerts = await DashboardService.stockAlerts(db);
      final low = alerts.where((a) => !a.isMinus).toList();
      expect(low.map((a) => a.ingredient.name), contains('Teh Tubruk'));
      // Semua minus di atas semua menipis.
      final firstLow = alerts.indexWhere((a) => !a.isMinus);
      expect(
        alerts.sublist(0, firstLow).every((a) => a.isMinus),
        isTrue,
      );
    });
  });

  group('Bagian B — staf hari ini', () {
    test('check-in hari ini tampil + total jam; yang belum absen tampil belum check-in',
        () async {
      await SeedDemo.run(db);
      final kasirId = await employeeIdByRole(db, 'kasir');
      final auth = AuthService();
      await auth.setPin(db, kasirId, '1111');
      await StaffService.clockIn(
        db,
        employeeId: kasirId,
        pin: '1111',
        now: todayAt(8, 0),
      );
      await StaffService.clockOut(
        db,
        employeeId: kasirId,
        pin: '1111',
        now: todayAt(17, 0),
      );
      final staff = await DashboardService.staffToday(db);
      expect(staff.length, 3);
      final kasir = staff.firstWhere((s) => s.employee.id == kasirId);
      expect(kasir.checkedIn, isTrue);
      expect(kasir.workMinutes, 540);
      final others = staff.where((s) => s.employee.id != kasirId);
      expect(others.every((s) => !s.checkedIn), isTrue);
      expect(others.every((s) => s.workMinutes == 0), isTrue);
    });
  });

  group('Bagian B — guard Command Center (RBAC)', () {
    test('hanya Owner boleh buka Command Center', () {
      expect(StaffRole.owner.canAccess(MenuId.dashboard), isTrue);
      expect(StaffRole.manager.canAccess(MenuId.dashboard), isFalse);
      expect(StaffRole.kasir.canAccess(MenuId.dashboard), isFalse);
      expect(
        MenuId.dashboard.lockedReason(StaffRole.kasir),
        contains('hanya untuk Owner'),
      );
    });
  });

  group('widget: lock screen + Command Center', () {
    void setTallScreen(WidgetTester tester) {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    Future<void> tapPin(WidgetTester tester, String pin) async {
      for (final ch in pin.split('')) {
        await tester.tap(find.text(ch).first);
        await tester.pump();
      }
    }

    Future<void> loginAs(
      WidgetTester tester,
      String name,
      String pin,
    ) async {
      await tester.tap(find.text(name).first);
      await tester.pump();
      await tapPin(tester, pin);
      await tester.tap(find.text('Masuk'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
    }

    testWidgets('lock screen menampilkan teks pemulihan PIN', (tester) async {
      setTallScreen(tester);
      final auth = AuthService();
      final ownerId = await StaffService.createEmployee(
        db,
        name: 'Owner',
        role: 'owner',
      );
      await auth.setPin(db, ownerId, '1234');
      await tester.pumpWidget(CasirzApp(db: db));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Masuk dengan PIN'), findsOneWidget);
      expect(
        find.textContaining('Lupa PIN? Minta owner'),
        findsOneWidget,
      );
      expect(
        find.textContaining('Reset Data'),
        findsOneWidget,
      );
      await closeDbInBody();
    });

    testWidgets('owner: Lainnya -> Command Center membuka dashboard',
        (tester) async {
      // Viewport super-tinggi supaya SEMUA section dashboard ter-render
      // tanpa scroll (ListView malas-render section di bawah lipatan).
      tester.view.physicalSize = const Size(800, 5000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await SeedDemo.run(db);
      final auth = AuthService();
      final ownerId = await employeeIdByRole(db, 'owner');
      await auth.setPin(db, ownerId, '1234');
      // 3 penjualan hari ini jam 09:00 supaya chart jam sibuk ter-render
      // dengan data nyata (bukan cabang kosong).
      final kasirId = await employeeIdByRole(db, 'kasir');
      for (var i = 0; i < 3; i++) {
        await sell(
          db,
          productName: 'Kopi Susu Gula Aren',
          qty: 1,
          date: todayAt(9, 10 + i),
          employeeId: kasirId,
        );
      }
      await tester.pumpWidget(CasirzApp(db: db));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await loginAs(tester, 'Owner', '1234');
      expect(find.text('Kasir'), findsWidgets);
      await tester.tap(find.text('Lainnya').first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Command Center'), findsOneWidget);
      await tester.tap(find.text('Command Center'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Omzet Hari Ini'), findsOneWidget);
      expect(find.text('Laba Bersih Real Hari Ini'), findsOneWidget);
      expect(find.text('Balik Modal (BEP)'), findsOneWidget);
      expect(find.text('Jam Sibuk Hari Ini'), findsOneWidget);
      expect(find.textContaining('Jam tersibuk: 09:00'), findsOneWidget);
      expect(find.text('Top-Selling (qty terbanyak)'), findsOneWidget);
      expect(find.text('Margin Tertinggi (per unit)'), findsOneWidget);
      expect(find.text('Alert Stok Bahan'), findsOneWidget);
      expect(find.text('Staf Hari Ini'), findsOneWidget);
      await closeDbInBody();
    });

    testWidgets('DB kosong: Command Center tampil, grafik kosong yang jujur',
        (tester) async {
      tester.view.physicalSize = const Size(800, 5000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(CasirzApp(db: db));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Kasir'), findsWidgets);
      await tester.tap(find.text('Lainnya').first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(find.text('Command Center'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Omzet Hari Ini'), findsOneWidget);
      expect(find.text('Belum ada penjualan hari ini.'), findsOneWidget);
      expect(find.text('Belum ada karyawan aktif.'), findsOneWidget);
      await closeDbInBody();
    });

    testWidgets('kasir: Command Center terkunci di Lainnya',
        (tester) async {
      setTallScreen(tester);
      final auth = AuthService();
      final ownerId = await StaffService.createEmployee(
        db,
        name: 'Owner',
        role: 'owner',
      );
      await auth.setPin(db, ownerId, '1234');
      final kasirId = await StaffService.createEmployee(
        db,
        name: 'Kasir 1',
        role: 'kasir',
      );
      await auth.setPin(db, kasirId, '5678');
      await tester.pumpWidget(CasirzApp(db: db));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await loginAs(tester, 'Kasir 1', '5678');
      await tester.tap(find.text('Lainnya').first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Command Center'), findsOneWidget);
      await tester.tap(find.text('Command Center'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Menu Command Center Terkunci'), findsOneWidget);
      expect(find.textContaining('hanya untuk Owner'), findsOneWidget);
      await closeDbInBody();
    });
  });
}
