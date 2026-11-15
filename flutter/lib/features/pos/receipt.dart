// Casirz ERP — Fase 2.
// Struk: bangun ReceiptModel dari penjualan di DB + preview layar +
// tombol Cetak (PrinterPort) + Share WA (share_plus).
//
// Preview memakai teks mono yang SAMA PERSIS dengan yang dikirim ke
// printer (formatReceiptText) — jadi preview 100% benar meski printer
// fisik tidak bisa dites di VM.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/db.dart';
import '../../core/money.dart';
import '../../core/printer/receipt_model.dart';
import '../../core/printer/receipt_text.dart';
import 'pos_providers.dart';

/// Label metode tampil dari kode engine
/// ('tunai'|'qris'|'ojol'|'transfer'|'debit' — Fase 3).
String paymentLabel(String method) {
  switch (method) {
    case 'tunai':
      return 'Tunai';
    case 'qris':
      return 'QRIS / E-Wallet';
    case 'ojol':
      return 'Ojol';
    case 'transfer':
      return 'Transfer Bank';
    case 'debit':
      return 'Debit';
    default:
      return method;
  }
}

/// Bangun ReceiptModel dari satu penjualan yang sudah tersimpan.
Future<ReceiptModel> buildReceiptModel(
  AppDatabase db,
  String saleId, {
  String? cashierName,
  int? pointsEarned,
  int? customerPointsTotal,
}) async {
  final sale = await (db.select(db.sales)
        ..where((s) => s.id.equals(saleId)))
      .getSingle();
  final storeName = await db.getSetting('storeName') ?? 'Casirz';
  final paper = await db.getSetting('receiptPaperWidth') == '58'
      ? PaperWidth.mm58
      : PaperWidth.mm80;
  final lines = await (db.select(db.saleLines)
        ..where((l) => l.saleId.equals(saleId)))
      .get();
  final receiptLines = <ReceiptLine>[];
  for (final l in lines) {
    final product = await (db.select(db.products)
          ..where((p) => p.id.equals(l.productId)))
        .getSingleOrNull();
    receiptLines.add(
      ReceiptLine(
        name: product?.name ?? l.productId,
        qty: l.qty,
        price: l.price,
      ),
    );
  }
  final payments = await (db.select(db.salePayments)
        ..where((p) => p.saleId.equals(saleId)))
      .get();
  String? customerName;
  if (sale.customerId != null) {
    final c = await (db.select(db.customers)
          ..where((c) => c.id.equals(sale.customerId!)))
        .getSingleOrNull();
    customerName = c?.name;
  }
  return ReceiptModel(
    storeName: storeName,
    saleCode: sale.code,
    date: DateTime.fromMillisecondsSinceEpoch(sale.date),
    lines: receiptLines,
    subtotal: sale.subtotal,
    discount: sale.discount,
    tax: sale.tax,
    serviceCharge: sale.serviceCharge,
    ojolFee: sale.ojolFee,
    total: sale.total,
    payments: payments
        .map(
          (p) => ReceiptPayment(
            methodLabel: paymentLabel(p.method),
            amount: p.amount,
          ),
        )
        .toList(),
    change: sale.change,
    paperWidth: paper,
    cashierName: cashierName,
    channelLabel: _channelLabel(sale.channel),
    customerName: customerName,
    pointsEarned: pointsEarned ?? 0,
    customerPointsTotal: customerPointsTotal,
  );
}

String _channelLabel(String channel) {
  switch (channel) {
    case 'dine-in':
      return 'Dine-in';
    case 'takeaway':
      return 'Takeaway';
    case 'ojol':
      return 'Ojol';
    default:
      return channel;
  }
}

/// Dialog preview struk: teks mono + tombol Cetak + Share WA + Selesai.
/// [onPrinted] dipanggil setelah cetak sukses (untuk refresh, dsb).
Future<void> showReceiptDialog(
  BuildContext context,
  WidgetRef ref,
  ReceiptModel receipt,
) async {
  final text = formatReceiptText(receipt);
  var printStatus = '';
  var printing = false;
  await showDialog<void>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: Text('Struk ${receipt.saleCode}'),
        content: SizedBox(
          width: receipt.paperWidth == PaperWidth.mm58 ? 300 : 360,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(ctx).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
                if (printStatus.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    printStatus,
                    style: TextStyle(
                      color: printStatus.startsWith('Berhasil')
                          ? Colors.green.shade700
                          : Colors.red,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () async {
              try {
                await SharePlus.instance.share(
                  ShareParams(
                    text: text,
                    subject: 'Struk ${receipt.saleCode}',
                  ),
                );
              } catch (e) {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(content: Text('Gagal berbagi: $e')),
                  );
                }
              }
            },
            icon: const Icon(Icons.share),
            label: const Text('Share WA'),
          ),
          FilledButton.icon(
            onPressed: printing
                ? null
                : () async {
                    setState(() {
                      printing = true;
                      printStatus = 'Mencetak...';
                    });
                    try {
                      final port = ref.read(printerPortProvider);
                      await port.printReceipt(receipt);
                      setState(() {
                        printStatus =
                            'Berhasil dicetak ke printer thermal.';
                      });
                    } catch (e) {
                      setState(() {
                        printStatus =
                            'Gagal mencetak: $e\n(Pastikan printer terhubung '
                            'di Pengaturan > Printer. Printer fisik belum '
                            'bisa dites di VM.)';
                      });
                    } finally {
                      setState(() => printing = false);
                    }
                  },
            icon: const Icon(Icons.print),
            label: const Text('Cetak'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Selesai'),
          ),
        ],
      ),
    ),
  );
}

/// Ringkasan angka struk (dipakai di detail transaksi).
class ReceiptSummary extends StatelessWidget {
  const ReceiptSummary({super.key, required this.receipt});
  final ReceiptModel receipt;

  @override
  Widget build(BuildContext context) {
    Widget row(String label, int amount, {bool bold = false}) {
      final style = bold
          ? Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold)
          : Theme.of(context).textTheme.bodyLarge;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: style),
            Text(
              fmt(amount),
              style: style?.copyWith(
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        row('Subtotal', receipt.subtotal),
        if (receipt.discount > 0) row('Diskon', -receipt.discount),
        if (receipt.serviceCharge > 0)
          row('Service / PB1', receipt.serviceCharge),
        if (receipt.tax > 0) row('PPN 11%', receipt.tax),
        if (receipt.ojolFee > 0) row('Komisi ojol', -receipt.ojolFee),
        const Divider(),
        row('Total', receipt.total, bold: true),
        const SizedBox(height: 8),
        for (final p in receipt.payments)
          row(p.methodLabel, p.amount),
        if (receipt.change > 0) row('Kembalian', receipt.change),
        if (receipt.pointsEarned > 0)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Poin didapat: ${receipt.pointsEarned}'
              '${receipt.customerPointsTotal != null ? ' • Total poin: ${receipt.customerPointsTotal}' : ''}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
      ],
    );
  }
}
