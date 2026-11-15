// Casirz ERP — Fase 2.
// Transaksi: daftar penjualan (terbaru dulu, filter tanggal/metode),
// detail struk, Void (SaleService.voidSale — jurnal pembalik + stok
// kembali). Status void tampil jelas.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db.dart';
import '../../core/sales_service.dart';
import '../../shared/widgets/common.dart';
import '../../shared/widgets/money_text.dart';
import 'pos_providers.dart';
import 'receipt.dart';

class TransactionsPage extends ConsumerWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(salesFilterProvider);
    final salesAsync = ref.watch(salesListProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  initialValue: filter.days,
                  decoration: const InputDecoration(
                    labelText: 'Periode',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('Hari ini')),
                    DropdownMenuItem(value: 7, child: Text('7 hari')),
                    DropdownMenuItem(value: 30, child: Text('30 hari')),
                    DropdownMenuItem(value: 0, child: Text('Semua')),
                  ],
                  onChanged: (v) {
                    if (v == null) return;
                    ref.read(salesFilterProvider.notifier).state =
                        SalesFilter(method: filter.method, days: v);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: filter.method,
                  decoration: const InputDecoration(
                    labelText: 'Metode',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'semua', child: Text('Semua')),
                    DropdownMenuItem(value: 'tunai', child: Text('Tunai')),
                    DropdownMenuItem(value: 'qris', child: Text('QRIS')),
                    DropdownMenuItem(
                      value: 'transfer',
                      child: Text('Transfer'),
                    ),
                    DropdownMenuItem(value: 'debit', child: Text('Debit')),
                    DropdownMenuItem(value: 'ojol', child: Text('Ojol')),
                    DropdownMenuItem(value: 'multi', child: Text('Multi')),
                  ],
                  onChanged: (v) {
                    if (v == null) return;
                    ref.read(salesFilterProvider.notifier).state =
                        SalesFilter(method: v, days: filter.days);
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: salesAsync.when(
            data: (sales) {
              if (sales.isEmpty) {
                return const EmptyState(
                  message: 'Belum ada penjualan pada periode ini.',
                );
              }
              return ListView.builder(
                itemCount: sales.length,
                itemBuilder: (ctx, i) {
                  final s = sales[i];
                  final date = DateTime.fromMillisecondsSinceEpoch(s.date);
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    child: ListTile(
                      title: Row(
                        children: [
                          Expanded(child: Text(s.code)),
                          if (s.voided == 1)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.shade600,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'DIBATALKAN',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      subtitle: Text(
                        '${date.day}/${date.month}/${date.year} '
                        '${date.hour.toString().padLeft(2, '0')}:'
                        '${date.minute.toString().padLeft(2, '0')} • '
                        '${s.channel} • ${s.paymentMethod}',
                      ),
                      trailing: MoneyText(
                        s.total,
                        style: TextStyle(
                          decoration: s.voided == 1
                              ? TextDecoration.lineThrough
                              : null,
                          color: s.voided == 1 ? Colors.red : null,
                        ),
                      ),
                      onTap: () => _showSaleDetail(context, ref, s),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Gagal memuat: $e')),
          ),
        ),
      ],
    );
  }

  Future<void> _showSaleDetail(
    BuildContext context,
    WidgetRef ref,
    Sale sale,
  ) async {
    final db = ref.read(databaseProvider);
    final receipt = await buildReceiptModel(db, sale.id);
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Struk ${sale.code}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (sale.voided == 1)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Penjualan ini DIBATALKAN'
                    '${sale.voidedAt != null ? ' pada ${DateTime.fromMillisecondsSinceEpoch(sale.voidedAt!)}' : ''}. '
                    'Jurnal pembalik sudah dibuat dan stok dikembalikan.',
                    style: TextStyle(color: Colors.red.shade800),
                  ),
                ),
              ...receipt.lines.map(
                (l) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text('${l.qty}x ${l.name}'),
                      ),
                      MoneyText(l.subtotal),
                    ],
                  ),
                ),
              ),
              const Divider(),
              ReceiptSummary(receipt: receipt),
            ],
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => showReceiptDialog(context, ref, receipt),
            icon: const Icon(Icons.receipt_long),
            label: const Text('Struk'),
          ),
          if (sale.voided == 0)
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red.shade600,
              ),
              onPressed: () async {
                final ok = await showConfirmDialog(
                  ctx,
                  title: 'Batalkan penjualan ${sale.code}?',
                  message:
                      'Void membuat jurnal pembalik dan mengembalikan stok '
                      'bahan/produk seperti sebelum penjualan. '
                      'Penjualan yang sudah void tidak bisa di-void lagi.',
                  actionLabel: 'Ya, void',
                );
                if (!ok) return;
                try {
                  await SaleService.voidSale(db, sale.id);
                  ref.invalidate(salesListProvider);
                  if (ctx.mounted) Navigator.of(ctx).pop();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Penjualan ${sale.code} dibatalkan.',
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  if (ctx.mounted) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      SnackBar(content: Text('Gagal void: $e')),
                    );
                  }
                }
              },
              icon: const Icon(Icons.undo),
              label: const Text('Void'),
            ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
