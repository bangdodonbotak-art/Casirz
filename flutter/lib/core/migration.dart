// Casirz ERP — Fase 1 Core Engine.
// Migrasi localStorage "casirz" (web) -> Drift via file export JSON
// (BLUEPRINT-FLUTTER.md §9).
//
// CATATAN JUJUR (bukan placeholder — batas yang diketahui):
// Fungsi export di web v2 BELUM ADA. Format di §9.1 adalah spesifikasi
// yang harus dibuat di repo web (tombol export di Pengaturan web v2)
// sebelum migrasi bisa jalan penuh end-to-end. Sisi Flutter (parser +
// validator + import) disiapkan di Fase 1 sesuai format ini. Jangan
// klaim migrasi "sudah bisa dites" sebelum export web-nya ada.
//
// Aturan import (BLUEPRINT §9.1):
// 1. Validasi dulu, tulis belakangan. Struktur rusak / tipe salah ->
//    migrasi dibatalkan + pesan error, bukan data setengah.
// 2. Sekali jalan, dalam satu transaksi Drift. Hanya bila database
//    masih kosong. Flag settings.migrated = '1' ditulis SETELAH import
//    berhasil commit — bukan sebelumnya.
// 3. Produk & stok lama masuk sebagai saldo awal: D 1100 Persediaan
//    (nilai jumlah cost x stok) / K 3100 Laba Ditahan — satu jurnal
//    refType 'migrasi-saldo-awal'.
// 4. Penjualan historis lama TIDAK dijurnal ulang (dianggap data mentah,
//    tidak masuk Laba Rugi baru). Disimpan ke sales + saleLines dengan
//    hppPerUnit = products.cost saat itu, tanpa pengurangan stok bahan.
//    Ini satu-satunya pengecualian prinsip "setiap penjualan dijurnal".
// 5. Karyawan lama diimport tanpa PIN (pinHash kosong) — pemilik wajib
//    atur PIN tiap karyawan sebelum bisa absen. Jangan mengarang PIN.
// 6. Penjualan historis butuh employeeId (FK non-null): dipakai karyawan
//    penanda 'Data Lama (Migrasi)' yang dibuat saat import.
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';

import 'db.dart';
import 'errors.dart';
import 'ledger.dart';
import 'money.dart';

/// Ringkasan hasil import.
class MigrationSummary {
  const MigrationSummary({
    required this.products,
    required this.customers,
    required this.promos,
    required this.sales,
    required this.openingBalance,
  });
  final int products;
  final int customers;
  final int promos;
  final int sales;
  final int openingBalance; // Rp nilai persediaan saldo awal
}

class Migration {
  static const String format = 'casirz-export-v1';

  /// Pilih file `casirz-export-v1.json` lewat file_picker lalu import.
  /// Dipakai UI (Fase 4+); unit test memakai [importFromJsonString].
  static Future<MigrationSummary> pickAndImport(AppDatabase db) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: true,
    );
    final bytes = result?.files.single.bytes;
    if (bytes == null) {
      throw MigrasiTidakValid('Tidak ada file yang dipilih.');
    }
    return importFromJsonString(db, utf8.decode(bytes));
  }

  /// Import dari string JSON (dipakai test + pickAndImport).
  static Future<MigrationSummary> importFromJsonString(
    AppDatabase db,
    String jsonStr,
  ) async {
    final decoded = jsonDecode(jsonStr);
    if (decoded is! Map<String, dynamic>) {
      throw MigrasiTidakValid('File bukan objek JSON.');
    }
    return importFromMap(db, decoded);
  }

  /// Import dari Map yang sudah di-decode. Validasi dulu, tulis belakangan.
  static Future<MigrationSummary> importFromMap(
    AppDatabase db,
    Map<String, dynamic> json,
  ) async {
    final data = _validate(json);

    // Hanya bila database masih kosong.
    final existingProducts = await db.select(db.products).get();
    final existingSales = await db.select(db.sales).get();
    if (existingProducts.isNotEmpty || existingSales.isNotEmpty) {
      throw StateError(
        'Database tidak kosong — migrasi hanya sekali jalan saat '
        'database baru kosong.',
      );
    }

    final deviceId = await db.deviceId();
    final summary = await db.transaction(() async {
      final now = nowMs();

      for (final p in data.products) {
        await db.into(db.products).insert(
              ProductsCompanion.insert(
                id: p.id,
                name: p.name,
                category: p.category,
                price: p.price,
                cost: p.cost,
                stock: Value(p.stock),
                updatedAt: now,
                deviceId: deviceId,
              ),
            );
      }
      for (final c in data.customers) {
        await db.into(db.customers).insert(
              CustomersCompanion.insert(
                id: c.id,
                name: c.name,
                phone: Value(c.phone),
                points: Value(c.points),
                updatedAt: now,
                deviceId: deviceId,
              ),
            );
      }
      for (final p in data.promos) {
        await db.into(db.promos).insert(
              PromosCompanion.insert(
                id: p.id,
                code: p.code,
                type: p.type,
                value: p.value,
                updatedAt: now,
                deviceId: deviceId,
              ),
            );
      }
      for (final e in data.employees) {
        await db.into(db.employees).insert(
              EmployeesCompanion.insert(
                id: e.id,
                name: e.name,
                role: e.role,
                pinHash: '',
                updatedAt: now,
                deviceId: deviceId,
              ),
            );
      }

      // Karyawan penanda untuk penjualan historis (butuh employeeId).
      const migrationEmployeeId = 'migrasi';
      await db.into(db.employees).insert(
            EmployeesCompanion.insert(
              id: migrationEmployeeId,
              name: 'Data Lama (Migrasi)',
              role: 'kasir',
              pinHash: '',
              updatedAt: now,
              deviceId: deviceId,
            ),
          );

      // Penjualan historis — TANPA jurnal, TANPA potong stok.
      for (final s in data.sales) {
        await db.into(db.sales).insert(
              SalesCompanion.insert(
                id: s.id,
                code: s.code,
                date: s.date,
                channel: 'takeaway',
                paymentMethod: s.paymentMethod,
                subtotal: s.total,
                total: s.total,
                paid: s.total,
                change: const Value(0),
                employeeId: Value(migrationEmployeeId),
                updatedAt: now,
                deviceId: deviceId,
              ),
            );
        for (final item in s.items) {
          final product = data.products
              .firstWhere((p) => p.id == item.productId);
          await db.into(db.saleLines).insert(
                SaleLinesCompanion.insert(
                  id: newId(),
                  saleId: s.id,
                  productId: item.productId,
                  qty: item.qty,
                  price: item.price,
                  hppPerUnit: product.cost,
                  updatedAt: now,
                  deviceId: deviceId,
                ),
              );
        }
      }

      // Saldo awal: D 1100 (jumlah cost x stok) / K 3100.
      var openingBalance = 0;
      for (final p in data.products) {
        openingBalance += p.cost * p.stock;
      }
      if (openingBalance > 0) {
        await Ledger.postJournal(
          db,
          date: DateTime.now(),
          memo: 'Saldo awal migrasi dari web v2',
          refType: 'migrasi-saldo-awal',
          refId: 'migrasi-1',
          lines: [
            JournalLineInput(
              accountCode: '1100',
              debit: openingBalance,
              credit: 0,
            ),
            JournalLineInput(
              accountCode: '3100',
              debit: 0,
              credit: openingBalance,
            ),
          ],
        );
      }
      return MigrationSummary(
        products: data.products.length,
        customers: data.customers.length,
        promos: data.promos.length,
        sales: data.sales.length,
        openingBalance: openingBalance,
      );
    });

    // Flag ditulis SETELAH import berhasil commit.
    await db.setSetting('migrated', '1');
    return summary;
  }

  /// Validasi struktur + tipe. Throw [MigrasiTidakValid] bila rusak.
  static _ExportData _validate(Map<String, dynamic> json) {
    if (json['format'] != format) {
      throw MigrasiTidakValid(
        'Format tidak dikenal: ${json['format']} '
        '(diharapkan $format).',
      );
    }
    final products = _list(json, 'products').map(_parseProduct).toList();
    final customers = _list(json, 'customers').map(_parseCustomer).toList();
    final promos = _list(json, 'promos').map(_parsePromo).toList();
    final employees = _list(json, 'employees').map(_parseEmployee).toList();
    final sales = _list(json, 'sales').map(_parseSale).toList();

    _checkUniqueIds(products.map((p) => p.id), 'products');
    _checkUniqueIds(customers.map((c) => c.id), 'customers');
    _checkUniqueIds(promos.map((p) => p.id), 'promos');
    _checkUniqueIds(employees.map((e) => e.id), 'employees');
    _checkUniqueIds(sales.map((s) => s.id), 'sales');
    _checkUniqueIds(sales.map((s) => s.code), 'sales.code');

    final productIds = products.map((p) => p.id).toSet();
    for (final sale in sales) {
      for (final item in sale.items) {
        if (!productIds.contains(item.productId)) {
          throw MigrasiTidakValid(
            'Penjualan ${sale.code} memakai produk tidak dikenal: '
            '${item.productId}.',
          );
        }
      }
    }
    return _ExportData(
      products: products,
      customers: customers,
      promos: promos,
      employees: employees,
      sales: sales,
    );
  }

  static List<Map<String, dynamic>> _list(
    Map<String, dynamic> json,
    String key,
  ) {
    final value = json[key];
    if (value == null) return [];
    if (value is! List) {
      throw MigrasiTidakValid('Bagian "$key" harus berupa list.');
    }
    return value.map((e) {
      if (e is! Map<String, dynamic>) {
        throw MigrasiTidakValid('Entri "$key" harus berupa objek.');
      }
      return e;
    }).toList();
  }

  static void _checkUniqueIds(Iterable<String> ids, String what) {
    final seen = <String>{};
    for (final id in ids) {
      if (!seen.add(id)) {
        throw MigrasiTidakValid('Id duplikat di $what: $id.');
      }
    }
  }

  static String _reqString(Map<String, dynamic> m, String key) {
    final v = m[key];
    if (v is! String || v.isEmpty) {
      throw MigrasiTidakValid('Field "$key" harus string tidak kosong: $m.');
    }
    return v;
  }

  static int _reqMoney(Map<String, dynamic> m, String key) {
    final v = m[key];
    if (v is! num) {
      throw MigrasiTidakValid('Field "$key" harus angka: $m.');
    }
    return toIntRp(v);
  }

  static int _optMoney(Map<String, dynamic> m, String key, [int def = 0]) {
    final v = m[key];
    if (v == null) return def;
    if (v is! num) {
      throw MigrasiTidakValid('Field "$key" harus angka: $m.');
    }
    return toIntRp(v);
  }

  static int _optInt(Map<String, dynamic> m, String key, [int def = 0]) {
    final v = m[key];
    if (v == null) return def;
    if (v is! num) {
      throw MigrasiTidakValid('Field "$key" harus angka: $m.');
    }
    return v.toInt();
  }

  static _ExportProduct _parseProduct(Map<String, dynamic> m) {
    final price = _optMoney(m, 'price');
    final cost = _optMoney(m, 'cost');
    final stock = _optInt(m, 'stock');
    if (price < 0 || cost < 0 || stock < 0) {
      throw MigrasiTidakValid('Produk dengan angka negatif: $m.');
    }
    return _ExportProduct(
      id: _reqString(m, 'id'),
      name: _reqString(m, 'name'),
      category: (m['category'] as String?) ?? 'Umum',
      price: price,
      cost: cost,
      stock: stock,
    );
  }

  static _ExportCustomer _parseCustomer(Map<String, dynamic> m) {
    return _ExportCustomer(
      id: _reqString(m, 'id'),
      name: _reqString(m, 'name'),
      phone: m['phone'] as String?,
      points: _optInt(m, 'points'),
    );
  }

  static _ExportPromo _parsePromo(Map<String, dynamic> m) {
    final type = _reqString(m, 'type');
    if (type != 'persen' && type != 'potongan') {
      throw MigrasiTidakValid('Tipe promo tidak dikenal: $type.');
    }
    return _ExportPromo(
      id: _reqString(m, 'id'),
      code: _reqString(m, 'code'),
      type: type,
      value: _reqMoney(m, 'value'),
    );
  }

  static _ExportEmployee _parseEmployee(Map<String, dynamic> m) {
    final role = (m['role'] as String?) ?? 'kasir';
    return _ExportEmployee(
      id: _reqString(m, 'id'),
      name: _reqString(m, 'name'),
      role: (role == 'owner' || role == 'manager' || role == 'kasir')
          ? role
          : 'kasir',
    );
  }

  static _ExportSale _parseSale(Map<String, dynamic> m) {
    final method = (m['paymentMethod'] as String?) ?? 'tunai';
    if (method != 'tunai' &&
        method != 'qris' &&
        method != 'ojol' &&
        method != 'multi') {
      throw MigrasiTidakValid('Metode bayar tidak dikenal: $method.');
    }
    final rawItems = m['items'];
    if (rawItems is! List || rawItems.isEmpty) {
      throw MigrasiTidakValid('Penjualan tanpa items: $m.');
    }
    final items = rawItems.map((e) {
      if (e is! Map<String, dynamic>) {
        throw MigrasiTidakValid('Item penjualan harus berupa objek: $e.');
      }
      final qty = _optInt(e, 'qty');
      if (qty <= 0) {
        throw MigrasiTidakValid('qty item harus > 0: $e.');
      }
      return _ExportSaleItem(
        productId: _reqString(e, 'productId'),
        qty: qty,
        price: _reqMoney(e, 'price'),
      );
    }).toList();
    final date = m['date'];
    if (date is! num) {
      throw MigrasiTidakValid('Field "date" harus epoch ms: $m.');
    }
    return _ExportSale(
      id: _reqString(m, 'id'),
      code: (m['code'] as String?) ?? 'MIG-${_reqString(m, 'id')}',
      date: date.toInt(),
      total: _reqMoney(m, 'total'),
      paymentMethod: method,
      items: items,
    );
  }
}

class _ExportData {
  _ExportData({
    required this.products,
    required this.customers,
    required this.promos,
    required this.employees,
    required this.sales,
  });
  final List<_ExportProduct> products;
  final List<_ExportCustomer> customers;
  final List<_ExportPromo> promos;
  final List<_ExportEmployee> employees;
  final List<_ExportSale> sales;
}

class _ExportProduct {
  _ExportProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.cost,
    required this.stock,
  });
  final String id;
  final String name;
  final String category;
  final int price;
  final int cost;
  final int stock;
}

class _ExportCustomer {
  _ExportCustomer({
    required this.id,
    required this.name,
    required this.phone,
    required this.points,
  });
  final String id;
  final String name;
  final String? phone;
  final int points;
}

class _ExportPromo {
  _ExportPromo({
    required this.id,
    required this.code,
    required this.type,
    required this.value,
  });
  final String id;
  final String code;
  final String type;
  final int value;
}

class _ExportEmployee {
  _ExportEmployee({
    required this.id,
    required this.name,
    required this.role,
  });
  final String id;
  final String name;
  final String role;
}

class _ExportSale {
  _ExportSale({
    required this.id,
    required this.code,
    required this.date,
    required this.total,
    required this.paymentMethod,
    required this.items,
  });
  final String id;
  final String code;
  final int date;
  final int total;
  final String paymentMethod;
  final List<_ExportSaleItem> items;
}

class _ExportSaleItem {
  _ExportSaleItem({
    required this.productId,
    required this.qty,
    required this.price,
  });
  final String productId;
  final int qty;
  final int price;
}
