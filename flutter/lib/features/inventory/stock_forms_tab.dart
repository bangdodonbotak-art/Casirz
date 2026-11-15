// Casirz ERP — Fase 3 (Modul B Bahan/BOM).
// Tab Belanja (stock-in) + tab Wastage.
// - Belanja: pilih bahan + qty + total harga beli + supplier (opsional)
//   + metode bayar (tunai/bank) -> AccountingService.recordStockIn
//   (avgCost ter-update + jurnal D 1100 / K 1000 atau K 1010).
//   Setelah simpan tampil avgCost lama -> baru. Riwayat dari stockMoves.
// - Wastage: pilih bahan + qty + alasan (wajib) ->
//   AccountingService.recordWastage (jurnal D 5210 / K 1100).
//   Riwayat wastage + alasan (dari memo jurnal).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/accounting_service.dart';
import '../../core/db.dart';
import '../../core/money.dart';
import '../../shared/widgets/common.dart';
import '../../shared/widgets/money_text.dart';
import '../pos/pos_providers.dart';
import 'inventory_page.dart';
import 'inventory_providers.dart';
import 'inventory_service.dart';

String _fmtDate(int epochMs) {
  final d = DateTime.fromMillisecondsSinceEpoch(epochMs);
  return DateFormat('dd MMM yyyy HH:mm', 'id_ID').format(d);
}

class StockInTab extends ConsumerStatefulWidget {
  const StockInTab({super.key});

  @override
  ConsumerState<StockInTab> createState() => _StockInTabState();
}

class _StockInTabState extends ConsumerState<StockInTab> {
  String? _ingredientId;
  final _qtyCtrl = TextEditingController();
  final _costCtrl = TextEditingController();
  final _supplierCtrl = TextEditingController();
  var _payFrom = 'tunai';
  var _busy = false;
  String? _result;

  @override
  void dispose() {
    _qtyCtrl.dispose();
    _costCtrl.dispose();
    _supplierCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(inventoryVersionProvider);
    final ingredientsAsync = ref.watch(ingredientsProvider);
    final historyAsync = ref.watch(stockMovesProvider('stock-in'));
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Belanja Bahan (Stock-In)',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                ingredientsAsync.when(
                  data: (ingredients) => DropdownButtonFormField<String>(
                    initialValue: _ingredientId,
                    decoration: const InputDecoration(
                      labelText: 'Bahan',
                      border: OutlineInputBorder(),
                    ),
                    items: ingredients
                        .map(
                          (ing) => DropdownMenuItem(
                            value: ing.id,
                            child: Text(
                              '${ing.name} — stok ${fmtQty(ing.stockQty)} ${ing.unit}',
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _ingredientId = v),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Gagal memuat bahan: $e'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _qtyCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Qty dibeli',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _costCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Total harga beli (Rp)',
                    prefixText: 'Rp ',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _supplierCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Supplier (opsional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _payFrom,
                  decoration: const InputDecoration(
                    labelText: 'Metode bayar',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'tunai', child: Text('Tunai')),
                    DropdownMenuItem(value: 'bank', child: Text('Bank')),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _payFrom = v);
                  },
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: _busy ? null : _save,
                  child: const Text('Simpan Belanja'),
                ),
                if (_result != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _result!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Riwayat Belanja',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        historyAsync.when(
          data: (moves) {
            if (moves.isEmpty) {
              return const EmptyState(message: 'Belum ada belanja bahan.');
            }
            return Column(
              children: [
                for (final m in moves)
                  _MoveTile(move: m, showTotal: true),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Gagal memuat riwayat: $e'),
        ),
      ],
    );
  }

  Future<void> _save() async {
    final qty = parseQty(_qtyCtrl.text);
    final cost = parseRp(_costCtrl.text);
    if (_ingredientId == null) {
      showErrorSnack(context, 'Pilih bahan dulu.');
      return;
    }
    if (qty == null || qty <= 0) {
      showErrorSnack(context, 'Qty harus > 0.');
      return;
    }
    if (cost == null || cost < 0) {
      showErrorSnack(context, 'Total harga beli tidak valid.');
      return;
    }
    setState(() {
      _busy = true;
      _result = null;
    });
    try {
      final db = ref.read(databaseProvider);
      final before = await (db.select(db.ingredients)
            ..where((i) => i.id.equals(_ingredientId!)))
          .getSingle();
      await AccountingService.recordStockIn(
        db,
        ingredientId: _ingredientId!,
        qty: qty,
        totalCost: cost,
        payFrom: _payFrom,
        supplier: _supplierCtrl.text.trim().isEmpty
            ? null
            : _supplierCtrl.text.trim(),
      );
      final after = await (db.select(db.ingredients)
            ..where((i) => i.id.equals(_ingredientId!)))
          .getSingle();
      _qtyCtrl.clear();
      _costCtrl.clear();
      _supplierCtrl.clear();
      ref.invalidate(stockMovesProvider('stock-in'));
      ref.read(inventoryVersionProvider.notifier).state++;
      if (mounted) {
        setState(() {
          _result = 'Harga rata-rata ${before.name}: '
              '${fmtAvgCostRp(before.avgCostMilli)} → '
              '${fmtAvgCostRp(after.avgCostMilli)} per ${after.unit}. '
              'Stok kini ${fmtQty(after.stockQty)} ${after.unit}.';
        });
      }
    } catch (e) {
      if (mounted) showErrorSnack(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

class WastageTab extends ConsumerStatefulWidget {
  const WastageTab({super.key});

  @override
  ConsumerState<WastageTab> createState() => _WastageTabState();
}

class _WastageTabState extends ConsumerState<WastageTab> {
  String? _ingredientId;
  final _qtyCtrl = TextEditingController();
  final _reasonCtrl = TextEditingController();
  var _busy = false;

  @override
  void dispose() {
    _qtyCtrl.dispose();
    _reasonCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(inventoryVersionProvider);
    final ingredientsAsync = ref.watch(ingredientsProvider);
    final historyAsync = ref.watch(stockMovesProvider('wastage'));
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Wastage',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                ingredientsAsync.when(
                  data: (ingredients) => DropdownButtonFormField<String>(
                    initialValue: _ingredientId,
                    decoration: const InputDecoration(
                      labelText: 'Bahan',
                      border: OutlineInputBorder(),
                    ),
                    items: ingredients
                        .map(
                          (ing) => DropdownMenuItem(
                            value: ing.id,
                            child: Text(
                              '${ing.name} — stok ${fmtQty(ing.stockQty)} ${ing.unit}',
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _ingredientId = v),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Gagal memuat bahan: $e'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _qtyCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Qty terbuang / rusak',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _reasonCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Alasan (wajib)',
                    hintText: 'mis. Susu tumpah',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: _busy ? null : _save,
                  child: const Text('Catat Wastage'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Riwayat Wastage',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        historyAsync.when(
          data: (moves) {
            if (moves.isEmpty) {
              return const EmptyState(message: 'Belum ada wastage.');
            }
            return Column(
              children: [
                for (final m in moves)
                  _MoveTile(move: m, showTotal: true, showReason: true),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Gagal memuat riwayat: $e'),
        ),
      ],
    );
  }

  Future<void> _save() async {
    final qty = parseQty(_qtyCtrl.text);
    final reason = _reasonCtrl.text.trim();
    if (_ingredientId == null) {
      showErrorSnack(context, 'Pilih bahan dulu.');
      return;
    }
    if (qty == null || qty <= 0) {
      showErrorSnack(context, 'Qty harus > 0.');
      return;
    }
    if (reason.isEmpty) {
      showErrorSnack(context, 'Alasan wastage wajib diisi.');
      return;
    }
    setState(() => _busy = true);
    try {
      final db = ref.read(databaseProvider);
      final amount = await AccountingService.recordWastage(
        db,
        ingredientId: _ingredientId!,
        qty: qty,
        reason: reason,
      );
      _qtyCtrl.clear();
      _reasonCtrl.clear();
      ref.invalidate(stockMovesProvider('wastage'));
      ref.read(inventoryVersionProvider.notifier).state++;
      if (mounted) {
        showOkSnack(context, 'Wastage dicatat (${fmt(amount)}).');
      }
    } catch (e) {
      if (mounted) showErrorSnack(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

/// Satu baris riwayat mutasi bahan.
class _MoveTile extends ConsumerWidget {
  const _MoveTile({
    required this.move,
    this.showTotal = false,
    this.showReason = false,
  });
  final StockMove move;
  final bool showTotal;
  final bool showReason;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameAsync = ref.watch(ingredientNameProvider(move.ingredientId));
    final reasonAsync = showReason
        ? ref.watch(
            _wastageReasonProvider(move.refId),
          )
        : null;
    final totalRp = toIntRp(move.qty.abs() * move.unitCostMilli / 1000);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: nameAsync.when(
          data: (name) => Text(
            '$name — ${move.qty > 0 ? '+' : ''}${fmtQty(move.qty)}',
          ),
          loading: () => const Text('...'),
          error: (_, _) => const Text('-'),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_fmtDate(move.date)} • '
              '${fmtAvgCostRp(move.unitCostMilli)} / satuan',
            ),
            if (showReason && reasonAsync != null)
              reasonAsync.when(
                data: (reason) => reason == null
                    ? const SizedBox.shrink()
                    : Text('Alasan: $reason'),
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
          ],
        ),
        trailing: showTotal ? MoneyText(totalRp) : null,
      ),
    );
  }
}

final _wastageReasonProvider =
    FutureProvider.family<String?, String>((ref, moveId) async {
  final db = ref.watch(databaseProvider);
  return InventoryService.wastageReason(db, moveId);
});
