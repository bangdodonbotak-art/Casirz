// Casirz ERP — Fase 1 Core Engine.
// Database lokal Drift (SQLite) — cermin 1:1 laporan §3.2 /
// BLUEPRINT-FLUTTER.md §3.2. Database lokal = sumber kebenaran.
//
// Aturan kolom umum:
// - Semua tabel (kecuali syncOutbox, syncState, settings) punya
//   id TEXT PRIMARY KEY (UUID v4 dibuat di device), updatedAt INTEGER
//   (epoch ms UTC), deviceId TEXT.
// - Tabel MASTER punya isDeleted (kolom SQLite '_deleted' INTEGER 0/1,
//   tombstone — baris tidak pernah dihapus fisik).
// - Tabel APPEND (sales, saleLines, salePayments, stockMoves, journals,
//   journalLines, expenses, attendance, payrolls) TIDAK memakai _deleted:
//   event tidak bisa diubah; salah catat -> entri koreksi baru.
// - Uang = int Rupiah. Kuantitas bahan = double, dibulatkan 3 desimal.
// - Bagan akun (30 akun) di-seed saat onCreate, bukan lewat seed demo.
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:uuid/uuid.dart';

import 'accounts.dart';

part 'db.g.dart';

const _uuid = Uuid();

/// UUID v4 baru (id semua baris dibuat di device — syarat sync).
String newId() => _uuid.v4();

/// Epoch milidetik UTC sekarang.
int nowMs() => DateTime.now().millisecondsSinceEpoch;

// ---------------------------------------------------------------------------
// MASTER: products
// ---------------------------------------------------------------------------
@TableIndex(name: 'idx_products_category', columns: {#category})
@TableIndex(name: 'idx_products_name', columns: {#name})
class Products extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get category => text()();
  IntColumn get price => integer()(); // Rp jual
  IntColumn get cost => integer()(); // Rp, fallback HPP bila tanpa BOM
  IntColumn get stock => integer().withDefault(const Constant(0))();
  // pcs barang jadi di rak — BUKAN stok bahan. Boleh minus.
  TextColumn get barcode => text().nullable()();
  IntColumn get isActive => integer().withDefault(const Constant(1))();
  IntColumn get updatedAt => integer()();
  TextColumn get deviceId => text()();
  IntColumn get isDeleted =>
      integer().named('_deleted').withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// MASTER: customers
// ---------------------------------------------------------------------------
@TableIndex(name: 'idx_customers_name', columns: {#name})
class Customers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  IntColumn get points => integer().withDefault(const Constant(0))();
  IntColumn get updatedAt => integer()();
  TextColumn get deviceId => text()();
  IntColumn get isDeleted =>
      integer().named('_deleted').withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// MASTER: promos
// ---------------------------------------------------------------------------
class Promos extends Table {
  TextColumn get id => text()();
  TextColumn get code => text()();
  TextColumn get type => text()(); // 'persen' | 'potongan'
  IntColumn get value => integer()(); // persen 0-100 | Rp potongan
  IntColumn get isActive => integer().withDefault(const Constant(1))();
  IntColumn get updatedAt => integer()();
  TextColumn get deviceId => text()();
  IntColumn get isDeleted =>
      integer().named('_deleted').withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {code},
      ];
}

// ---------------------------------------------------------------------------
// APPEND: sales
// ---------------------------------------------------------------------------
@TableIndex(name: 'idx_sales_date', columns: {#date})
@TableIndex(name: 'idx_sales_code', columns: {#code})
class Sales extends Table {
  TextColumn get id => text()();
  TextColumn get code => text()(); // 'CSZ-YYYYMMDD-0001'
  IntColumn get date => integer()(); // epoch ms UTC
  TextColumn get channel => text()(); // 'dine-in' | 'takeaway' | 'ojol'
  TextColumn get paymentMethod =>
      text()(); // 'tunai' | 'qris' | 'ojol' | 'multi'
  IntColumn get subtotal => integer()();
  IntColumn get discount => integer().withDefault(const Constant(0))();
  IntColumn get tax => integer().withDefault(const Constant(0))();
  IntColumn get serviceCharge => integer().withDefault(const Constant(0))();
  IntColumn get ojolFee => integer().withDefault(const Constant(0))();
  IntColumn get total => integer()();
  IntColumn get paid => integer()();
  IntColumn get change => integer().withDefault(const Constant(0))();
  IntColumn get voided => integer().withDefault(const Constant(0))();
  IntColumn get voidedAt => integer().nullable()();
  TextColumn get shiftId => text().nullable().references(Shifts, #id)();
  // Nullable sejak skema v3 (Fase 6): penjualan tanpa sesi login
  // (DB kosong, gate terkecuali) dicatat employeeId null = "Tanpa login".
  TextColumn get employeeId => text().nullable().references(Employees, #id)();
  TextColumn get customerId => text().nullable().references(Customers, #id)();
  TextColumn get orderId => text().nullable().references(Orders, #id)();
  TextColumn get splitGroupId => text().nullable()();
  IntColumn get updatedAt => integer()();
  TextColumn get deviceId => text()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {code},
      ];
}

// ---------------------------------------------------------------------------
// APPEND: saleLines
// ---------------------------------------------------------------------------
@TableIndex(name: 'idx_sale_lines_sale', columns: {#saleId})
class SaleLines extends Table {
  TextColumn get id => text()();
  TextColumn get saleId => text().references(Sales, #id)();
  TextColumn get productId => text().references(Products, #id)();
  IntColumn get qty => integer()();
  IntColumn get price => integer()(); // snapshot harga jual saat transaksi
  IntColumn get hppPerUnit => integer()(); // snapshot HPP Rp per unit
  IntColumn get discount => integer().withDefault(const Constant(0))();
  IntColumn get updatedAt => integer()();
  TextColumn get deviceId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// APPEND: salePayments — rincian tiap pembayaran dalam satu struk.
// SUM(amount) == sales.paid.
// ---------------------------------------------------------------------------
@TableIndex(name: 'idx_sale_payments_sale', columns: {#saleId})
class SalePayments extends Table {
  TextColumn get id => text()();
  TextColumn get saleId => text().references(Sales, #id)();
  TextColumn get method => text()(); // 'tunai' | 'qris' | 'ojol'
  IntColumn get amount => integer()(); // Rp
  IntColumn get processedAt => integer()();
  IntColumn get updatedAt => integer()();
  TextColumn get deviceId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// MASTER: ingredients (bahan baku)
// stockQty BOLEH NEGATIF (keputusan Dony 15 Nov 2026).
// avgCostMilli = integer mili-Rupiah per satuan dasar (1 Rp = 1000 mili).
// Hanya stockIn yang mengubah avgCostMilli.
// ---------------------------------------------------------------------------
@TableIndex(name: 'idx_ingredients_name', columns: {#name})
class Ingredients extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get unit => text()(); // 'gram' | 'ml' | 'pcs'
  RealColumn get stockQty => real().withDefault(const Constant(0.0))();
  IntColumn get avgCostMilli => integer().withDefault(const Constant(0))();
  IntColumn get totalValue => integer().withDefault(const Constant(0))();
  RealColumn get lowStockAt => real().withDefault(const Constant(0.0))();
  IntColumn get updatedAt => integer()();
  TextColumn get deviceId => text()();
  IntColumn get isDeleted =>
      integer().named('_deleted').withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// MASTER: recipes
// ---------------------------------------------------------------------------
class Recipes extends Table {
  TextColumn get id => text()();
  TextColumn get productId => text().references(Products, #id)();
  IntColumn get updatedAt => integer()();
  TextColumn get deviceId => text()();
  IntColumn get isDeleted =>
      integer().named('_deleted').withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {productId},
      ];
}

// ---------------------------------------------------------------------------
// MASTER: recipeLines
// ---------------------------------------------------------------------------
@TableIndex(name: 'idx_recipe_lines_recipe', columns: {#recipeId})
class RecipeLines extends Table {
  TextColumn get id => text()();
  TextColumn get recipeId => text().references(Recipes, #id)();
  TextColumn get ingredientId => text().references(Ingredients, #id)();
  RealColumn get qty => real()(); // kebutuhan per 1 unit produk, 3 desimal
  IntColumn get updatedAt => integer()();
  TextColumn get deviceId => text()();
  IntColumn get isDeleted =>
      integer().named('_deleted').withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {recipeId, ingredientId},
      ];
}

// ---------------------------------------------------------------------------
// APPEND: stockMoves — jejak audit SEMUA mutasi bahan.
// qty bertanda: + masuk, - keluar, 3 desimal.
// Void TIDAK menghapus baris konsumsi lama: void menulis baris baru
// type 'void-kembali' dengan qty berlawanan.
// ---------------------------------------------------------------------------
@TableIndex(name: 'idx_stock_moves_ingredient', columns: {#ingredientId})
@TableIndex(name: 'idx_stock_moves_date', columns: {#date})
@TableIndex(name: 'idx_stock_moves_ref', columns: {#refType, #refId})
class StockMoves extends Table {
  TextColumn get id => text()();
  TextColumn get ingredientId => text().references(Ingredients, #id)();
  IntColumn get date => integer()();
  TextColumn get type => text()();
  // 'stock-in' | 'konsumsi' | 'wastage' | 'opname' | 'void-kembali'
  RealColumn get qty => real()();
  IntColumn get unitCostMilli => integer()(); // snapshot saat mutasi
  TextColumn get refType => text()(); // 'sale' | 'stock-in' | 'wastage' | 'opname' | 'void'
  TextColumn get refId => text()(); // id sale / opname / dsb
  IntColumn get updatedAt => integer()();
  TextColumn get deviceId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// MASTER: accounts — bagan akun §7.1, di-seed saat onCreate.
// ---------------------------------------------------------------------------
class Accounts extends Table {
  TextColumn get id => text()();
  TextColumn get code => text()();
  TextColumn get name => text()();
  TextColumn get type =>
      text()(); // 'Aset' | 'Kewajiban' | 'Ekuitas' | 'Pendapatan' | 'Beban'
  TextColumn get normal => text()(); // 'D' | 'K'
  IntColumn get updatedAt => integer()();
  TextColumn get deviceId => text()();
  IntColumn get isDeleted =>
      integer().named('_deleted').withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {code},
      ];
}

// ---------------------------------------------------------------------------
// APPEND: journals
// UNIQUE(refType, refId) — idempotensi: satu event = satu jurnal.
// Jurnal TIDAK PERNAH diedit/dihapus.
// ---------------------------------------------------------------------------
@TableIndex(name: 'idx_journals_date', columns: {#date})
@TableIndex(name: 'idx_journals_ref', columns: {#refType, #refId})
class Journals extends Table {
  TextColumn get id => text()();
  IntColumn get date => integer()();
  TextColumn get memo => text()();
  TextColumn get refType => text()();
  TextColumn get refId => text()();
  TextColumn get reversesJournalId => text().nullable()();
  IntColumn get isReversal => integer().withDefault(const Constant(0))();
  IntColumn get updatedAt => integer()();
  TextColumn get deviceId => text()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {refType, refId},
      ];
}

// ---------------------------------------------------------------------------
// APPEND: journalLines
// Satu baris tidak boleh debit > 0 DAN kredit > 0 sekaligus.
// ---------------------------------------------------------------------------
@TableIndex(name: 'idx_journal_lines_journal', columns: {#journalId})
@TableIndex(name: 'idx_journal_lines_account', columns: {#accountCode})
class JournalLines extends Table {
  TextColumn get id => text()();
  TextColumn get journalId => text().references(Journals, #id)();
  TextColumn get accountCode => text().references(Accounts, #code)();
  IntColumn get debit => integer().withDefault(const Constant(0))();
  IntColumn get credit => integer().withDefault(const Constant(0))();
  IntColumn get updatedAt => integer()();
  TextColumn get deviceId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// MASTER: shifts
// ---------------------------------------------------------------------------
class Shifts extends Table {
  TextColumn get id => text()();
  IntColumn get openedAt => integer()();
  IntColumn get closedAt => integer().nullable()();
  TextColumn get status => text()(); // 'open' | 'closed'
  IntColumn get openingFloat => integer()();
  IntColumn get expectedCash => integer().withDefault(const Constant(0))();
  IntColumn get actualCash => integer().withDefault(const Constant(0))();
  IntColumn get cashDiff => integer().withDefault(const Constant(0))();
  // Nullable sejak skema v3 (Fase 6): shift dibuka tanpa sesi login
  // dicatat employeeId null = "Tanpa login".
  TextColumn get employeeId => text().nullable().references(Employees, #id)();
  IntColumn get updatedAt => integer()();
  TextColumn get deviceId => text()();
  IntColumn get isDeleted =>
      integer().named('_deleted').withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// MASTER: pettyCash — kas kecil model imprest (akun 1030).
// ---------------------------------------------------------------------------
@DataClassName('PettyCashRow')
class PettyCash extends Table {
  TextColumn get id => text()();
  TextColumn get shiftId => text().nullable().references(Shifts, #id)();
  IntColumn get date => integer()();
  IntColumn get amount => integer()();
  TextColumn get note => text()();
  TextColumn get employeeId => text().references(Employees, #id)();
  IntColumn get updatedAt => integer()();
  TextColumn get deviceId => text()();
  IntColumn get isDeleted =>
      integer().named('_deleted').withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// MASTER: orders — open bill (belum bayar). BEDA dari sales (sudah bayar).
// ---------------------------------------------------------------------------
class Orders extends Table {
  TextColumn get id => text()();
  TextColumn get tableId => text().nullable().references(ShopTables, #id)();
  TextColumn get status => text()(); // 'open' | 'paid' | 'void'
  TextColumn get channel => text()(); // 'dine-in' | 'takeaway' | 'ojol'
  IntColumn get updatedAt => integer()();
  TextColumn get deviceId => text()();
  IntColumn get isDeleted =>
      integer().named('_deleted').withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// MASTER: orderLines
// ---------------------------------------------------------------------------
@TableIndex(name: 'idx_order_lines_order', columns: {#orderId})
class OrderLines extends Table {
  TextColumn get id => text()();
  TextColumn get orderId => text().references(Orders, #id)();
  TextColumn get productId => text().references(Products, #id)();
  IntColumn get qty => integer()();
  IntColumn get price => integer()(); // snapshot harga saat dipesan
  IntColumn get updatedAt => integer()();
  TextColumn get deviceId => text()();
  IntColumn get isDeleted =>
      integer().named('_deleted').withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// MASTER: tables (meja)
// ---------------------------------------------------------------------------
class ShopTables extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get status => text()(); // 'kosong' | 'terisi' | 'reserved'
  IntColumn get updatedAt => integer()();
  TextColumn get deviceId => text()();
  IntColumn get isDeleted =>
      integer().named('_deleted').withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// MASTER: assets — aset tetap (penyusutan garis lurus).
// Idempotensi penyusutan: jurnal memakai refId 'asset:<id>:<yyyy-MM>'.
// ---------------------------------------------------------------------------
class Assets extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get purchaseDate => integer()();
  IntColumn get cost => integer()();
  IntColumn get residualValue => integer()();
  IntColumn get usefulLifeMonths => integer()();
  IntColumn get accumulatedDepreciation =>
      integer().withDefault(const Constant(0))();
  TextColumn get lastDepreciationMonth => text().nullable()(); // 'yyyy-MM'
  IntColumn get updatedAt => integer()();
  TextColumn get deviceId => text()();
  IntColumn get isDeleted =>
      integer().named('_deleted').withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// APPEND: expenses — beban / OPEX
// ---------------------------------------------------------------------------
@TableIndex(name: 'idx_expenses_date', columns: {#date})
class Expenses extends Table {
  TextColumn get id => text()();
  IntColumn get date => integer()();
  TextColumn get category => text()();
  IntColumn get amount => integer()();
  TextColumn get accountCode => text().references(Accounts, #code)();
  TextColumn get note => text()();
  TextColumn get employeeId => text().nullable().references(Employees, #id)();
  IntColumn get updatedAt => integer()();
  TextColumn get deviceId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// MASTER: employees — PIN 4-6 digit DI-HASH, jangan simpan PIN mentah.
// pinHash kosong ('') = PIN belum diatur (karyawan hasil migrasi/seed).
// Fase 5: gaji pokok — salaryType 'bulanan' | 'harian', baseSalary Rp
// (bulanan = gaji sebulan; harian = tarif per hari hadir). Blueprint
// §10.2 sudah menyebut employees.baseSalary; kolomnya baru ditambahkan
// di Fase 5 (migrasi skema v1 -> v2).
// ---------------------------------------------------------------------------
class Employees extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get role => text()(); // 'owner' | 'manager' | 'kasir'
  TextColumn get pinHash => text()();
  IntColumn get isActive => integer().withDefault(const Constant(1))();
  TextColumn get salaryType =>
      text().withDefault(const Constant('bulanan'))();
  IntColumn get baseSalary => integer().withDefault(const Constant(0))();
  IntColumn get updatedAt => integer()();
  TextColumn get deviceId => text()();
  IntColumn get isDeleted =>
      integer().named('_deleted').withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// APPEND: attendance — absensi PIN (bukan selfie).
// Satu baris per karyawan per hari (UNIQUE employeeId+date); clockOut
// meng-update baris yang sama. Ini satu-satunya tabel APPEND yang
// mengizinkan update barisnya sendiri di hari yang sama.
// ---------------------------------------------------------------------------
@DataClassName('AttendanceRow')
class Attendance extends Table {
  TextColumn get id => text()();
  TextColumn get employeeId => text().references(Employees, #id)();
  IntColumn get date => integer()(); // epoch ms hari itu (tengah malam)
  IntColumn get clockIn => integer().nullable()();
  IntColumn get clockOut => integer().nullable()();
  IntColumn get pinVerified => integer().withDefault(const Constant(0))();
  IntColumn get updatedAt => integer()();
  TextColumn get deviceId => text()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {employeeId, date},
      ];
}

// ---------------------------------------------------------------------------
// APPEND: payrolls
// Fase 5: additions (tambahan manual, Rp) + note (alasan tambahan /
// potongan — ditulis pemilik saat proses gaji, jangan dikarang rumus).
// baseSalary di baris ini = gaji kotor (pokok + tambahan); pokok murni =
// baseSalary - additions. Jurnal tetap lewat AccountingService.paySalary
// (D 5130 / K 1000|1010, idempotent per employee+period).
// ---------------------------------------------------------------------------
class Payrolls extends Table {
  TextColumn get id => text()();
  TextColumn get employeeId => text().references(Employees, #id)();
  TextColumn get period => text()(); // 'yyyy-MM'
  IntColumn get baseSalary => integer()();
  IntColumn get deductions => integer()();
  IntColumn get netPay => integer()();
  IntColumn get additions => integer().withDefault(const Constant(0))();
  TextColumn get note => text().nullable()();
  IntColumn get paidAt => integer().nullable()();
  IntColumn get updatedAt => integer()();
  TextColumn get deviceId => text()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {employeeId, period},
      ];
}

// ---------------------------------------------------------------------------
// MASTER: stockOpnames — sesi opname. Hanya status 'posted' yang
// mem-posting jurnal + stockMoves. Draft boleh diedit; posted final.
// ---------------------------------------------------------------------------
class StockOpnames extends Table {
  TextColumn get id => text()();
  IntColumn get date => integer()();
  TextColumn get employeeId => text().references(Employees, #id)();
  TextColumn get status => text()(); // 'draft' | 'posted'
  TextColumn get note => text().nullable()();
  IntColumn get updatedAt => integer()();
  TextColumn get deviceId => text()();
  IntColumn get isDeleted =>
      integer().named('_deleted').withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// MASTER: stockOpnameLines
// diffQty = actualQty - systemQty, BOLEH NEGATIF.
// ---------------------------------------------------------------------------
@TableIndex(name: 'idx_opname_lines_opname', columns: {#opnameId})
class StockOpnameLines extends Table {
  TextColumn get id => text()();
  TextColumn get opnameId => text().references(StockOpnames, #id)();
  TextColumn get ingredientId => text().references(Ingredients, #id)();
  RealColumn get systemQty => real()();
  RealColumn get actualQty => real()();
  RealColumn get diffQty => real()();
  IntColumn get updatedAt => integer()();
  TextColumn get deviceId => text()();
  IntColumn get isDeleted =>
      integer().named('_deleted').withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// settings — key-value, TANPA kolom sync (hanya lokal per device).
// Key: storeName, capital, demoSeeded ('0'|'1'), migrated ('0'|'1'),
// ojolFeeGoFood, ojolFeeGrabFood, ojolFeeShopeeFood (persen, default '0'),
// ppnRate ('11'), ppnEnabled ('0'|'1'), serviceChargeRate ('0'),
// pb1Rate ('0'), deviceId, rentTotal, rentMonths, rentStartMonth.
// ---------------------------------------------------------------------------
class Settings extends Table {
  TextColumn get id => text()(); // key
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// syncOutbox — antrean sync (engine aktif Fase 7; skema dari awal).
// Operasi 'delete' DILARANG untuk tabel kelas APPEND.
// ---------------------------------------------------------------------------
@DataClassName('SyncOutboxRow')
@TableIndex(name: 'idx_outbox_status', columns: {#status})
@TableIndex(name: 'idx_outbox_created', columns: {#createdAt})
class SyncOutbox extends Table {
  TextColumn get id => text()();
  // Getter Dart bernama `table` karena `tableName` sudah dipakai properti
  // Table milik Drift; kolom SQLite tetap 'tableName' (BLUEPRINT §3.2).
  TextColumn get table => text().named('tableName')();
  TextColumn get rowId => text()();
  TextColumn get operation => text()(); // 'insert' | 'update' | 'delete'
  TextColumn get payload => text()(); // JSON baris lengkap
  TextColumn get status => text()(); // 'pending' | 'done' | 'failed'
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// syncState — watermark pull per tabel (Fase 7).
// ---------------------------------------------------------------------------
@DataClassName('SyncStateRow')
class SyncState extends Table {
  TextColumn get id => text()(); // nama tabel
  IntColumn get lastPulledAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// syncConflicts — log konflik MASTER saat pull (Fase 7, BLUEPRINT §5.3).
// Satu baris = satu baris remote yang KALAH last-write-wins (data lokal
// dipertahankan). Baris TIDAK pernah dihapus otomatis — pemilik bisa
// melihatnya di Pengaturan (Fase 7) / back-office. BUKAN antrean:
// tidak ada kolom status; konflik lama tetap tercatat sebagai jejak.
// ---------------------------------------------------------------------------
@DataClassName('SyncConflictRow')
class SyncConflicts extends Table {
  TextColumn get id => text()();
  // Getter Dart bernama `table` karena `tableName` sudah dipakai properti
  // Table milik Drift; kolom SQLite tetap 'tableName' (seperti syncOutbox).
  TextColumn get table => text().named('tableName')();
  TextColumn get rowId => text()();
  IntColumn get localUpdatedAt => integer()();
  IntColumn get remoteUpdatedAt => integer()();
  TextColumn get localDeviceId => text()();
  TextColumn get remoteDeviceId => text()();
  TextColumn get reason => text()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// AppDatabase
// ---------------------------------------------------------------------------
@DriftDatabase(
  tables: [
    Products,
    Customers,
    Promos,
    Sales,
    SaleLines,
    SalePayments,
    Ingredients,
    Recipes,
    RecipeLines,
    StockMoves,
    Accounts,
    Journals,
    JournalLines,
    Shifts,
    PettyCash,
    Orders,
    OrderLines,
    ShopTables,
    Assets,
    Expenses,
    Employees,
    Attendance,
    Payrolls,
    StockOpnames,
    StockOpnameLines,
    Settings,
    SyncOutbox,
    SyncState,
    SyncConflicts,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  /// Database produksi (file casirz.db di dokumen aplikasi).
  factory AppDatabase.open() =>
      AppDatabase(driftDatabase(name: 'casirz'));

  /// Database in-memory — untuk unit test.
  factory AppDatabase.memory() => AppDatabase(NativeDatabase.memory());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          // Seed bagan akun (30 akun, PERSIS laporan §3.3 + 1110 Fase 4)
          // — bukan seed demo.
          final now = nowMs();
          for (final a in ChartOfAccounts.all) {
            await into(accounts).insert(
              AccountsCompanion.insert(
                id: newId(),
                code: a.code,
                name: a.name,
                type: _typeText(a.type),
                normal: a.normal == Normal.debit ? 'D' : 'K',
                updatedAt: now,
                deviceId: 'local',
              ),
            );
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
        onUpgrade: (m, from, to) async {
          // Fase 5 (skema v2): gaji pokok karyawan + tambahan/alasan
          // payroll. Semua kolom baru punya default / nullable, jadi
          // data v1 yang sudah ada tetap valid.
          if (from < 2) {
            await m.addColumn(employees, employees.salaryType);
            await m.addColumn(employees, employees.baseSalary);
            await m.addColumn(payrolls, payrolls.additions);
            await m.addColumn(payrolls, payrolls.note);
          }
          // Fase 6 (skema v3): sales.employeeId + shifts.employeeId jadi
          // nullable — penjualan/shift tanpa sesi login dicatat null
          // ("Tanpa login"). Nilai lama dipertahankan apa adanya
          // (columnTransformer memetakan kolom ke dirinya sendiri).
          // CATATAN JUJUR: jalur onUpgrade ini hanya dicek lewat
          // `flutter analyze` + onCreate; belum teruji dari DB v2
          // sungguhan — wajib dicek sekali di HP yang sudah punya data
          // v2 sebelum rilis (sama seperti catatan onUpgrade v2 Fase 5).
          if (from < 3) {
            await m.alterTable(
              TableMigration(
                sales,
                columnTransformer: {sales.employeeId: sales.employeeId},
              ),
            );
            await m.alterTable(
              TableMigration(
                shifts,
                columnTransformer: {shifts.employeeId: shifts.employeeId},
              ),
            );
          }
          // Fase 7 (skema v4): tabel log konflik sync (syncConflicts).
          // Baru di v4; DB lama (v1–v3) dibuatkan tabelnya saat upgrade.
          // CATATAN JUJUR: jalur onUpgrade ini hanya dicek lewat
          // `flutter analyze` + onCreate; belum teruji dari DB v3
          // sungguhan — wajib dicek sekali di HP yang sudah punya data
          // v3 sebelum rilis (sama seperti catatan onUpgrade v2/v3).
          if (from < 4) {
            await m.createTable(syncConflicts);
          }
        },
      );

  /// Id device ini (UUID). Dibuat sekali, disimpan di settings.
  /// Dipanggil di luar transaksi bisnis (sebelum transaksi dibuka).
  Future<String> deviceId() async {
    final row = await (select(settings)
          ..where((s) => s.id.equals('deviceId')))
        .getSingleOrNull();
    if (row != null && row.value.isNotEmpty) return row.value;
    final id = newId();
    await into(settings).insertOnConflictUpdate(
      SettingsCompanion.insert(id: 'deviceId', value: id),
    );
    return id;
  }

  /// Baca satu setting (null bila belum ada).
  Future<String?> getSetting(String key) async {
    final row = await (select(settings)..where((s) => s.id.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  /// Tulis satu setting (upsert).
  Future<void> setSetting(String key, String value) async {
    await into(settings).insertOnConflictUpdate(
      SettingsCompanion.insert(id: key, value: value),
    );
  }

  /// Reset data TOTAL (Fase 6, Bagian A1): hapus SEMUA data pengguna —
  /// transaksi, master, karyawan, dan settings — dalam satu transaksi.
  /// Satu-satunya jalan bila satu-satunya owner lupa PIN (tidak ada
  /// master code, tidak ada reset diam-diam). Yang dipertahankan:
  /// bagan akun (seed onCreate, bukan data pengguna) dan `deviceId`
  /// (identitas device untuk sync nanti). Setelah reset, aplikasi
  /// kembali seperti baru (sesi jadi "open", DB kosong).
  Future<void> resetAllData() async {
    await transaction(() async {
      await delete(journalLines).go();
      await delete(journals).go();
      await delete(stockMoves).go();
      await delete(salePayments).go();
      await delete(saleLines).go();
      await delete(sales).go();
      await delete(orderLines).go();
      await delete(orders).go();
      await delete(stockOpnameLines).go();
      await delete(stockOpnames).go();
      await delete(recipeLines).go();
      await delete(recipes).go();
      await delete(expenses).go();
      await delete(payrolls).go();
      await delete(attendance).go();
      await delete(pettyCash).go();
      await delete(shifts).go();
      await delete(assets).go();
      await delete(products).go();
      await delete(ingredients).go();
      await delete(customers).go();
      await delete(promos).go();
      await delete(employees).go();
      await delete(shopTables).go();
      await delete(syncOutbox).go();
      await delete(syncState).go();
      await delete(syncConflicts).go();
      await (delete(settings)..where((s) => s.id.isNotValue('deviceId')))
          .go();
    });
  }
}

/// Nama tipe akun seperti di skema (§3.2): 'Aset' | 'Kewajiban' |
/// 'Ekuitas' | 'Pendapatan' | 'Beban'.
String _typeText(AccountType type) {
  switch (type) {
    case AccountType.aset:
      return 'Aset';
    case AccountType.kewajiban:
      return 'Kewajiban';
    case AccountType.ekuitas:
      return 'Ekuitas';
    case AccountType.pendapatan:
      return 'Pendapatan';
    case AccountType.beban:
      return 'Beban';
  }
}
