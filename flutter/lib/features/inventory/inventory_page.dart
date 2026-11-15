// Casirz ERP — Fase 3 (Modul B Bahan/BOM).
// Halaman Bahan Baku: 5 tab (Bahan, Resep, Belanja, Wastage, Opname).
// Bahasa Indonesia, emerald-600, font sistem, touch >= 44px,
// angka uang tabularFigures (MoneyText), stok minus merah + badge.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db.dart';
import '../../core/money.dart';
import '../../shared/widgets/common.dart';
import '../../shared/widgets/money_text.dart';
import '../../shared/widgets/stock_qty_text.dart';
import '../pos/pos_providers.dart';
import 'inventory_providers.dart';
import 'inventory_service.dart';
import 'opname_tab.dart';
import 'recipes_tab.dart';
import 'stock_forms_tab.dart';

/// Parse qty desimal (terima koma maupun titik). Null bila tidak valid.
double? parseQty(String v) {
  final t = v.trim().replaceAll(',', '.');
  if (t.isEmpty) return null;
  return double.tryParse(t);
}

/// Parse Rupiah (hanya digit). Null bila kosong / tidak valid.
int? parseRp(String v) {
  final digits = v.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.isEmpty) return null;
  return int.tryParse(digits);
}

void showErrorSnack(BuildContext context, Object e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('$e')),
  );
}

void showOkSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

class InventoryPage extends ConsumerWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bahan Baku'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Bahan'),
              Tab(text: 'Resep'),
              Tab(text: 'Belanja'),
              Tab(text: 'Wastage'),
              Tab(text: 'Opname'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _IngredientsTab(),
            RecipesTab(),
            StockInTab(),
            WastageTab(),
            OpnameTab(),
          ],
        ),
      ),
    );
  }
}

enum _StockFilter { semua, menipis, minus }

class _IngredientsTab extends ConsumerStatefulWidget {
  const _IngredientsTab();

  @override
  ConsumerState<_IngredientsTab> createState() => _IngredientsTabState();
}

class _IngredientsTabState extends ConsumerState<_IngredientsTab> {
  final _searchCtrl = TextEditingController();
  var _query = '';
  var _filter = _StockFilter.semua;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ingredientsAsync = ref.watch(ingredientsProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Cari bahan',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => setState(() => _query = v.toLowerCase()),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: () => showIngredientDialog(context, ref),
                icon: const Icon(Icons.add),
                label: const Text('Tambah'),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            children: [
              _filterChip('Semua', _StockFilter.semua),
              const SizedBox(width: 8),
              _filterChip('Menipis', _StockFilter.menipis),
              const SizedBox(width: 8),
              _filterChip('Minus', _StockFilter.minus),
            ],
          ),
        ),
        Expanded(
          child: ingredientsAsync.when(
            data: (ingredients) {
              var list = ingredients;
              if (_query.isNotEmpty) {
                list = list
                    .where((i) => i.name.toLowerCase().contains(_query))
                    .toList();
              }
              switch (_filter) {
                case _StockFilter.menipis:
                  list = list
                      .where(
                        (i) =>
                            i.stockQty >= 0 &&
                            i.lowStockAt > 0 &&
                            i.stockQty <= i.lowStockAt,
                      )
                      .toList();
                case _StockFilter.minus:
                  list = list.where((i) => i.stockQty < 0).toList();
                case _StockFilter.semua:
                  break;
              }
              if (list.isEmpty) {
                return const EmptyState(
                  message: 'Tidak ada bahan yang cocok.',
                );
              }
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (ctx, i) {
                  final ing = list[i];
                  final menipis = ing.stockQty >= 0 &&
                      ing.lowStockAt > 0 &&
                      ing.stockQty <= ing.lowStockAt;
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  ing.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium,
                                ),
                              ),
                              if (ing.stockQty < 0)
                                const StokMinusBadge(),
                              if (menipis) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade600,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'Menipis',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Stok'),
                              StockQtyText(
                                ing.stockQty,
                                unit: ing.unit,
                                lowStockAt: ing.lowStockAt,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Harga rata-rata'),
                              Text(
                                '${fmtAvgCostRp(ing.avgCostMilli)} / ${ing.unit}',
                                style: const TextStyle(
                                  fontFeatures: [
                                    FontFeature.tabularFigures(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Nilai persediaan'),
                              MoneyText(ing.totalValue),
                            ],
                          ),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Ambang menipis'),
                              Text(
                                ing.lowStockAt > 0
                                    ? '${fmtQty(ing.lowStockAt)} ${ing.unit}'
                                    : '-',
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                onPressed: () => _editIngredient(context, ing),
                                icon: const Icon(Icons.edit),
                                label: const Text('Edit'),
                              ),
                              TextButton.icon(
                                onPressed: () =>
                                    _deleteIngredient(context, ing),
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                label: const Text(
                                  'Hapus',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (e, _) => EmptyState(message: 'Gagal memuat bahan: $e'),
          ),
        ),
      ],
    );
  }

  Widget _filterChip(String label, _StockFilter value) {
    final selected = _filter == value;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => setState(() => _filter = value),
    );
  }

  Future<void> _deleteIngredient(
    BuildContext context,
    Ingredient ing,
  ) async {
    final ok = await showConfirmDialog(
      context,
      title: 'Hapus bahan?',
      message: 'Bahan "${ing.name}" akan dihapus. '
          'Bila bahan ini dipakai resep, penghapusan ditolak.',
      actionLabel: 'Ya, hapus',
    );
    if (!ok || !context.mounted) return;
    try {
      final db = ref.read(databaseProvider);
      await InventoryService.deleteIngredient(db, ing.id);
      if (context.mounted) {
        showOkSnack(context, 'Bahan "${ing.name}" dihapus.');
      }
    } catch (e) {
      if (context.mounted) showErrorSnack(context, e);
    }
  }

  Future<void> _editIngredient(
    BuildContext context,
    Ingredient ing,
  ) async {
    await showIngredientDialog(context, ref, ingredient: ing);
  }
}

/// Dialog tambah / edit bahan (nama, satuan, ambang menipis).
/// Satuan bahan yang sudah dipakai resep tidak bisa diubah (service
/// menolak dengan pesan jelas).
Future<void> showIngredientDialog(
  BuildContext context,
  WidgetRef ref, {
  Ingredient? ingredient,
}) async {
  final isEdit = ingredient != null;
  final nameCtrl = TextEditingController(text: ingredient?.name ?? '');
  final lowCtrl = TextEditingController(
    text: ingredient == null
        ? ''
        : (ingredient.lowStockAt > 0 ? fmtQty(ingredient.lowStockAt) : ''),
  );
  var unit = ingredient?.unit ?? 'gram';
  final db = ref.read(databaseProvider);
  final used = ingredient == null
      ? false
      : await InventoryService.ingredientInUse(db, ingredient.id);

  if (!context.mounted) return;
  await showDialog<void>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: Text(isEdit ? 'Edit Bahan' : 'Tambah Bahan'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nama bahan',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: unit,
                decoration: const InputDecoration(
                  labelText: 'Satuan',
                  border: OutlineInputBorder(),
                ),
                items: ingredientUnits
                    .map(
                      (u) => DropdownMenuItem(value: u, child: Text(u)),
                    )
                    .toList(),
                onChanged: used
                    ? null
                    : (v) {
                        if (v != null) setState(() => unit = v);
                      },
              ),
              if (used)
                const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Text(
                    'Satuan tidak bisa diubah: bahan ini dipakai di resep.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              const SizedBox(height: 12),
              TextField(
                controller: lowCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Ambang menipis (opsional)',
                  hintText: 'mis. 500',
                  border: OutlineInputBorder(),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text(
                  'Stok awal 0. Isi stok lewat tab Belanja (stock-in).',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () async {
              try {
                final low = lowCtrl.text.trim().isEmpty
                    ? 0.0
                    : parseQty(lowCtrl.text);
                if (low == null) {
                  throw ArgumentError('Ambang menipis tidak valid.');
                }
                if (isEdit) {
                  await InventoryService.updateIngredient(
                    db,
                    ingredientId: ingredient.id,
                    name: nameCtrl.text,
                    unit: used ? null : unit,
                    lowStockAt: low,
                  );
                } else {
                  await InventoryService.addIngredient(
                    db,
                    name: nameCtrl.text,
                    unit: unit,
                    lowStockAt: low,
                  );
                }
                if (ctx.mounted) {
                  Navigator.of(ctx).pop();
                  showOkSnack(
                    context,
                    isEdit ? 'Bahan diperbarui.' : 'Bahan ditambahkan.',
                  );
                }
              } catch (e) {
                if (ctx.mounted) showErrorSnack(ctx, e);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    ),
  );
}
