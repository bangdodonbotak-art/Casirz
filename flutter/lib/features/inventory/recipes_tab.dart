// Casirz ERP — Fase 3 (Modul B Bahan/BOM).
// Tab Resep: daftar menu + BOM-nya (bahan + qty + biaya baris),
// HPP total per menu (Bom.computeHPP — sama dengan yang tampil di
// kasir), edit BOM (tambah/ubah/hapus baris bahan). Produk tanpa BOM
// tampil jelas "Tanpa resep — HPP dari harga cost".
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db.dart';
import '../../core/money.dart';
import '../../shared/widgets/common.dart';
import '../../shared/widgets/money_text.dart';
import '../pos/pos_providers.dart';
import 'inventory_page.dart';
import 'inventory_providers.dart';
import 'inventory_service.dart';

class RecipesTab extends ConsumerWidget {
  const RecipesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(inventoryProductsProvider);
    return productsAsync.when(
      data: (products) {
        if (products.isEmpty) {
          return const EmptyState(
            message: 'Belum ada menu. Isi Data Demo Warkop di Pengaturan.',
          );
        }
        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (ctx, i) {
            final product = products[i];
            return _RecipeCard(product: product);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => EmptyState(message: 'Gagal memuat menu: $e'),
    );
  }
}

class _RecipeCard extends ConsumerWidget {
  const _RecipeCard({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final linesAsync = ref.watch(recipeLinesProvider(product.id));
    final hppAsync = ref.watch(inventoryHppProvider(product.id));
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ExpansionTile(
        title: Text(product.name),
        subtitle: Text(
          '${product.category} • Jual ${fmt(product.price)}',
        ),
        children: [
          linesAsync.when(
            data: (lines) {
              if (lines.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Tanpa resep — HPP dari harga cost '
                                '(${fmt(product.cost)}).',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      _editButton(context, ref, lines),
                    ],
                  ),
                );
              }
              final totalLineCost =
                  lines.fold<int>(0, (s, l) => s + l.lineCostRp);
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final line in lines)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${line.ingredientName} — '
                                '${fmtQty(line.qty)} ${line.unit}',
                              ),
                            ),
                            MoneyText(line.lineCostRp),
                          ],
                        ),
                      ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'HPP total',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        hppAsync.when(
                          data: (hpp) => MoneyText(
                            hpp,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          loading: () => MoneyText(totalLineCost),
                          error: (_, _) => MoneyText(totalLineCost),
                        ),
                      ],
                    ),
                    Text(
                      'Harga jual ${fmt(product.price)} • '
                      'Margin ${fmt(product.price - totalLineCost)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    _editButton(context, ref, lines),
                  ],
                ),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Gagal memuat resep: $e'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _editButton(
    BuildContext context,
    WidgetRef ref,
    List<BomLineView> lines,
  ) {
    return Align(
      alignment: Alignment.centerRight,
      child: OutlinedButton.icon(
        onPressed: () => _showEditBom(context, ref),
        icon: const Icon(Icons.edit),
        label: const Text('Edit Resep'),
      ),
    );
  }

  Future<void> _showEditBom(BuildContext context, WidgetRef ref) async {
    final ingredients = await ref.read(ingredientsProvider.future);
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (ctx) => _EditBomDialog(
        product: product,
        ingredients: ingredients,
      ),
    );
    ref.invalidate(recipeLinesProvider(product.id));
    ref.invalidate(inventoryHppProvider(product.id));
  }
}

class _EditBomDialog extends ConsumerStatefulWidget {
  const _EditBomDialog({required this.product, required this.ingredients});
  final Product product;
  final List<Ingredient> ingredients;

  @override
  ConsumerState<_EditBomDialog> createState() => _EditBomDialogState();
}

class _EditBomDialogState extends ConsumerState<_EditBomDialog> {
  String? _newIngredientId;
  final _qtyCtrl = TextEditingController();

  @override
  void dispose() {
    _qtyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final linesAsync = ref.watch(recipeLinesProvider(widget.product.id));
    return AlertDialog(
      title: Text('Resep — ${widget.product.name}'),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              linesAsync.when(
                data: (lines) {
                  if (lines.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('Belum ada baris resep.'),
                    );
                  }
                  return Column(
                    children: [
                      for (final line in lines)
                        _BomLineRow(
                          line: line,
                          onSaved: () {
                            ref.invalidate(
                              recipeLinesProvider(widget.product.id),
                            );
                            ref.invalidate(
                              inventoryHppProvider(widget.product.id),
                            );
                          },
                        ),
                    ],
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
                error: (e, _) => Text('Gagal memuat resep: $e'),
              ),
              const Divider(),
              const Text(
                'Tambah bahan',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _newIngredientId,
                decoration: const InputDecoration(
                  labelText: 'Bahan',
                  border: OutlineInputBorder(),
                ),
                items: widget.ingredients
                    .map(
                      (ing) => DropdownMenuItem(
                        value: ing.id,
                        child: Text('${ing.name} (${ing.unit})'),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _newIngredientId = v),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _qtyCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Qty per 1 porsi',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _addLine,
                    child: const Text('Tambah'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Selesai'),
        ),
      ],
    );
  }

  Future<void> _addLine() async {
    final qty = parseQty(_qtyCtrl.text);
    if (_newIngredientId == null) {
      showErrorSnack(context, 'Pilih bahan dulu.');
      return;
    }
    if (qty == null || qty <= 0) {
      showErrorSnack(context, 'Qty harus > 0.');
      return;
    }
    try {
      final db = ref.read(databaseProvider);
      await InventoryService.addRecipeLine(
        db,
        productId: widget.product.id,
        ingredientId: _newIngredientId!,
        qty: qty,
      );
      _qtyCtrl.clear();
      setState(() => _newIngredientId = null);
      ref.invalidate(recipeLinesProvider(widget.product.id));
      ref.invalidate(inventoryHppProvider(widget.product.id));
    } catch (e) {
      if (mounted) showErrorSnack(context, e);
    }
  }
}

class _BomLineRow extends ConsumerStatefulWidget {
  const _BomLineRow({required this.line, required this.onSaved});
  final BomLineView line;
  final VoidCallback onSaved;

  @override
  ConsumerState<_BomLineRow> createState() => _BomLineRowState();
}

class _BomLineRowState extends ConsumerState<_BomLineRow> {
  var _editing = false;
  late final _qtyCtrl = TextEditingController(
    text: fmtQty(widget.line.qty),
  );

  @override
  void dispose() {
    _qtyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_editing) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '${widget.line.ingredientName} — '
                '${fmtQty(widget.line.qty)} ${widget.line.unit} '
                '(${fmt(widget.line.lineCostRp)})',
              ),
            ),
            IconButton(
              tooltip: 'Ubah qty',
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _editing = true),
            ),
            IconButton(
              tooltip: 'Hapus baris',
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: _delete,
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${widget.line.ingredientName} (${widget.line.unit})',
            ),
          ),
          SizedBox(
            width: 90,
            child: TextField(
              controller: _qtyCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Simpan',
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: _save,
          ),
          IconButton(
            tooltip: 'Batal',
            icon: const Icon(Icons.close),
            onPressed: () => setState(() => _editing = false),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final qty = parseQty(_qtyCtrl.text);
    if (qty == null || qty <= 0) {
      showErrorSnack(context, 'Qty harus > 0.');
      return;
    }
    try {
      final db = ref.read(databaseProvider);
      await InventoryService.updateRecipeLineQty(
        db,
        lineId: widget.line.lineId,
        qty: qty,
      );
      setState(() => _editing = false);
      widget.onSaved();
    } catch (e) {
      if (mounted) showErrorSnack(context, e);
    }
  }

  Future<void> _delete() async {
    final ok = await showConfirmDialog(
      context,
      title: 'Hapus baris resep?',
      message:
          'Bahan "${widget.line.ingredientName}" dihapus dari resep ini.',
      actionLabel: 'Ya, hapus',
    );
    if (!ok || !mounted) return;
    try {
      final db = ref.read(databaseProvider);
      await InventoryService.removeRecipeLine(db, widget.line.lineId);
      widget.onSaved();
    } catch (e) {
      if (mounted) showErrorSnack(context, e);
    }
  }
}
