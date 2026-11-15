// Casirz ERP — Fase 1 Core Engine.
// Seed demo "Warkop Kekinian Preset" Rp60jt (BLUEPRINT-FLUTTER.md §10).
//
// Angka PERSIS laporan §3.5 / blueprint §10 — bukan rencana bisnis
// Warkop Hits Dony (investor: modal Rp50jt, sewa Rp24jt). Sengaja
// dibedakan; layar seed (Fase 4+) wajib menulis itu.
//
// Model: RESET & ISI ULANG (idempotent — ditekan 2x tidak duplikat).
// Seed WAJIB lewat jalur transaksi yang sama dengan transaksi asli
// (SaleService + postJournal + deductBOM) — bukan insert mentah —
// supaya jurnal seimbang dan stok konsisten sejak detik pertama.
//
// Oracle (tes Fase 1): 15 transaksi 7 hari, omzet Rp574.000,
// HPP Rp210.360, laba kotor Rp363.640; Neraca selisih 0.
//
// CATATAN:
// - Seed TIDAK menulis outbox untuk penghapusan reset (wipe lokal);
//   penjualan seed sendiri TETAP menulis outbox karena lewat
//   SaleService yang sama dengan penjualan asli.
// - Stok awal Air Mineral = 100 pcs @Rp2.500 (nilai Rp250.000, akun 1110
//   — Adendum pasca-Fase 1 butir 4, Fase 4). Saldo awalnya dijurnal
//   D 1110 / K 3100 (pola yang sama dengan saldo awal migrasi §9).
//   Setelah 15 transaksi seed (3 Air Mineral terjual), stoknya 97 pcs
//   dan saldo 1110 = 250.000 - 3 x 2.500 = Rp242.500.
// - PIN karyawan seed KOSONG — pemilik wajib atur PIN di layar Staf.
//   Jangan pernah mengarang PIN default.
// - Komisi ojol seed = 0 (Dony belum mengisi angka — jangan dikarang).
import 'package:drift/drift.dart';

import 'accounting_service.dart';
import 'db.dart';
import 'ledger.dart';
import 'money.dart';
import 'sales_service.dart';
import 'sync.dart';

class SeedDemo {
  /// Stok awal Air Mineral (produk tanpa BOM). Adendum pasca-Fase 1
  /// butir 4 (Fase 4): 100 pcs @Rp2.500, nilai Rp250.000 (akun 1110).
  static const int airMineralStock = 100;

  /// True bila seed demo sudah pernah dijalankan (settings.demoSeeded).
  static Future<bool> isSeeded(AppDatabase db) async {
    return (await db.getSetting('demoSeeded')) == '1';
  }

  /// Reset & isi ulang data demo. Idempotent.
  static Future<void> run(AppDatabase db) async {
    final deviceId = await db.deviceId();
    final now = DateTime.now();
    final todayNoon = DateTime(now.year, now.month, now.day, 12);
    final rentStartMonth =
        '${now.year}-${now.month.toString().padLeft(2, '0')}';

    await db.transaction(() async {
      await _reset(db);

      // ---- Karyawan: 1 Owner + 2 Kasir (PIN kosong — diatur pemilik).
      // Gaji (BLUEPRINT §10.2): 2 kasir @Rp1.500.000/bulan. Owner 0.
      final ownerId = newId();
      final kasir1Id = newId();
      final kasir2Id = newId();
      final t = nowMs();
      for (final e in [
        (ownerId, 'Owner', 'owner', 'bulanan', 0),
        (kasir1Id, 'Kasir 1', 'kasir', 'bulanan', 1500000),
        (kasir2Id, 'Kasir 2', 'kasir', 'bulanan', 1500000),
      ]) {
        await db.into(db.employees).insert(
              EmployeesCompanion.insert(
                id: e.$1,
                name: e.$2,
                role: e.$3,
                pinHash: '',
                salaryType: Value(e.$4),
                baseSalary: Value(e.$5),
                updatedAt: t,
                deviceId: deviceId,
              ),
            );
      }

      // ---- 11 bahan (§10.3) — nilai total TEPAT Rp3.000.000.
      // (nama, satuan, stok awal, harga/satuan Rp)
      const ingredients = [
        ('Biji Kopi House Blend', 'gram', 4000.0, 150),
        ('Susu UHT Full Cream', 'ml', 15000.0, 18),
        ('Gula Aren Cair', 'ml', 5000.0, 60),
        ('Teh Tubruk', 'gram', 2000.0, 120),
        ('Susu Kental Manis', 'ml', 5000.0, 30),
        ('Indomie Goreng', 'pcs', 120.0, 3000),
        ('Telur Ayam', 'pcs', 200.0, 2000),
        ('Roti Tawar', 'pcs', 150.0, 1000),
        ('Cokelat Meses', 'gram', 1500.0, 100),
        ('Cup 16oz', 'pcs', 300.0, 1000),
        ('Sedotan', 'pcs', 800.0, 100),
      ];
      final ingredientIds = <String, String>{};
      for (final ing in ingredients) {
        final id = newId();
        ingredientIds[ing.$1] = id;
        await db.into(db.ingredients).insert(
              IngredientsCompanion.insert(
                id: id,
                name: ing.$1,
                unit: ing.$2,
                stockQty: Value(ing.$3),
                avgCostMilli: Value(ing.$4 * 1000),
                totalValue: Value(toIntRp(ing.$3) * ing.$4),
                updatedAt: t,
                deviceId: deviceId,
              ),
            );
      }

      // ---- 10 menu (§10.4) + BOM.
      // (nama, kategori, harga, cost fallback, stok barang jadi)
      const products = [
        ('Kopi Susu Gula Aren', 'Minuman', 18000, 7360, 0),
        ('Es Kopi Hitam', 'Minuman', 12000, 3800, 0),
        ('Es Teh Tubruk', 'Minuman', 8000, 3200, 0),
        ('Susu Cokelat Meses', 'Minuman', 15000, 5800, 0),
        ('Roti Bakar Meses', 'Makanan', 15000, 3800, 0),
        ('Indomie Goreng Telur', 'Makanan', 18000, 5000, 0),
        ('Indomie Goreng Spesial', 'Makanan', 22000, 7000, 0),
        ('Es Kopi Susu SKM', 'Minuman', 15000, 6200, 0),
        ('Teh Susu Gula Aren', 'Minuman', 12000, 5300, 0),
        ('Air Mineral', 'Minuman', 5000, 2500, airMineralStock),
      ];
      final productIds = <String, String>{};
      final productPrices = <String, int>{};
      for (final p in products) {
        final id = newId();
        productIds[p.$1] = id;
        productPrices[p.$1] = p.$3;
        await db.into(db.products).insert(
              ProductsCompanion.insert(
                id: id,
                name: p.$1,
                category: p.$2,
                price: p.$3,
                cost: p.$4,
                stock: Value(p.$5),
                updatedAt: t,
                deviceId: deviceId,
              ),
            );
      }

      // BOM per 1 porsi (§10.4). HPP dihitung dari bahan, bukan angka ketik
      // (cost di atas hanya fallback tampilan / produk tanpa BOM).
      final bom = <String, List<(String, double)>>{
        'Kopi Susu Gula Aren': [
          ('Biji Kopi House Blend', 18),
          ('Susu UHT Full Cream', 120),
          ('Gula Aren Cair', 25),
          ('Cup 16oz', 1),
        ],
        'Es Kopi Hitam': [
          ('Biji Kopi House Blend', 18),
          ('Cup 16oz', 1),
          ('Sedotan', 1),
        ],
        'Es Teh Tubruk': [
          ('Teh Tubruk', 10),
          ('Gula Aren Cair', 15),
          ('Cup 16oz', 1),
          ('Sedotan', 1),
        ],
        'Susu Cokelat Meses': [
          ('Susu UHT Full Cream', 150),
          ('Cokelat Meses', 20),
          ('Cup 16oz', 1),
          ('Sedotan', 1),
        ],
        'Roti Bakar Meses': [
          ('Roti Tawar', 2),
          ('Cokelat Meses', 15),
          ('Susu Kental Manis', 10),
        ],
        'Indomie Goreng Telur': [
          ('Indomie Goreng', 1),
          ('Telur Ayam', 1),
        ],
        'Indomie Goreng Spesial': [
          ('Indomie Goreng', 1),
          ('Telur Ayam', 2),
        ],
        'Es Kopi Susu SKM': [
          ('Biji Kopi House Blend', 18),
          ('Susu UHT Full Cream', 100),
          ('Susu Kental Manis', 20),
          ('Cup 16oz', 1),
          ('Sedotan', 1),
        ],
        'Teh Susu Gula Aren': [
          ('Teh Tubruk', 10),
          ('Susu UHT Full Cream', 100),
          ('Gula Aren Cair', 20),
          ('Cup 16oz', 1),
          ('Sedotan', 1),
        ],
        // Air Mineral: tanpa BOM.
      };
      for (final entry in bom.entries) {
        final recipeId = newId();
        await db.into(db.recipes).insert(
              RecipesCompanion.insert(
                id: recipeId,
                productId: productIds[entry.key]!,
                updatedAt: t,
                deviceId: deviceId,
              ),
            );
        for (final line in entry.value) {
          await db.into(db.recipeLines).insert(
                RecipeLinesCompanion.insert(
                  id: newId(),
                  recipeId: recipeId,
                  ingredientId: ingredientIds[line.$1]!,
                  qty: line.$2,
                  updatedAt: t,
                  deviceId: deviceId,
                ),
              );
        }
      }

      // ---- 4 aset (§10.1): total Rp10.000.000, 60 bulan, residu 0.
      const assets = [
        ('Mesin Kopi', 5000000),
        ('Kulkas Showcase', 2500000),
        ('Kompor & Peralatan Dapur', 1500000),
        ('Meja Kursi', 1000000),
      ];
      for (final a in assets) {
        await db.into(db.assets).insert(
              AssetsCompanion.insert(
                id: newId(),
                name: a.$1,
                purchaseDate: todayNoon
                    .subtract(const Duration(days: 7))
                    .millisecondsSinceEpoch,
                cost: a.$2,
                residualValue: 0,
                usefulLifeMonths: 60,
                updatedAt: t,
                deviceId: deviceId,
              ),
            );
      }

      // ---- Modal Rp60.000.000 (§10.1).
      // D 1010 17jt + D 1200 30jt + D 1300 10jt + D 1100 3jt / K 3000 60jt.
      await AccountingService.recordCapital(
        db,
        date: todayNoon.subtract(const Duration(days: 7)),
        bank: 17000000,
        rentPrepaid: 30000000,
        assets: 10000000,
        inventory: 3000000,
        refId: 'seed-modal',
        memo: 'Modal awal disetor (seed demo)',
      );

      // ---- Saldo awal barang dagangan (Fase 4): Air Mineral 100 pcs
      // @Rp2.500 = Rp250.000. D 1110 / K 3100 — pola saldo awal migrasi
      // (§9: D persediaan / K 3100). Setelah 15 transaksi seed (3 Air
      // Mineral terjual) saldo 1110 = 250.000 - 3 x 2.500 = Rp242.500.
      final saldoAwalId = await Ledger.postJournal(
        db,
        date: todayNoon.subtract(const Duration(days: 7)),
        memo: 'Saldo awal barang dagangan (seed demo): Air Mineral 100 pcs',
        refType: 'saldo-awal',
        refId: 'seed-1110',
        lines: const [
          JournalLineInput(accountCode: '1110', debit: 250000, credit: 0),
          JournalLineInput(accountCode: '3100', debit: 0, credit: 250000),
        ],
      );
      await Outbox.writeJournal(db, saldoAwalId);

      // ---- Settings seed.
      await db.setSetting('storeName', 'Warkop Kekinian');
      await db.setSetting('capital', '60000000');
      await db.setSetting('demoSeeded', '1');
      await db.setSetting('ojolFeeGoFood', '0');
      await db.setSetting('ojolFeeGrabFood', '0');
      await db.setSetting('ojolFeeShopeeFood', '0');
      await db.setSetting('ppnRate', '11');
      await db.setSetting('ppnEnabled', '0');
      await db.setSetting('serviceChargeRate', '0');
      await db.setSetting('pb1Rate', '0');
      await db.setSetting('rentTotal', '30000000');
      await db.setSetting('rentMonths', '12');
      await db.setSetting('rentStartMonth', rentStartMonth);
      // OPEX bulanan tetap (BLUEPRINT §10.2) — dipakai Command Center
      // untuk prorata harian (÷ 30). Gaji tidak di sini: gaji dihitung
      // dari karyawan aktif di DashboardService.
      await db.setSetting('opexListrik', '1000000');
      await db.setSetting('opexAir', '200000');
      await db.setSetting('opexInternet', '500000');

      // ---- 15 transaksi, 7 hari terakhir (§10.5).
      // (hariOffset, channel, metode, [(menu, qty)])
      final sales = <(int, String, String, List<(String, int)>)>[
        (7, 'dine-in', 'tunai', [('Kopi Susu Gula Aren', 2)]),
        (
          7,
          'takeaway',
          'qris',
          [('Indomie Goreng Telur', 1), ('Es Teh Tubruk', 1)],
        ),
        (6, 'dine-in', 'tunai', [('Es Kopi Hitam', 3)]),
        (
          6,
          'dine-in',
          'tunai',
          [('Roti Bakar Meses', 1), ('Kopi Susu Gula Aren', 2)],
        ),
        (5, 'ojol', 'ojol', [('Indomie Goreng Spesial', 2)]),
        (
          5,
          'dine-in',
          'qris',
          [('Susu Cokelat Meses', 1), ('Es Teh Tubruk', 1)],
        ),
        (
          4,
          'takeaway',
          'tunai',
          [('Kopi Susu Gula Aren', 1), ('Air Mineral', 1)],
        ),
        (4, 'dine-in', 'tunai', [('Teh Susu Gula Aren', 2)]),
        (
          4,
          'ojol',
          'ojol',
          [('Indomie Goreng Telur', 1), ('Es Kopi Susu SKM', 1)],
        ),
        (3, 'dine-in', 'qris', [('Kopi Susu Gula Aren', 4)]),
        (
          3,
          'takeaway',
          'tunai',
          [('Roti Bakar Meses', 1), ('Es Kopi Hitam', 1)],
        ),
        (
          2,
          'dine-in',
          'tunai',
          [('Susu Cokelat Meses', 2), ('Indomie Goreng Spesial', 1)],
        ),
        (
          2,
          'ojol',
          'ojol',
          [('Es Teh Tubruk', 3), ('Air Mineral', 2)],
        ),
        (
          1,
          'dine-in',
          'qris',
          [('Kopi Susu Gula Aren', 2), ('Indomie Goreng Telur', 1)],
        ),
        (
          1,
          'dine-in',
          'tunai',
          [
            ('Teh Susu Gula Aren', 1),
            ('Roti Bakar Meses', 1),
            ('Es Kopi Hitam', 1),
          ],
        ),
      ];
      for (final s in sales) {
        final date = todayNoon.subtract(Duration(days: s.$1));
        final lines = s.$4
            .map(
              (item) => SaleLineInput(
                productId: productIds[item.$1]!,
                qty: item.$2,
              ),
            )
            .toList();
        var total = 0;
        for (final item in s.$4) {
          total += productPrices[item.$1]! * item.$2;
        }
        await SaleService.recordSale(
          db,
          date: date,
          channel: s.$2,
          lines: lines,
          payments: [SalePaymentInput(method: s.$3, amount: total)],
          employeeId: kasir1Id,
          ojolFee: 0, // komisi ojol seed = 0 (Dony belum mengisi angka)
        );
      }
    });
  }

  /// Hapus semua data transaksi + master demo (bagan akun + settings
  /// deviceId dipertahankan). Urutan hapus mengikuti foreign key
  /// (anak dulu, induk belakangan).
  static Future<void> _reset(AppDatabase db) async {
    await db.delete(db.journalLines).go();
    await db.delete(db.journals).go();
    await db.delete(db.stockMoves).go();
    await db.delete(db.salePayments).go();
    await db.delete(db.saleLines).go();
    await db.delete(db.sales).go();
    await db.delete(db.orderLines).go();
    await db.delete(db.orders).go();
    await db.delete(db.stockOpnameLines).go();
    await db.delete(db.stockOpnames).go();
    await db.delete(db.recipeLines).go();
    await db.delete(db.recipes).go();
    await db.delete(db.expenses).go();
    await db.delete(db.payrolls).go();
    await db.delete(db.attendance).go();
    await db.delete(db.pettyCash).go();
    await db.delete(db.shifts).go();
    await db.delete(db.assets).go();
    await db.delete(db.products).go();
    await db.delete(db.ingredients).go();
    await db.delete(db.customers).go();
    await db.delete(db.promos).go();
    await db.delete(db.employees).go();
    await db.delete(db.shopTables).go();
    await db.delete(db.syncOutbox).go();
    await db.delete(db.syncState).go();
  }
}
