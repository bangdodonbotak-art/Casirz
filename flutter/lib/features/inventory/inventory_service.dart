// Casirz ERP — Fase 3 (Modul B Bahan/BOM).
// Service inventory: CRUD bahan baku, edit BOM/resep per menu,
// edit baris opname draft. Tulis stok (stock-in / wastage / opname
// posting) TETAP lewat engine yang sudah ada — Bom (stockIn,
// logWastage) + AccountingService (recordStockIn, recordWastage,
// createOpnameDraft, postOpname) — supaya jurnal + outbox atomik.
//
// Aturan (BLUEPRINT §3.2, §6):
// - Stok minus DIIZINKAN dan DITAMPILKAN (merah + badge "Stok Minus").
//   Tidak ada penolakan transaksi karena stok di mana pun.
// - Hapus bahan HANYA bila tidak dipakai resep mana pun; bila dipakai,
//   DITOLAK dengan pesan jelas (jangan hapus diam-diam). Hapus =
//   tombstone isDeleted=1 (kelas MASTER), bukan hapus fisik.
// - Satuan bahan hanya boleh diubah bila bahan belum dipakai resep
//   mana pun (qty resep memakai satuan itu — mengubahnya merusak HPP).
// - Nama + ambang menipis (lowStockAt) selalu boleh diubah.
// - Baris opname draft boleh diedit; sesi 'posted' final.
import 'package:drift/drift.dart';

import '../../core/db.dart';
import '../../core/money.dart';
import '../../core/sync.dart';

/// Satuan bahan yang diizinkan (BLUEPRINT §3.2).
const List<String> ingredientUnits = ['gram', 'ml', 'pcs'];

/// Satu baris BOM untuk tampil: bahan + qty + biaya baris.
class BomLineView {
  const BomLineView({
    required this.lineId,
    required this.ingredientId,
    required this.ingredientName,
    required this.unit,
    required this.qty,
    required this.avgCostMilli,
  });
  final String lineId;
  final String ingredientId;
  final String ingredientName;
  final String unit;
  final double qty; // kebutuhan per 1 unit produk
  final int avgCostMilli;

  /// Biaya baris (Rp) = qty x avgCost (dibulatkan ke Rp).
  int get lineCostRp => toIntRp(qty * avgCostMilli / 1000);
}

/// Tampilan avgCost: 'Rp150' / 'Rp18,5' (maks 3 desimal, trim nol).
String fmtAvgCostRp(int avgCostMilli) => 'Rp${fmtQty(avgCostMilli / 1000)}';

class InventoryService {
  /// True bila bahan dipakai di resep mana pun (baris tidak terhapus).
  static Future<bool> ingredientInUse(
    AppDatabase db,
    String ingredientId,
  ) async {
    final rows = await (db.select(db.recipeLines)
          ..where(
            (l) =>
                l.ingredientId.equals(ingredientId) &
                l.isDeleted.equals(0),
          ))
        .get();
    return rows.isNotEmpty;
  }

  /// Tambah bahan baru. Mengembalikan id bahan.
  static Future<String> addIngredient(
    AppDatabase db, {
    required String name,
    required String unit,
    double lowStockAt = 0,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Nama bahan tidak boleh kosong.');
    }
    if (!ingredientUnits.contains(unit)) {
      throw ArgumentError(
        'Satuan harus salah satu dari: ${ingredientUnits.join(', ')}.',
      );
    }
    if (lowStockAt < 0) {
      throw ArgumentError('Ambang menipis tidak boleh negatif.');
    }
    final deviceId = await db.deviceId();
    final id = newId();
    await db.transaction(() async {
      final now = nowMs();
      await db.into(db.ingredients).insert(
            IngredientsCompanion.insert(
              id: id,
              name: trimmed,
              unit: unit,
              lowStockAt: Value(round3(lowStockAt)),
              updatedAt: now,
              deviceId: deviceId,
            ),
          );
      await Outbox.write(
        db,
        table: 'ingredients',
        rowId: id,
        operation: 'insert',
        payload: {
          'id': id,
          'name': trimmed,
          'unit': unit,
          'lowStockAt': lowStockAt,
        },
      );
    });
    return id;
  }

  /// Edit bahan: nama + ambang menipis selalu boleh; satuan hanya bila
  /// bahan belum dipakai resep mana pun.
  static Future<void> updateIngredient(
    AppDatabase db, {
    required String ingredientId,
    String? name,
    String? unit,
    double? lowStockAt,
  }) async {
    if (name != null && name.trim().isEmpty) {
      throw ArgumentError('Nama bahan tidak boleh kosong.');
    }
    if (unit != null && !ingredientUnits.contains(unit)) {
      throw ArgumentError(
        'Satuan harus salah satu dari: ${ingredientUnits.join(', ')}.',
      );
    }
    if (lowStockAt != null && lowStockAt < 0) {
      throw ArgumentError('Ambang menipis tidak boleh negatif.');
    }
    await db.transaction(() async {
      final now = nowMs();
      final ing = await (db.select(db.ingredients)
            ..where((i) => i.id.equals(ingredientId)))
          .getSingleOrNull();
      if (ing == null) {
        throw ArgumentError('Bahan tidak ditemukan: $ingredientId');
      }
      if (unit != null &&
          unit != ing.unit &&
          await ingredientInUse(db, ingredientId)) {
        throw StateError(
          'Satuan "${ing.name}" tidak bisa diubah: bahan ini dipakai '
          'di resep — qty resep memakai satuan ${ing.unit}.',
        );
      }
      await (db.update(db.ingredients)
            ..where((i) => i.id.equals(ingredientId)))
          .write(
            IngredientsCompanion(
              name: name == null ? const Value.absent() : Value(name.trim()),
              unit: unit == null ? const Value.absent() : Value(unit),
              lowStockAt: lowStockAt == null
                  ? const Value.absent()
                  : Value(round3(lowStockAt)),
              updatedAt: Value(now),
            ),
          );
      await Outbox.write(
        db,
        table: 'ingredients',
        rowId: ingredientId,
        operation: 'update',
        payload: {
          'id': ingredientId,
          'name': name?.trim() ?? ing.name,
          'unit': unit ?? ing.unit,
          'lowStockAt': lowStockAt ?? ing.lowStockAt,
        },
      );
    });
  }

  /// Hapus bahan — HANYA bila tidak dipakai resep mana pun.
  /// Bila dipakai, throw StateError dengan pesan jelas (jangan hapus
  /// diam-diam). Hapus = tombstone isDeleted=1.
  static Future<void> deleteIngredient(
    AppDatabase db,
    String ingredientId,
  ) async {
    await db.transaction(() async {
      final now = nowMs();
      final ing = await (db.select(db.ingredients)
            ..where((i) => i.id.equals(ingredientId)))
          .getSingleOrNull();
      if (ing == null) {
        throw ArgumentError('Bahan tidak ditemukan: $ingredientId');
      }
      if (await ingredientInUse(db, ingredientId)) {
        final lines = await (db.select(db.recipeLines)
              ..where(
                (l) =>
                    l.ingredientId.equals(ingredientId) &
                    l.isDeleted.equals(0),
              ))
            .get();
        final menuNames = <String>{};
        for (final line in lines) {
          final recipe = await (db.select(db.recipes)
                ..where((r) => r.id.equals(line.recipeId)))
              .getSingleOrNull();
          if (recipe == null) continue;
          final product = await (db.select(db.products)
                ..where((p) => p.id.equals(recipe.productId)))
              .getSingleOrNull();
          if (product != null) menuNames.add(product.name);
        }
        throw StateError(
          'Bahan "${ing.name}" tidak bisa dihapus: masih dipakai di '
          'resep ${menuNames.isEmpty ? 'menu' : menuNames.join(', ')}. '
          'Hapus dulu dari resep tersebut.',
        );
      }
      await (db.update(db.ingredients)
            ..where((i) => i.id.equals(ingredientId)))
          .write(
            IngredientsCompanion(
              isDeleted: const Value(1),
              updatedAt: Value(now),
            ),
          );
      await Outbox.write(
        db,
        table: 'ingredients',
        rowId: ingredientId,
        operation: 'update',
        payload: {'id': ingredientId, '_deleted': 1},
      );
    });
  }

  // ------------------------------------------------------------------
  // Resep / BOM per menu
  // ------------------------------------------------------------------

  /// Baris BOM satu produk (kosong bila tanpa resep).
  static Future<List<BomLineView>> recipeLinesForProduct(
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
    final views = <BomLineView>[];
    for (final line in lines) {
      final ing = await (db.select(db.ingredients)
            ..where((i) => i.id.equals(line.ingredientId)))
          .getSingleOrNull();
      if (ing == null) continue;
      views.add(
        BomLineView(
          lineId: line.id,
          ingredientId: ing.id,
          ingredientName: ing.name,
          unit: ing.unit,
          qty: line.qty,
          avgCostMilli: ing.avgCostMilli,
        ),
      );
    }
    views.sort((a, b) => a.ingredientName.compareTo(b.ingredientName));
    return views;
  }

  /// Tambah baris bahan ke resep produk (buat resep bila belum ada).
  /// Throw bila bahan sudah ada di resep (ubah qty-nya, jangan ganda).
  static Future<String> addRecipeLine(
    AppDatabase db, {
    required String productId,
    required String ingredientId,
    required double qty,
  }) async {
    if (qty <= 0) {
      throw ArgumentError('Qty bahan resep harus > 0.');
    }
    final deviceId = await db.deviceId();
    final lineId = newId();
    await db.transaction(() async {
      final now = nowMs();
      final product = await (db.select(db.products)
            ..where((p) => p.id.equals(productId)))
          .getSingleOrNull();
      if (product == null) {
        throw ArgumentError('Produk tidak ditemukan: $productId');
      }
      final ingredient = await (db.select(db.ingredients)
            ..where(
              (i) =>
                  i.id.equals(ingredientId) & i.isDeleted.equals(0),
            ))
          .getSingleOrNull();
      if (ingredient == null) {
        throw ArgumentError('Bahan tidak ditemukan: $ingredientId');
      }
      var recipe = await (db.select(db.recipes)
            ..where(
              (r) =>
                  r.productId.equals(productId) & r.isDeleted.equals(0),
            ))
          .getSingleOrNull();
      if (recipe == null) {
        final recipeId = newId();
        await db.into(db.recipes).insert(
              RecipesCompanion.insert(
                id: recipeId,
                productId: productId,
                updatedAt: now,
                deviceId: deviceId,
              ),
            );
        await Outbox.write(
          db,
          table: 'recipes',
          rowId: recipeId,
          operation: 'insert',
          payload: {'id': recipeId, 'productId': productId},
        );
        recipe = await (db.select(db.recipes)
              ..where((r) => r.id.equals(recipeId)))
            .getSingle();
      }
      final existing = await (db.select(db.recipeLines)
            ..where(
              (l) =>
                  l.recipeId.equals(recipe!.id) &
                  l.ingredientId.equals(ingredientId) &
                  l.isDeleted.equals(0),
            ))
          .getSingleOrNull();
      if (existing != null) {
        throw StateError(
          'Bahan "${ingredient.name}" sudah ada di resep ini — '
          'ubah qty-nya, jangan tambah baris baru.',
        );
      }
      await db.into(db.recipeLines).insert(
            RecipeLinesCompanion.insert(
              id: lineId,
              recipeId: recipe.id,
              ingredientId: ingredientId,
              qty: round3(qty),
              updatedAt: now,
              deviceId: deviceId,
            ),
          );
      await Outbox.write(
        db,
        table: 'recipe_lines',
        rowId: lineId,
        operation: 'insert',
        payload: {
          'id': lineId,
          'recipeId': recipe.id,
          'ingredientId': ingredientId,
          'qty': qty,
        },
      );
    });
    return lineId;
  }

  /// Ubah qty satu baris resep.
  static Future<void> updateRecipeLineQty(
    AppDatabase db, {
    required String lineId,
    required double qty,
  }) async {
    if (qty <= 0) {
      throw ArgumentError('Qty bahan resep harus > 0.');
    }
    await db.transaction(() async {
      final now = nowMs();
      final line = await (db.select(db.recipeLines)
            ..where((l) => l.id.equals(lineId)))
          .getSingleOrNull();
      if (line == null) {
        throw ArgumentError('Baris resep tidak ditemukan: $lineId');
      }
      await (db.update(db.recipeLines)
            ..where((l) => l.id.equals(lineId)))
          .write(
            RecipeLinesCompanion(
              qty: Value(round3(qty)),
              updatedAt: Value(now),
            ),
          );
      await Outbox.write(
        db,
        table: 'recipe_lines',
        rowId: lineId,
        operation: 'update',
        payload: {'id': lineId, 'qty': qty},
      );
    });
  }

  /// Hapus satu baris resep (tombstone — resepnya sendiri tetap ada;
  /// produk tanpa baris = "Tanpa resep" di UI).
  static Future<void> removeRecipeLine(AppDatabase db, String lineId) async {
    await db.transaction(() async {
      final now = nowMs();
      final line = await (db.select(db.recipeLines)
            ..where((l) => l.id.equals(lineId)))
          .getSingleOrNull();
      if (line == null) {
        throw ArgumentError('Baris resep tidak ditemukan: $lineId');
      }
      await (db.update(db.recipeLines)
            ..where((l) => l.id.equals(lineId)))
          .write(
            RecipeLinesCompanion(
              isDeleted: const Value(1),
              updatedAt: Value(now),
            ),
          );
      await Outbox.write(
        db,
        table: 'recipe_lines',
        rowId: lineId,
        operation: 'update',
        payload: {'id': lineId, '_deleted': 1},
      );
    });
  }

  // ------------------------------------------------------------------
  // Opname draft
  // ------------------------------------------------------------------

  /// Ubah hitung fisik satu baris opname draft (selisih dihitung ulang).
  /// Throw bila sesi sudah 'posted' (final, tidak bisa diubah).
  static Future<void> updateOpnameLine(
    AppDatabase db, {
    required String lineId,
    required double actualQty,
  }) async {
    if (actualQty < 0) {
      throw ArgumentError('Hitung fisik tidak boleh negatif.');
    }
    await db.transaction(() async {
      final now = nowMs();
      final line = await (db.select(db.stockOpnameLines)
            ..where((l) => l.id.equals(lineId)))
          .getSingleOrNull();
      if (line == null) {
        throw ArgumentError('Baris opname tidak ditemukan: $lineId');
      }
      final opname = await (db.select(db.stockOpnames)
            ..where((o) => o.id.equals(line.opnameId)))
          .getSingle();
      if (opname.status != 'draft') {
        throw StateError(
          'Opname sudah diposting — tidak bisa diubah.',
        );
      }
      final actual = round3(actualQty);
      await (db.update(db.stockOpnameLines)
            ..where((l) => l.id.equals(lineId)))
          .write(
            StockOpnameLinesCompanion(
              actualQty: Value(actual),
              diffQty: Value(round3(actual - line.systemQty)),
              updatedAt: Value(now),
            ),
          );
    });
  }

  /// Alasan wastage dari memo jurnal (jurnal 'wastage' menyimpan
  /// memo 'Wastage: ' + alasan). Null bila jurnal tidak ditemukan.
  static Future<String?> wastageReason(
    AppDatabase db,
    String moveId,
  ) async {
    final journal = await (db.select(db.journals)
          ..where(
            (j) => j.refType.equals('wastage') & j.refId.equals(moveId),
          ))
        .getSingleOrNull();
    if (journal == null) return null;
    const prefix = 'Wastage: ';
    return journal.memo.startsWith(prefix)
        ? journal.memo.substring(prefix.length)
        : journal.memo;
  }
}
