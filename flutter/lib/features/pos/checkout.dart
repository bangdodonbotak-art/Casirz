// Casirz ERP — Fase 2.
// Checkout: multi-payment gabungan dalam SATU struk, tunai denominasi
// cepat + kembalian otomatis, QRIS, Debit, Transfer, E-Wallet, ojol.
//
// ATURAN ENGINE (SaleService.recordSale — JANGAN dilanggar di UI):
// - (dibayar - kembalian) + komisiOjol == total.
// - Channel ojol hanya boleh dibayar lewat metode ojol.
// - Kembalian hanya mungkin untuk tunai.
// - Total harus > 0 (diskon sudah di-clamp di keranjang).
// Checkout memanggil recordSale SATU KALI — tidak pernah tulis jurnal
// sendiri.
//
// Pemetaan metode tampil -> engine: lihat engineMethodFor() di cart.dart
// (Debit/Transfer -> 'debit'/'transfer', akun 1010 Bank — Fase 3;
// E-Wallet -> 'qris', akun 1020).
// Poin pelanggan diakrual ATOMIK di dalam recordSale (Fase 3) —
// checkout TIDAK lagi memanggil akrual terpisah; poin dibaca kembali
// dari DB setelah penjualan sukses.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db.dart';
import '../../core/money.dart';
import '../../core/sales_service.dart';
import '../../shared/widgets/money_text.dart';
import '../staff/staff_providers.dart';
import 'cart.dart';
import 'customer_service.dart';
import 'orders_service.dart';
import 'pos_providers.dart';
import 'receipt.dart';

class _PaymentEntry {
  _PaymentEntry({required this.displayMethod, required this.amount});
  String displayMethod; // 'Tunai' | 'QRIS' | 'Debit' | 'Transfer' | 'E-Wallet'
  int amount;
}

/// Buka sheet checkout. Mengembalikan true bila penjualan berhasil.
Future<bool> showCheckoutSheet(BuildContext context, WidgetRef ref) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) => _CheckoutSheet(ref: ref),
  );
  return result ?? false;
}

class _CheckoutSheet extends ConsumerStatefulWidget {
  const _CheckoutSheet({required this.ref});
  final WidgetRef ref;

  @override
  ConsumerState<_CheckoutSheet> createState() => _CheckoutSheetState();
}

class _CheckoutSheetState extends ConsumerState<_CheckoutSheet> {
  final _payments = <_PaymentEntry>[];
  final _tunaiController = TextEditingController();
  String _tunaiMethod = 'Tunai';
  var _busy = false;
  String? _error;

  @override
  void dispose() {
    _tunaiController.dispose();
    super.dispose();
  }

  PosCartState get _cart => widget.ref.read(cartProvider);
  PosSettings get _settings =>
      widget.ref.read(posSettingsProvider).value ??
      PosSettings.fromMap({});

  CartTotals get _totals => _cart.totals(_settings);

  int get _paid =>
      _payments.fold<int>(0, (s, p) => s + p.amount);

  int get _remaining => _totals.total - _paid > 0
      ? _totals.total - _paid
      : 0;

  bool get _isOjol => _cart.channel == 'ojol';

  void _addTunaiPayment(int amount) {
    if (amount <= 0) return;
    setState(() {
      _payments.add(_PaymentEntry(displayMethod: _tunaiMethod, amount: amount));
      _tunaiController.clear();
    });
  }

  void _addNonTunaiPayment(String method) {
    // Non-tunai: bayar sisa tagihan (tidak ada kembalian).
    if (_remaining <= 0) return;
    setState(() {
      _payments.add(_PaymentEntry(displayMethod: method, amount: _remaining));
    });
  }

  Future<void> _pay() async {
    final db = widget.ref.read(databaseProvider);
    final settings = _settings;
    final totals = _totals;
    final cart = _cart;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      // Kasir = karyawan yang sedang login (sesi login, Fase 6).
      // Tanpa sesi (DB kosong, gate terkecuali) -> null = "Tanpa login".
      final sessionEmployee = widget.ref.read(sessionProvider).employee;
      final employeeId = sessionEmployee?.id;
      // Siapkan pembayaran.
      List<SalePaymentInput> payments;
      if (_isOjol) {
        final fee = totals.ojolFee;
        payments = [
          SalePaymentInput(method: 'ojol', amount: totals.total - fee),
        ];
      } else {
        if (_paid < totals.total) {
          throw StateError(
            'Pembayaran kurang ${fmt(totals.total - _paid)}.',
          );
        }
        payments = _payments
            .map(
              (p) => SalePaymentInput(
                method: engineMethodFor(p.displayMethod),
                amount: p.amount,
              ),
            )
            .toList();
      }

      // Harga satuan efektif (termasuk markup ojol).
      final markup = cart.channel == 'ojol'
          ? settings.ojolMarkupFor(cart.ojolPlatform)
          : 0;
      final lines = cart.lines
          .map(
            (l) => SaleLineInput(
              productId: l.productId,
              qty: l.qty,
              price: markup > 0
                  ? toIntRp(l.unitPrice * (100 + markup) / 100)
                  : l.unitPrice,
            ),
          )
          .toList();

      final saleId = await SaleService.recordSale(
        db,
        date: DateTime.now(),
        channel: cart.channel,
        lines: lines,
        payments: payments,
        employeeId: employeeId,
        customerId: cart.customerId,
        shiftId: (await widget.ref.read(activeShiftProvider.future))?.id,
        orderId: cart.orderId,
        discount: totals.discount,
        tax: totals.tax,
        serviceCharge: totals.serviceCharge,
        ojolFee: totals.ojolFee,
      );

      // Poin pelanggan sudah diakrual ATOMIK di dalam recordSale
      // (Fase 3) — di sini hanya dibaca kembali untuk struk.
      var pointsEarned = 0;
      int? pointsTotal;
      if (cart.customerId != null) {
        pointsEarned = pointsForTotal(totals.total);
        final c = await (db.select(db.customers)
              ..where((c) => c.id.equals(cart.customerId!)))
            .getSingleOrNull();
        pointsTotal = c?.points;
      }

      if (cart.orderId != null) {
        await OrderService.markPaid(db, cart.orderId!);
      }

      // Refresh tampilan yang bergantung pada penjualan.
      widget.ref.invalidate(salesListProvider);
      widget.ref.invalidate(heroProductIdsProvider);
      widget.ref.invalidate(productStockMinusProvider);
      widget.ref.read(cartProvider.notifier).clear();

      final receipt = await buildReceiptModel(
        db,
        saleId,
        cashierName: sessionEmployee?.name ?? 'Tanpa login',
        pointsEarned: pointsEarned,
        customerPointsTotal: pointsTotal,
      );
      if (!mounted) return;
      Navigator.of(context).pop(true);
      await showReceiptDialog(context, widget.ref, receipt);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = '$e';
        _busy = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final settingsAsync = ref.watch(posSettingsProvider);
    final customersAsync = ref.watch(customersProvider);
    final totals = cart.totals(
      settingsAsync.value ?? PosSettings.fromMap({}),
    );
    final paid = _payments.fold<int>(0, (s, p) => s + p.amount);
    final remaining = totals.total - paid > 0 ? totals.total - paid : 0;
    final change = paid > totals.total ? paid - totals.total : 0;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pembayaran',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            // Ringkasan.
            _summaryRow('Subtotal', totals.subtotal),
            if (totals.discount > 0)
              _summaryRow('Diskon', -totals.discount),
            if (totals.serviceCharge > 0)
              _summaryRow('Service / PB1', totals.serviceCharge),
            if (totals.tax > 0) _summaryRow('PPN 11%', totals.tax),
            if (totals.ojolFee > 0)
              _summaryRow(
                'Komisi ojol (${cart.ojolPlatform ?? ''})',
                -totals.ojolFee,
              ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                MoneyText(
                  totals.total,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Pelanggan (opsional, untuk poin).
            customersAsync.when(
              data: (customers) {
                final selected = customers.where(
                  (c) => c.id == cart.customerId,
                );
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        selected.isEmpty
                            ? 'Pelanggan: - (tanpa poin)'
                            : 'Pelanggan: ${selected.first.name} '
                                '(${selected.first.points} poin)',
                      ),
                    ),
                    TextButton(
                      onPressed: () => _pickCustomer(context, customers),
                      child: const Text('Pilih'),
                    ),
                    if (cart.customerId != null)
                      TextButton(
                        onPressed: () => ref
                            .read(cartProvider.notifier)
                            .setCustomer(null),
                        child: const Text('Hapus'),
                      ),
                  ],
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
            if (_isOjol) ...[
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ojol — ${cart.ojolPlatform ?? '-'}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Diterima (netto): ${fmt(totals.total - totals.ojolFee)}'
                        ' • Komisi: ${fmt(totals.ojolFee)}',
                      ),
                      const Text(
                        'Pembayaran ojol dicatat satu baris (netto).',
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              const SizedBox(height: 12),
              Text(
                'Pembayaran (${_payments.length})',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              for (var i = 0; i < _payments.length; i++)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(_payments[i].displayMethod),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MoneyText(_payments[i].amount),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => setState(() {
                          _payments.removeAt(i);
                        }),
                      ),
                    ],
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sisa: ${fmt(remaining)}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (change > 0)
                    Text(
                      'Kembalian: ${fmt(change)}',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.green.shade700),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              // Tunai: denominasi cepat.
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _tunaiMethod,
                      decoration: const InputDecoration(
                        labelText: 'Metode tunai',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Tunai',
                          child: Text('Tunai'),
                        ),
                        DropdownMenuItem(
                          value: 'QRIS',
                          child: Text('QRIS'),
                        ),
                        DropdownMenuItem(
                          value: 'Debit',
                          child: Text('Debit'),
                        ),
                        DropdownMenuItem(
                          value: 'Transfer',
                          child: Text('Transfer'),
                        ),
                        DropdownMenuItem(
                          value: 'E-Wallet',
                          child: Text('E-Wallet'),
                        ),
                      ],
                      onChanged: (v) => setState(() {
                        if (v != null) _tunaiMethod = v;
                      }),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _tunaiController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Jumlah (Rp)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: remaining <= 0
                        ? null
                        : () {
                            final v = int.tryParse(
                                  _tunaiController.text.replaceAll(
                                    RegExp(r'[^0-9]'),
                                    '',
                                  ),
                                ) ??
                                0;
                            if (v > 0) _addTunaiPayment(v);
                          },
                    child: const Text('Tambah'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ActionChip(
                    label: const Text('Uang Pas'),
                    onPressed: remaining <= 0
                        ? null
                        : () => _addTunaiPayment(remaining),
                  ),
                  for (final d in cashDenominations)
                    ActionChip(
                      label: Text(fmt(d)),
                      onPressed: remaining <= 0
                          ? null
                          : () => _addTunaiPayment(d),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton(
                    onPressed: remaining <= 0
                        ? null
                        : () => _addNonTunaiPayment('QRIS'),
                    child: const Text('QRIS (sisa)'),
                  ),
                  OutlinedButton(
                    onPressed: remaining <= 0
                        ? null
                        : () => _addNonTunaiPayment('Debit'),
                    child: const Text('Debit (sisa)'),
                  ),
                  OutlinedButton(
                    onPressed: remaining <= 0
                        ? null
                        : () => _addNonTunaiPayment('Transfer'),
                    child: const Text('Transfer (sisa)'),
                  ),
                  OutlinedButton(
                    onPressed: remaining <= 0
                        ? null
                        : () => _addNonTunaiPayment('E-Wallet'),
                    child: const Text('E-Wallet (sisa)'),
                  ),
                ],
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _busy
                  ? null
                  : (_isOjol || remaining <= 0)
                      ? _pay
                      : null,
              icon: _busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check),
              label: Text(
                _isOjol
                    ? 'Simpan Penjualan Ojol (${fmt(totals.total - totals.ojolFee)} diterima)'
                    : 'Bayar ${fmt(totals.total)}',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, int amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), MoneyText(amount)],
      ),
    );
  }

  Future<void> _pickCustomer(
    BuildContext context,
    List<Customer> customers,
  ) async {
    final picked = await showDialog<String>(
      context: context,
      builder: (ctx) {
        final search = TextEditingController();
        var filtered = customers;
        return StatefulBuilder(
          builder: (ctx, setState) => AlertDialog(
            title: const Text('Pilih Pelanggan'),
            content: SizedBox(
              width: 360,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: search,
                    decoration: const InputDecoration(
                      labelText: 'Cari nama / telepon',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => setState(() {
                      filtered = customers
                          .where(
                            (c) =>
                                c.name.toLowerCase().contains(
                                      v.toLowerCase(),
                                    ) ||
                                (c.phone ?? '').contains(v),
                          )
                          .toList();
                    }),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filtered.length,
                      itemBuilder: (ctx, i) {
                        final c = filtered[i];
                        return ListTile(
                          title: Text(c.name),
                          subtitle: Text(
                            '${c.phone ?? '-'} • ${c.points} poin',
                          ),
                          onTap: () => Navigator.of(ctx).pop(c.id),
                        );
                      },
                    ),
                  ),
                  if (filtered.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Tidak ada pelanggan yang cocok.'),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton.icon(
                onPressed: () async {
                  final created = await _addCustomerDialog(ctx);
                  if (created != null && ctx.mounted) {
                    Navigator.of(ctx).pop(created);
                  }
                },
                icon: const Icon(Icons.person_add),
                label: const Text('Pelanggan Baru'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Batal'),
              ),
            ],
          ),
        );
      },
    );
    if (picked != null) {
      ref.read(cartProvider.notifier).setCustomer(picked);
    }
  }

  Future<String?> _addCustomerDialog(BuildContext context) async {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final created = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Pelanggan Baru'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Telepon (opsional)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () async {
              try {
                final id = await CustomerService.addCustomer(
                  ref.read(databaseProvider),
                  name: nameCtrl.text,
                  phone: phoneCtrl.text.isEmpty ? null : phoneCtrl.text,
                );
                if (ctx.mounted) Navigator.of(ctx).pop(id);
              } catch (e) {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(content: Text('$e')),
                  );
                }
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    return created;
  }
}
