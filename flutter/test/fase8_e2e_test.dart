// Verifikasi akhir Fase 8 — alur kritis end-to-end + migrasi skema v1->v4
// + badge offline. Angka ekspektasi dihitung dari oracle seed
// (BLUEPRINT-FLUTTER.md §10.5) + transaksi yang dibuat di test ini.
//
// Oracle seed (15 transaksi, 7 hari):
//   omzet Rp574.000, HPP Rp210.360, laba kotor Rp363.640.
//   Kas tunai seed Rp288.000, QRIS/ojol (1020) Rp286.000,
//   Bank (1010) Rp17.000.000, 1100 Rp2.797.140, 1110 Rp242.500.
//   Kopi seed tersisa 3.694g, Air Mineral 97 pcs.
//
// Transaksi test ini (hari ini, setelah seed):
//   A: 2x Kopi Susu Gula Aren tunai            Rp36.000, HPP Rp14.720
//   B: 1x Air Mineral QRIS                     Rp 5.000, HPP Rp 2.500
//   Split: order 1x Kopi Susu + 1x Es Teh, dipisah, dibayar tunai
//          Rp18.000 + Rp8.000, HPP Rp7.360 + Rp3.200
//   Shift: float Rp100.000, tunai masuk Rp62.000 -> harapan Rp162.000
//   Stock-in kopi 1.000g Rp150.000 tunai (avg tetap Rp150/g)
//   Opname kopi susut 100g -> D5200/K1100 Rp15.000
//   Beban listrik Rp1.000.000 (bank) + gaji Kasir 1 Rp1.500.000 (bank)
//
// Laporan yang diharapkan (rentang 30 hari, semua jurnal masuk):
//   Laba Rugi: omzet Rp641.000, HPP Rp238.140, laba kotor Rp402.860,
//     OPEX Rp2.500.000, selisih stok Rp15.000, laba bersih -Rp2.112.140.
//   Neraca: kas 200.000, bank 14.500.000, qris 291.000,
//     persediaan 3.146.860 (1100: 2.906.860 + 1110: 240.000),
//     total aktiva 58.137.860, modal 60.000.000, laba ditahan 250.000,
//     selisih HARUS 0.
//   Arus Kas: operasi -2.009.000, investasi 0, pendanaan 17.000.000,
//     perubahan bersih 14.991.000, saldo awal 0, saldo akhir 14.991.000.
import 'dart:io';

import 'package:casirz/app.dart';
import 'package:casirz/core/accounting_service.dart';
import 'package:casirz/core/backup.dart';
import 'package:casirz/core/db.dart';
import 'package:casirz/core/reports.dart';
import 'package:casirz/core/sales_service.dart';
import 'package:casirz/core/seed.dart';
import 'package:casirz/core/supabase_config.dart';
import 'package:casirz/core/sync.dart';
import 'package:casirz/core/sync_engine.dart';
import 'package:casirz/features/pos/orders_service.dart';
import 'package:casirz/features/pos/shift_service.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite3;

Future<String> _productId(AppDatabase db, String name) async {
  final row = await (db.select(db.products)
        ..where((p) => p.name.equals(name)))
      .getSingle();
  return row.id;
}

Future<String> _ingredientId(AppDatabase db, String name) async {
  final row = await (db.select(db.ingredients)
        ..where((i) => i.name.equals(name)))
      .getSingle();
  return row.id;
}

Future<double> _ingredientStock(AppDatabase db, String name) async {
  final row = await (db.select(db.ingredients)
        ..where((i) => i.name.equals(name)))
      .getSingle();
  return row.stockQty;
}

Future<int> _ingredientAvgMilli(AppDatabase db, String name) async {
  final row = await (db.select(db.ingredients)
        ..where((i) => i.name.equals(name)))
      .getSingle();
  return row.avgCostMilli;
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  group('Fase 8 — alur kritis end-to-end', () {
    test('seed -> shift -> jual -> split -> tutup -> stock-in -> '
        'opname -> beban -> gaji -> laporan -> backup/restore', () async {
      final db = AppDatabase.memory();
      final now = DateTime.now();
      final from = now.subtract(const Duration(days: 30));
      final to = now.add(const Duration(hours: 1));

      // ---- 1. Seed demo (oracle BLUEPRINT §10.5).
      await SeedDemo.run(db);
      expect(await SeedDemo.isSeeded(db), isTrue);
      var pl = await Reports.profitLoss(db, from, to);
      expect(pl.grossRevenue, 574000, reason: 'omzet seed');
      expect(pl.hpp, 210360, reason: 'HPP seed');
      expect(pl.grossProfit, 363640, reason: 'laba kotor seed');
      var bs = await Reports.balanceSheet(db, now);
      expect(bs.difference, 0, reason: 'neraca seed selisih 0');
      expect((await db.select(db.sales).get()).length, 15);
      expect(await _ingredientStock(db, 'Biji Kopi House Blend'), 3694.0);
      final airMineralId = await _productId(db, 'Air Mineral');
      final airMineral = await (db.select(db.products)
            ..where((p) => p.id.equals(airMineralId)))
          .getSingle();
      expect(airMineral.stock, 97, reason: 'Air Mineral seed 100 - 3');

      // ---- 2. Buka shift, float Rp100.000.
      final shiftId = await ShiftService.openShift(
        db,
        openingFloat: 100000,
      );
      expect(await ShiftService.activeShift(db), isNotNull);

      // ---- 3a. Jual A: 2x Kopi Susu Gula Aren tunai (HPP 2 x 7.360).
      final kopiId = await _productId(db, 'Kopi Susu Gula Aren');
      final saleA = await SaleService.recordSale(
        db,
        date: now,
        channel: 'dine-in',
        lines: [SaleLineInput(productId: kopiId, qty: 2)],
        payments: [const SalePaymentInput(method: 'tunai', amount: 36000)],
        shiftId: shiftId,
      );
      final linesA = await (db.select(db.saleLines)
            ..where((l) => l.saleId.equals(saleA)))
          .get();
      expect(linesA.single.hppPerUnit, 7360);
      expect(await _ingredientStock(db, 'Biji Kopi House Blend'), 3658.0);
      expect(await _ingredientStock(db, 'Susu UHT Full Cream'), 12590.0);

      // ---- 3b. Jual B: 1x Air Mineral QRIS (HPP = cost 2.500).
      final saleB = await SaleService.recordSale(
        db,
        date: now,
        channel: 'takeaway',
        lines: [SaleLineInput(productId: airMineralId, qty: 1)],
        payments: [const SalePaymentInput(method: 'qris', amount: 5000)],
        shiftId: shiftId,
      );
      final linesB = await (db.select(db.saleLines)
            ..where((l) => l.saleId.equals(saleB)))
          .get();
      expect(linesB.single.hppPerUnit, 2500);
      final airMineral2 = await (db.select(db.products)
            ..where((p) => p.id.equals(airMineralId)))
          .getSingle();
      expect(airMineral2.stock, 96);

      // ---- 4. Split bill: order 1x Kopi Susu + 1x Es Teh, pisah Es Teh,
      // lalu bayar masing-masing tunai.
      final esTehId = await _productId(db, 'Es Teh Tubruk');
      final orderId = await OrderService.createOrder(
        db,
        channel: 'dine-in',
      );
      await OrderService.addLine(
        db,
        orderId: orderId,
        productId: kopiId,
        qty: 1,
      );
      final esTehLineId = await OrderService.addLine(
        db,
        orderId: orderId,
        productId: esTehId,
        qty: 1,
      );
      final splitOrderId = await OrderService.splitOrderByItems(
        db,
        orderId: orderId,
        lineIds: [esTehLineId],
      );
      expect(await OrderService.orderTotal(db, orderId), 18000);
      expect(await OrderService.orderTotal(db, splitOrderId), 8000);
      await SaleService.recordSale(
        db,
        date: now,
        channel: 'dine-in',
        lines: [SaleLineInput(productId: kopiId, qty: 1)],
        payments: [const SalePaymentInput(method: 'tunai', amount: 18000)],
        shiftId: shiftId,
        orderId: orderId,
      );
      await OrderService.markPaid(db, orderId);
      await SaleService.recordSale(
        db,
        date: now,
        channel: 'dine-in',
        lines: [SaleLineInput(productId: esTehId, qty: 1)],
        payments: [const SalePaymentInput(method: 'tunai', amount: 8000)],
        shiftId: shiftId,
        orderId: splitOrderId,
      );
      await OrderService.markPaid(db, splitOrderId);
      final order1 = await (db.select(db.orders)
            ..where((o) => o.id.equals(orderId)))
          .getSingle();
      final order2 = await (db.select(db.orders)
            ..where((o) => o.id.equals(splitOrderId)))
          .getSingle();
      expect(order1.status, 'paid');
      expect(order2.status, 'paid');

      // ---- 5. Tutup shift: harapan 100.000 + 62.000 tunai = 162.000.
      final close = await ShiftService.closeShift(
        db,
        shiftId: shiftId,
        actualCash: 162000,
      );
      expect(close.expectedCash, 162000);
      expect(close.actualCash, 162000);
      expect(close.cashDiff, 0, reason: 'rekonsiliasi shift pas, tanpa jurnal');

      // ---- 6. Stock-in kopi 1.000g Rp150.000 tunai.
      final kopiIngId = await _ingredientId(db, 'Biji Kopi House Blend');
      await AccountingService.recordStockIn(
        db,
        ingredientId: kopiIngId,
        qty: 1000,
        totalCost: 150000,
        payFrom: 'tunai',
      );
      expect(await _ingredientStock(db, 'Biji Kopi House Blend'), 4640.0);
      expect(
        await _ingredientAvgMilli(db, 'Biji Kopi House Blend'),
        150000,
        reason: 'avgCostMilli tetap Rp150/g (harga beli sama)',
      );

      // ---- 7. Opname kopi: aktual = sistem - 100g (susut Rp15.000).
      final kasir1 = await (db.select(db.employees)
            ..where((e) => e.name.equals('Kasir 1')))
          .getSingle();
      final opnameId = await AccountingService.createOpnameDraft(
        db,
        employeeId: kasir1.id,
        actualByIngredient: {kopiIngId: 4540.0},
        note: 'Fase 8 E2E',
      );
      await AccountingService.postOpname(db, opnameId);
      expect(await _ingredientStock(db, 'Biji Kopi House Blend'), 4540.0);
      final opnameJournal = await (db.select(db.journals)
            ..where((j) => j.refType.equals('opname')))
          .getSingle();
      final opnameLines = await (db.select(db.journalLines)
            ..where((l) => l.journalId.equals(opnameJournal.id)))
          .get();
      expect(
        opnameLines
            .where((l) => l.accountCode == '5200')
            .single
            .debit,
        15000,
        reason: 'susut 100g x Rp150 = Rp15.000 ke 5200',
      );

      // ---- 8. Beban listrik Rp1.000.000 (bank) — bukan tunai supaya
      // laci tidak minus (laci tinggal Rp200.000 setelah stock-in).
      await AccountingService.recordExpense(
        db,
        date: now,
        category: 'Listrik',
        amount: 1000000,
        accountCode: '5100',
        note: 'Listrik bulan berjalan (Fase 8 E2E)',
        payFrom: 'bank',
      );

      // ---- 9. Gaji 1 karyawan (Kasir 1, Rp1.500.000, bank).
      final period =
          '${now.year}-${now.month.toString().padLeft(2, '0')}';
      await AccountingService.paySalary(
        db,
        employeeId: kasir1.id,
        period: period,
        baseSalary: 1500000,
        payFrom: 'bank',
      );
      final payroll = await (db.select(db.payrolls)
            ..where((p) => p.employeeId.equals(kasir1.id)))
          .getSingle();
      expect(payroll.netPay, 1500000);

      // ---- 10. Laporan: Laba Rugi + Neraca (selisih 0) + Arus Kas.
      // CATATAN: `now` dicatat di awal test — jurnal stock-in/payroll
      // memakai DateTime.now() saat dipanggil (sesudah `now`), jadi
      // Neraca harus dibaca per tanggal SETELAH semua transaksi.
      final reportAsOf = DateTime.now();
      pl = await Reports.profitLoss(db, from, to);
      expect(pl.grossRevenue, 641000);
      expect(pl.hpp, 238140);
      expect(pl.grossProfit, 402860);
      expect(pl.opex, 2500000, reason: 'listrik 1jt + gaji 1,5jt');
      expect(pl.stockDiff, 15000);
      expect(pl.netProfit, -2112140);
      bs = await Reports.balanceSheet(db, reportAsOf);
      expect(bs.cash, 200000, reason: '288.000 + 62.000 - 150.000');
      expect(bs.bank, 14500000, reason: '17jt - 1jt - 1,5jt');
      expect(bs.qris, 291000, reason: '286.000 + 5.000');
      expect(bs.inventoryMaterials, 2906860);
      expect(bs.inventoryGoods, 240000);
      expect(bs.inventory, 3146860);
      expect(bs.totalAssets, 58137860);
      expect(bs.capital, 60000000);
      expect(bs.retainedEarnings, 250000);
      expect(bs.currentProfit, -2112140);
      expect(bs.difference, 0, reason: 'NERACA HARUS SELISIH 0');
      final cf = await Reports.cashFlow(db, from, to);
      expect(cf.operating, -2009000);
      expect(cf.investing, 0);
      expect(cf.financing, 17000000, reason: 'modal bank seed');
      expect(cf.netChange, 14991000);
      expect(cf.openingBalance, 0);
      expect(cf.closingBalance, 14991000);

      // ---- 11. Semua jurnal seimbang (debit total == kredit total).
      final allLines = await db.select(db.journalLines).get();
      final totalDebit = allLines.fold<int>(0, (s, l) => s + l.debit);
      final totalCredit = allLines.fold<int>(0, (s, l) => s + l.credit);
      expect(totalDebit, totalCredit);
      expect(totalDebit, greaterThan(0));

      // ---- 12. Backup -> import ke DB baru -> angka sama.
      final backupJson = await BackupService(db).exportJsonString();
      final db2 = AppDatabase.memory();
      final summary = await BackupService(db2).importJsonString(backupJson);
      expect(summary.tables, 29, reason: 'semua tabel ikut backup');
      expect(summary.rows, greaterThan(0));
      expect((await db2.select(db2.sales).get()).length, 19,
          reason: '15 seed + A + B + 2 split');
      final pl2 = await Reports.profitLoss(db2, from, to);
      expect(pl2.grossRevenue, pl.grossRevenue);
      expect(pl2.hpp, pl.hpp);
      expect(pl2.netProfit, pl.netProfit);
      final bs2 = await Reports.balanceSheet(db2, reportAsOf);
      expect(bs2.difference, 0);
      expect(bs2.totalAssets, bs.totalAssets);
      expect(bs2.totalEquity, bs.totalEquity);
      await db2.close();

      // ---- 13. Offline: semua tulis masuk outbox, sync tetap nonaktif.
      final engine = RealSyncEngine(db);
      expect(engine.isEnabled, isFalse);
      expect(await Outbox.pendingCount(db), greaterThan(0));
      final syncResult = await engine.syncNow();
      expect(syncResult.pushed, 0);
      expect(syncResult.pulled, 0);
      expect(syncResult.failed, 0);
      expect(await Outbox.pendingCount(db), greaterThan(0),
          reason: 'tanpa transport, outbox tidak terkuras');

      await db.close();
    });
  });

  group('Fase 8 — migrasi skema v1 -> v4 dari file DB lama sungguhan', () {
    test('file v1 (tanpa salaryType/baseSalary, employeeId NOT NULL, '
        'tanpa sync_conflicts) dibuka -> v4, data utuh', () async {
      final dir = await Directory.systemTemp.createTemp('casirz-mig-v1');
      final file = File('${dir.path}/casirz-v1.db');
      // --- Bangun file SQLite skema v1 persis seperti Fase 1-4:
      // employees tanpa salaryType/baseSalary; sales + shifts dengan
      // employeeId NOT NULL; payrolls tanpa additions/note;
      // tanpa tabel sync_conflicts; user_version = 1.
      final raw = sqlite3.sqlite3.open(file.path);
      raw.execute('PRAGMA foreign_keys = OFF');
      raw.execute('''
        CREATE TABLE employees (
          id TEXT NOT NULL PRIMARY KEY,
          name TEXT NOT NULL,
          role TEXT NOT NULL,
          pin_hash TEXT NOT NULL,
          is_active INTEGER NOT NULL DEFAULT 1,
          updated_at INTEGER NOT NULL,
          device_id TEXT NOT NULL,
          _deleted INTEGER NOT NULL DEFAULT 0
        )''');
      raw.execute('''
        CREATE TABLE shifts (
          id TEXT NOT NULL PRIMARY KEY,
          opened_at INTEGER NOT NULL,
          closed_at INTEGER,
          status TEXT NOT NULL,
          opening_float INTEGER NOT NULL,
          expected_cash INTEGER NOT NULL DEFAULT 0,
          actual_cash INTEGER NOT NULL DEFAULT 0,
          cash_diff INTEGER NOT NULL DEFAULT 0,
          employee_id TEXT NOT NULL REFERENCES employees(id),
          updated_at INTEGER NOT NULL,
          device_id TEXT NOT NULL,
          _deleted INTEGER NOT NULL DEFAULT 0
        )''');
      raw.execute('''
        CREATE TABLE sales (
          id TEXT NOT NULL PRIMARY KEY,
          code TEXT NOT NULL,
          date INTEGER NOT NULL,
          channel TEXT NOT NULL,
          payment_method TEXT NOT NULL,
          subtotal INTEGER NOT NULL,
          discount INTEGER NOT NULL DEFAULT 0,
          tax INTEGER NOT NULL DEFAULT 0,
          service_charge INTEGER NOT NULL DEFAULT 0,
          ojol_fee INTEGER NOT NULL DEFAULT 0,
          total INTEGER NOT NULL,
          paid INTEGER NOT NULL,
          "change" INTEGER NOT NULL DEFAULT 0,
          voided INTEGER NOT NULL DEFAULT 0,
          voided_at INTEGER,
          shift_id TEXT REFERENCES shifts(id),
          employee_id TEXT NOT NULL REFERENCES employees(id),
          customer_id TEXT,
          order_id TEXT,
          split_group_id TEXT,
          updated_at INTEGER NOT NULL,
          device_id TEXT NOT NULL,
          UNIQUE(code)
        )''');
      raw.execute('''
        CREATE TABLE payrolls (
          id TEXT NOT NULL PRIMARY KEY,
          employee_id TEXT NOT NULL REFERENCES employees(id),
          period TEXT NOT NULL,
          base_salary INTEGER NOT NULL,
          deductions INTEGER NOT NULL,
          net_pay INTEGER NOT NULL,
          paid_at INTEGER,
          updated_at INTEGER NOT NULL,
          device_id TEXT NOT NULL,
          UNIQUE(employee_id, period)
        )''');
      // Induk FK sales (customers, orders) — minimal, supaya
      // PRAGMA foreign_keys=ON tidak gagal saat insert ke sales.
      raw.execute('''
        CREATE TABLE customers (
          id TEXT NOT NULL PRIMARY KEY,
          name TEXT NOT NULL,
          phone TEXT,
          points INTEGER NOT NULL DEFAULT 0,
          updated_at INTEGER NOT NULL,
          device_id TEXT NOT NULL,
          _deleted INTEGER NOT NULL DEFAULT 0
        )''');
      raw.execute('''
        CREATE TABLE orders (
          id TEXT NOT NULL PRIMARY KEY,
          table_id TEXT,
          status TEXT NOT NULL,
          channel TEXT NOT NULL,
          updated_at INTEGER NOT NULL,
          device_id TEXT NOT NULL,
          _deleted INTEGER NOT NULL DEFAULT 0
        )''');
      raw.execute(
        "INSERT INTO employees VALUES ('emp-1','Owner Lama','owner','',1,1000,'dev-1',0)",
      );
      raw.execute(
        "INSERT INTO shifts VALUES ('shift-1',1000,NULL,'closed',100000,100000,100000,0,'emp-1',1000,'dev-1',0)",
      );
      raw.execute(
        "INSERT INTO sales VALUES ('sale-1','CSZ-20261101-0001',1000,'dine-in','tunai',18000,0,0,0,0,18000,18000,0,0,NULL,'shift-1','emp-1',NULL,NULL,NULL,1000,'dev-1')",
      );
      raw.execute(
        "INSERT INTO payrolls VALUES ('pay-1','emp-1','2026-10',1500000,0,1500000,1000,1000,'dev-1')",
      );
      raw.execute('PRAGMA user_version = 1');
      raw.dispose();

      // --- Buka dengan AppDatabase (schemaVersion 4): onUpgrade jalan.
      final db = AppDatabase(NativeDatabase(file));
      final employees = await db.select(db.employees).get();
      expect(employees.length, 1);
      expect(employees.single.name, 'Owner Lama',
          reason: 'data v1 dipertahankan');
      expect(employees.single.salaryType, 'bulanan',
          reason: 'kolom v2 terisi default');
      expect(employees.single.baseSalary, 0,
          reason: 'kolom v2 terisi default');
      final sales = await db.select(db.sales).get();
      expect(sales.length, 1);
      expect(sales.single.code, 'CSZ-20261101-0001');
      final shifts = await db.select(db.shifts).get();
      expect(shifts.length, 1);

      // v3: employeeId boleh null — tulis baris baru tanpa employeeId.
      final info = await db.customSelect(
        'PRAGMA table_info(sales)',
        variables: const [],
      ).get();
      final empCol = info.firstWhere(
        (r) => r.read<String>('name') == 'employee_id',
      );
      expect(empCol.read<int>('notnull'), 0,
          reason: 'sales.employee_id nullable setelah migrasi v3');
      await db.into(db.sales).insert(
            SalesCompanion.insert(
              id: 'sale-2',
              code: 'CSZ-20261101-0002',
              date: 2000,
              channel: 'takeaway',
              paymentMethod: 'qris',
              subtotal: 5000,
              total: 5000,
              paid: 5000,
              updatedAt: 2000,
              deviceId: 'dev-1',
            ),
          );

      // v4: tabel sync_conflicts ada.
      final tables = await db.customSelect(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='sync_conflicts'",
        variables: const [],
      ).get();
      expect(tables.length, 1, reason: 'sync_conflicts dibuat saat upgrade');
      final conflicts = await db.select(db.syncConflicts).get();
      expect(conflicts, isEmpty);

      // v2 payrolls: additions + note ada (default 0 / null).
      final payInfo = await db.customSelect(
        'PRAGMA table_info(payrolls)',
        variables: const [],
      ).get();
      final payCols =
          payInfo.map((r) => r.read<String>('name')).toSet();
      expect(payCols.contains('additions'), isTrue);
      expect(payCols.contains('note'), isTrue);

      await db.close();
      await dir.delete(recursive: true);
    });
  });

  group('Fase 8 — offline + badge sync', () {
    test('config kosong: Supabase tidak terkonfigurasi, engine nonaktif',
        () {
      expect(SupabaseConfig.fromEnvironment().isConfigured, isFalse);
      expect(
        () => SupabaseTransport(const SupabaseConfig(url: '', anonKey: '')),
        throwsA(isA<StateError>()),
      );
    });

    testWidgets("badge 'Sync belum aktif' tampil bila config kosong",
        (tester) async {
      final db = AppDatabase.memory();
      await tester.pumpWidget(CasirzApp(db: db));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Sync belum aktif'), findsOneWidget);
      await db.close();
    });
  });
}
