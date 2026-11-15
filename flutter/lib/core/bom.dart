// Casirz ERP — Fase 1 Core Engine.
// BOM + HPP + moving average cost (BLUEPRINT-FLUTTER.md §4, §5.1).
//
// Aturan beku:
// - `avgCostMilli` = integer mili-Rupiah per satuan dasar (1 Rp = 1000 mili).
// - HANYA `stockIn` yang mengubah `avgCostMilli` (dan `totalValue`).
//   Konsumsi / wastage / opname TIDAK PERNAH mengubah `avgCostMilli` —
//   mereka hanya mengurangi `stockQty` dan `totalValue` sebesar
//   qty x avgCostMilli / 1000 (dibulatkan ke integer Rp per mutasi).
// - HPP satu unit produk (mili-Rp) = jumlah (qtyBahan x avgCostMilliBahan).
//   `saleLines.hppPerUnit` (integer Rp) = round(hppMilli / 1000).
//   Pembulatan HPP dilakukan PER BARIS penjualan, bukan per bahan.
// - Stok minus DIIZINKAN (keputusan Dony 15 Nov 2026): `deductBOM`
//   TIDAK PERNAH throw/reject karena stok kurang. `totalValue` boleh
//   ikut negatif apa adanya — jangan di-clamp ke 0.
//
// Temuan ensemble (Groq Qwen, diterapkan):
// - Jurnal HPP memakai JUMLAH hppPerUnit baris yang sudah dibulatkan
//   (bukan total yang dibulatkan terpisah) — supaya jumlah baris selalu
//   sama dengan jurnal. Itu dijamin `SaleService`, bukan di sini.
// - `stockIn` dengan stok lama negatif: avg baru hanya dihitung bila
//   stok hasil > 0; bila stok hasil masih <= 0, `avgCostMilli` lama
//   DIPERTAHANKAN (bukan di-reset ke 0 — reset ke 0 akan membuat HPP
//   penjualan berikutnya Rp0 dan laba rugi jadi palsu).
// - `stockIn` menolak qty <= 0 (pembagi nol di rumus rata-rata).
import 'package:drift/drift.dart';

import 'db.dart';
import 'money.dart';

class Bom {
  /// Estimasi baca-saja untuk UI. BUKAN angka final.
  /// Total HPP (Rp) untuk [qty] unit produk.
  static Future<int> computeHPP(
    AppDatabase db,
    String productId,
    int qty,
  ) async {
    if (qty <= 0) return 0;
    final perUnit = await _hppPerUnit(db, productId);
    return perUnit * qty;
  }

  /// HPP final — WAJIB dipanggil di dalam Transaction penjualan.
  /// Total HPP (Rp) untuk [qty] unit produk.
  static Future<int> computeHPPInTx(
    AppDatabase db,
    String productId,
    int qty,
  ) async {
    if (qty <= 0) return 0;
    final perUnit = await _hppPerUnit(db, productId);
    return perUnit * qty;
  }

  /// HPP per 1 unit (Rp, dibulatkan). Produk tanpa BOM memakai
  /// `products.cost` sebagai HPP.
  static Future<int> hppPerUnit(AppDatabase db, String productId) =>
      _hppPerUnit(db, productId);

  static Future<int> _hppPerUnit(AppDatabase db, String productId) async {
    final product = await (db.select(db.products)
          ..where((p) => p.id.equals(productId)))
        .getSingleOrNull();
    if (product == null) {
      throw ArgumentError('Produk tidak ditemukan: $productId');
    }
    final recipe = await (db.select(db.recipes)
          ..where(
            (r) => r.productId.equals(productId) & r.isDeleted.equals(0),
          ))
        .getSingleOrNull();
    if (recipe == null) {
      // Produk tanpa BOM — HPP = products.cost.
      return product.cost;
    }
    final lines = await (db.select(db.recipeLines)
          ..where(
            (l) => l.recipeId.equals(recipe.id) & l.isDeleted.equals(0),
          ))
        .get();
    if (lines.isEmpty) {
      // Resep ada tapi semua baris dihapus = produk tanpa resep.
      return product.cost;
    }
    var hppMilli = 0;
    for (final line in lines) {
      final ingredient = await (db.select(db.ingredients)
            ..where((i) => i.id.equals(line.ingredientId)))
          .getSingleOrNull();
      if (ingredient == null) {
        throw StateError(
          'Bahan resep tidak ditemukan: ${line.ingredientId} '
          '(produk $productId).',
        );
      }
      // qty (3 desimal) x avgCostMilli -> mili-Rp; dibulatkan per bahan
      // ke mili-Rp utuh supaya tidak ada sisa pecahan.
      hppMilli += (line.qty * ingredient.avgCostMilli).round();
    }
    return toIntRp(hppMilli / 1000);
  }

  /// True bila produk punya resep (BOM) dengan minimal satu baris aktif.
  /// Baris resep yang dihapus (tombstone) tidak dihitung — produk yang
  /// semua baris resepnya dihapus berperilaku sebagai produk tanpa BOM
  /// (HPP = products.cost, potong products.stock).
  static Future<bool> hasRecipe(AppDatabase db, String productId) async {
    final recipe = await (db.select(db.recipes)
          ..where(
            (r) => r.productId.equals(productId) & r.isDeleted.equals(0),
          ))
        .getSingleOrNull();
    if (recipe == null) return false;
    final lines = await (db.select(db.recipeLines)
          ..where(
            (l) => l.recipeId.equals(recipe.id) & l.isDeleted.equals(0),
          ))
        .get();
    return lines.isNotEmpty;
  }

  /// Id bahan dalam resep produk (kosong bila tanpa BOM).
  static Future<List<String>> recipeIngredientIds(
    AppDatabase db,
    String productId,
  ) async {
    final recipe = await (db.select(db.recipes)
          ..where(
            (r) => r.productId.equals(productId) & r.isDeleted.equals(0),
          ))
        .getSingleOrNull();
    if (recipe == null) return [];
    final lines = await (db.select(db.recipeLines)
          ..where(
            (l) => l.recipeId.equals(recipe.id) & l.isDeleted.equals(0),
          ))
        .get();
    return lines.map((l) => l.ingredientId).toList();
  }

  /// Potong bahan per BOM + tulis stockMoves type 'konsumsi'.
  /// TIDAK PERNAH throw/reject karena stok kurang — stok BOLEH MINUS.
  /// Produk tanpa BOM: tidak melakukan apa-apa (pemanggil mengurangi
  /// `products.stock`).
  static Future<void> deductBOM(
    AppDatabase db, {
    required String productId,
    required int qty,
    required String saleId,
  }) async {
    if (qty <= 0) {
      throw ArgumentError('qty harus > 0 (deductBOM $productId).');
    }
    final recipe = await (db.select(db.recipes)
          ..where(
            (r) => r.productId.equals(productId) & r.isDeleted.equals(0),
          ))
        .getSingleOrNull();
    if (recipe == null) return;
    final lines = await (db.select(db.recipeLines)
          ..where(
            (l) => l.recipeId.equals(recipe.id) & l.isDeleted.equals(0),
          ))
        .get();
    final now = nowMs();
    final deviceId = await _deviceId(db);
    for (final line in lines) {
      final need = round3(line.qty * qty);
      if (need == 0) continue;
      final ingredient = await (db.select(db.ingredients)
            ..where((i) => i.id.equals(line.ingredientId)))
          .getSingle();
      final valueDelta = toIntRp(need * ingredient.avgCostMilli / 1000);
      await (db.update(db.ingredients)
            ..where((i) => i.id.equals(ingredient.id)))
          .write(
            IngredientsCompanion(
              stockQty: Value(round3(ingredient.stockQty - need)),
              totalValue: Value(ingredient.totalValue - valueDelta),
              updatedAt: Value(now),
            ),
          );
      await db.into(db.stockMoves).insert(
            StockMovesCompanion.insert(
              id: newId(),
              ingredientId: ingredient.id,
              date: now,
              type: 'konsumsi',
              qty: -need,
              unitCostMilli: ingredient.avgCostMilli,
              refType: 'sale',
              refId: saleId,
              updatedAt: now,
              deviceId: deviceId,
            ),
          );
    }
  }

  /// Beli bahan: tambah stokQty, hitung ulang avgCostMilli + totalValue,
  /// tulis stockMoves type 'stock-in'.
  /// Jurnal D 1100 / K 1000 (tunai) atau K 2000 (utang) ditulis PEMANGGIL
  /// dalam transaksi yang sama (bukan di sini).
  /// Mengembalikan id stockMove yang dibuat (dipakai sebagai refId jurnal).
  static Future<String> stockIn(
    AppDatabase db, {
    required String ingredientId,
    required double qty,
    required int totalCost,
    String? refId,
  }) async {
    if (qty <= 0) {
      throw ArgumentError('qty stock-in harus > 0.');
    }
    if (totalCost < 0) {
      throw ArgumentError('totalCost stock-in tidak boleh negatif.');
    }
    final ingredient = await (db.select(db.ingredients)
          ..where((i) => i.id.equals(ingredientId)))
        .getSingleOrNull();
    if (ingredient == null) {
      throw ArgumentError('Bahan tidak ditemukan: $ingredientId');
    }
    final newStock = round3(ingredient.stockQty + qty);
    final newTotalValue = ingredient.totalValue + totalCost;
    // Rata-rata baru hanya bila stok hasil > 0. Bila stok hasil masih
    // <= 0 (stok lama sangat minus), avg lama dipertahankan — lihat
    // catatan di header file.
    final newAvg = newStock > 0
        ? ((newTotalValue * 1000) / newStock).round()
        : ingredient.avgCostMilli;
    final now = nowMs();
    final deviceId = await _deviceId(db);
    await (db.update(db.ingredients)
          ..where((i) => i.id.equals(ingredient.id)))
        .write(
          IngredientsCompanion(
            stockQty: Value(newStock),
            avgCostMilli: Value(newAvg),
            totalValue: Value(newTotalValue),
            updatedAt: Value(now),
          ),
        );
    final moveId = newId();
    await db.into(db.stockMoves).insert(
          StockMovesCompanion.insert(
            id: moveId,
            ingredientId: ingredient.id,
            date: now,
            type: 'stock-in',
            qty: round3(qty),
            // Snapshot harga beli per satuan (bukan avg baru).
            unitCostMilli: toIntRp(totalCost * 1000 / qty),
            refType: 'stock-in',
            refId: refId ?? moveId,
            updatedAt: now,
            deviceId: deviceId,
          ),
        );
    return moveId;
  }

  /// Susu tumpah dsb: kurangi stokQty, tulis stockMoves type 'wastage'.
  /// Jurnal D 5210 / K 1100 ditulis PEMANGGIL dalam transaksi yang sama.
  /// Mengembalikan id stockMove + nilai Rp wastage (untuk jurnal).
  /// [WastageResult.moveId] adalah id BARIS stockMoves yang sebenarnya
  /// (Fase 4 — sebelumnya moveId hanyalah refId jurnal; baris stockMoves
  /// dibuat adjustStock dengan id lain, sehingga outbox memakai id yang
  /// bukan id baris).
  static Future<WastageResult> logWastage(
    AppDatabase db, {
    required String ingredientId,
    required double qty,
    required String reason,
  }) async {
    if (qty <= 0) {
      throw ArgumentError('qty wastage harus > 0.');
    }
    final moveId = newId();
    final valueDelta = await adjustStock(
      db,
      ingredientId: ingredientId,
      qtyDelta: -round3(qty),
      type: 'wastage',
      refType: 'wastage',
      refId: moveId,
      rowId: moveId,
    );
    // valueDelta negatif (stok berkurang) -> kembalikan nilai positif.
    return WastageResult(moveId: moveId, amount: -valueDelta);
  }

  /// Penyesuaian stok generik (dipakai wastage, opname, void-kembali).
  /// [qtyDelta] bertanda (+ masuk, - keluar). Mengembalikan perubahan
  /// nilai persediaan (Rp, bertanda sama dengan qtyDelta).
  /// [unitCostMilliOverride]: bila diisi, perubahan nilai memakai snapshot
  /// itu (void-kembali memakai unitCostMilli SAAT penjualan, bukan avg
  /// saat ini — supaya totalValue kembali persis seperti sebelum jual).
  /// [rowId]: bila diisi, dipakai sebagai id baris stockMoves (dipakai
  /// logWastage supaya id yang dikembalikan = id baris sebenarnya).
  static Future<int> adjustStock(
    AppDatabase db, {
    required String ingredientId,
    required double qtyDelta,
    required String type,
    required String refType,
    required String refId,
    int? unitCostMilliOverride,
    String? rowId,
  }) async {
    final ingredient = await (db.select(db.ingredients)
          ..where((i) => i.id.equals(ingredientId)))
        .getSingleOrNull();
    if (ingredient == null) {
      throw ArgumentError('Bahan tidak ditemukan: $ingredientId');
    }
    final unitCost = unitCostMilliOverride ?? ingredient.avgCostMilli;
    final valueDelta = toIntRp(qtyDelta * unitCost / 1000);
    final now = nowMs();
    final deviceId = await _deviceId(db);
    await (db.update(db.ingredients)
          ..where((i) => i.id.equals(ingredient.id)))
        .write(
          IngredientsCompanion(
            stockQty: Value(round3(ingredient.stockQty + qtyDelta)),
            totalValue: Value(ingredient.totalValue + valueDelta),
            updatedAt: Value(now),
          ),
        );
    await db.into(db.stockMoves).insert(
          StockMovesCompanion.insert(
            id: rowId ?? newId(),
            ingredientId: ingredient.id,
            date: now,
            type: type,
            qty: round3(qtyDelta),
            unitCostMilli: unitCost,
            refType: refType,
            refId: refId,
            updatedAt: now,
            deviceId: deviceId,
          ),
        );
    return valueDelta;
  }

  static Future<String> _deviceId(AppDatabase db) async {
    final row = await (db.select(db.settings)
          ..where((s) => s.id.equals('deviceId')))
        .getSingleOrNull();
    if (row != null && row.value.isNotEmpty) return row.value;
    final id = newId();
    await db.into(db.settings).insertOnConflictUpdate(
          SettingsCompanion.insert(id: 'deviceId', value: id),
        );
    return id;
  }
}

/// Hasil [Bom.logWastage]: id stockMove + nilai Rp wastage.
class WastageResult {
  const WastageResult({required this.moveId, required this.amount});
  final String moveId;
  final int amount; // Rp, positif
}
