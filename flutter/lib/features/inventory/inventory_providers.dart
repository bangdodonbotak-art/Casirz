// Casirz ERP — Fase 3 (Modul B Bahan/BOM).
// Riverpod providers inventory: bahan, menu + BOM, riwayat mutasi,
// sesi opname. UI hanya baca lewat provider ini; tulis lewat
// InventoryService / AccountingService.
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/bom.dart';
import '../../core/db.dart';
import '../pos/pos_providers.dart';
import 'inventory_service.dart';

/// Daftar bahan (tidak terhapus), urut nama.
final ingredientsProvider = StreamProvider<List<Ingredient>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.ingredients)
        ..where((i) => i.isDeleted.equals(0))
        ..orderBy([(i) => OrderingTerm.asc(i.name)]))
      .watch();
});

/// Menu aktif (tidak terhapus), urut kategori + nama.
final inventoryProductsProvider = StreamProvider<List<Product>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.products)
        ..where((p) => p.isActive.equals(1) & p.isDeleted.equals(0))
        ..orderBy([
          (p) => OrderingTerm.asc(p.category),
          (p) => OrderingTerm.asc(p.name),
        ]))
      .watch();
});

/// Baris BOM satu produk.
final recipeLinesProvider =
    FutureProvider.family<List<BomLineView>, String>((ref, productId) async {
  final db = ref.watch(databaseProvider);
  return InventoryService.recipeLinesForProduct(db, productId);
});

/// HPP estimasi satu produk (sama dengan yang tampil di kasir —
/// Bom.computeHPP baca-saja; angka final selalu dihitung engine di
/// dalam transaksi penjualan).
final inventoryHppProvider = FutureProvider.family<int, String>(
  (ref, productId) async {
    final db = ref.watch(databaseProvider);
    return Bom.computeHPP(db, productId, 1);
  },
);

/// Riwayat mutasi bahan satu jenis ('stock-in' | 'wastage' | semua),
/// terbaru dulu.
final stockMovesProvider =
    FutureProvider.family<List<StockMove>, String>((ref, type) async {
  final db = ref.watch(databaseProvider);
  final query = db.select(db.stockMoves)
    ..orderBy([(m) => OrderingTerm.desc(m.date)]);
  if (type != 'semua') {
    query.where((m) => m.type.equals(type));
  }
  return query.get();
});

/// Daftar sesi opname, terbaru dulu.
final opnamesProvider = StreamProvider<List<StockOpname>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.stockOpnames)
        ..where((o) => o.isDeleted.equals(0))
        ..orderBy([(o) => OrderingTerm.desc(o.date)]))
      .watch();
});

/// Baris satu sesi opname.
final opnameLinesProvider =
    FutureProvider.family<List<StockOpnameLine>, String>(
  (ref, opnameId) async {
    final db = ref.watch(databaseProvider);
    return (db.select(db.stockOpnameLines)
          ..where((l) => l.opnameId.equals(opnameId)))
        .get();
  },
);

/// Nama bahan dari id (untuk riwayat mutasi / baris opname).
final ingredientNameProvider =
    FutureProvider.family<String, String>((ref, ingredientId) async {
  final db = ref.watch(databaseProvider);
  final ing = await (db.select(db.ingredients)
        ..where((i) => i.id.equals(ingredientId)))
      .getSingleOrNull();
  return ing?.name ?? '-';
});

/// Versi lokal untuk refresh manual setelah tulis (stream bahan sudah
/// live, tapi FutureProvider resep/riwayat perlu di-refresh).
final inventoryVersionProvider = StateProvider<int>((ref) => 0);
