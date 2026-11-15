// Casirz ERP — Fase 2.
// Meja & order: peta meja visual (dine-in), mode Takeaway & Delivery,
// Open Bill, Split Bill, Merge Bill, QR self-order.
//
// - QR self-order HANYA format link (tanpa backend):
//   https://casirz.app/order?meja=<id-meja> — ditampilkan + bisa
//   di-share. Belum ada server yang melayani link itu (Fase 7+).
// - Split rata: matematika di cart.dart (splitEvenly) — total split
//   SELALU = total asli. Di UI, bagi rata dibayar lewat checkout
//   multi-payment (satu penjualan, N pembayaran tunai per orang).
// - Split per item: pindahkan orderLines ke order baru (OrderService).
import 'package:drift/drift.dart' hide Column, isNull;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/bom.dart';
import '../../core/db.dart';
import '../../core/money.dart';
import '../../shared/widgets/common.dart';
import '../../shared/widgets/money_text.dart';
import 'cart.dart';
import 'checkout.dart';
import 'orders_service.dart';
import 'pos_page.dart' show ojolPlatforms;
import 'pos_providers.dart';

/// Format link QR self-order per meja (TANPA backend — hanya format).
String selfOrderLink(String tableId) =>
    'https://casirz.app/order?meja=$tableId';

class TablesPage extends ConsumerWidget {
  const TablesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tablesAsync = ref.watch(tablesProvider);
    final ordersAsync = ref.watch(openOrdersProvider);
    return tablesAsync.when(
      data: (tables) {
        final orders = ordersAsync.value ?? const <Order>[];
        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Meja',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: () => _addTable(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Meja'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (tables.isEmpty)
                const EmptyState(
                  message:
                      'Belum ada meja.\nTambah meja dulu untuk memakai peta meja dine-in.',
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: tables.length,
                  itemBuilder: (ctx, i) {
                    final table = tables[i];
                    final tableOrders = orders
                        .where((o) => o.tableId == table.id)
                        .toList();
                    return _TableCard(
                      table: table,
                      openOrders: tableOrders,
                    );
                  },
                ),
              const SizedBox(height: 20),
              Text(
                'Open Bill (belum bayar)',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              ordersAsync.when(
                data: (openOrders) {
                  if (openOrders.isEmpty) {
                    return const EmptyState(
                      message: 'Tidak ada open bill.',
                    );
                  }
                  return Column(
                    children: openOrders
                        .map((o) => _OpenBillTile(order: o))
                        .toList(),
                  );
                },
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Gagal memuat open bill: $e'),
              ),
              const SizedBox(height: 20),
              _TakeawayDeliveryCard(),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Gagal memuat meja: $e')),
    );
  }

  Future<void> _addTable(BuildContext context, WidgetRef ref) async {
    final ctrl = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tambah Meja'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Nama meja (mis. Meja 1)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(ctrl.text),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    if (name == null || name.trim().isEmpty) return;
    try {
      await OrderService.addTable(ref.read(databaseProvider), name);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        );
      }
    }
  }
}

/// Kartu meja: status + jumlah open bill + aksi.
class _TableCard extends ConsumerWidget {
  const _TableCard({required this.table, required this.openOrders});
  final ShopTable table;
  final List<Order> openOrders;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = switch (table.status) {
      'terisi' => Colors.orange,
      'reserved' => Colors.blue,
      _ => Colors.green,
    };
    final label = switch (table.status) {
      'terisi' => 'Terisi',
      'reserved' => 'Reserved',
      _ => 'Kosong',
    };
    return Card(
      child: InkWell(
        onTap: () => _openTableSheet(context, ref),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(label),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                table.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                openOrders.isEmpty
                    ? 'Tidak ada pesanan'
                    : '${openOrders.length} open bill',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openTableSheet(BuildContext context, WidgetRef ref) async {
    final db = ref.read(databaseProvider);
    await showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              table.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text('Status: ${table.status}'),
            const SizedBox(height: 12),
            if (table.status == 'kosong')
              FilledButton.icon(
                onPressed: () async {
                  final orderId = await OrderService.createOrder(
                    db,
                    tableId: table.id,
                    channel: 'dine-in',
                  );
                  if (ctx.mounted) Navigator.of(ctx).pop();
                  if (context.mounted) {
                    _openOrderDetail(context, ref, orderId);
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('Buat Pesanan Baru (Dine-in)'),
              ),
            if (table.status == 'terisi')
              FilledButton.icon(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  if (openOrders.isNotEmpty) {
                    _openOrderDetail(context, ref, openOrders.first.id);
                  }
                },
                icon: const Icon(Icons.receipt_long),
                label: const Text('Lihat Open Bill'),
              ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () async {
                await showDialog<void>(
                  context: ctx,
                  builder: (dctx) => AlertDialog(
                    title: Text('QR Self-Order — ${table.name}'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pelanggan scan QR ini untuk pesan sendiri dari meja. '
                          'Link ini formatnya saja — belum ada server yang '
                          'melayani pemesanan online (Fase 7+).',
                        ),
                        const SizedBox(height: 12),
                        SelectableText(selfOrderLink(table.id)),
                      ],
                    ),
                    actions: [
                      TextButton.icon(
                        onPressed: () {
                          SharePlus.instance.share(
                            ShareParams(
                              text: 'Pesan dari ${table.name}: '
                                  '${selfOrderLink(table.id)}',
                            ),
                          );
                        },
                        icon: const Icon(Icons.share),
                        label: const Text('Bagikan Link'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(dctx).pop(),
                        child: const Text('Tutup'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.qr_code),
              label: const Text('QR Self-Order'),
            ),
            const SizedBox(height: 8),
            if (table.status != 'terisi')
              OutlinedButton(
                onPressed: () async {
                  final next =
                      table.status == 'reserved' ? 'kosong' : 'reserved';
                  await OrderService.setTableStatusManual(
                    db,
                    table.id,
                    next,
                  );
                  if (ctx.mounted) Navigator.of(ctx).pop();
                },
                child: Text(
                  table.status == 'reserved'
                      ? 'Batalkan Reserved'
                      : 'Tandai Reserved',
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Satu open bill: ringkasan + buka detail.
class _OpenBillTile extends ConsumerWidget {
  const _OpenBillTile({required this.order});
  final Order order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.read(databaseProvider);
    return FutureBuilder<int>(
      future: OrderService.orderTotal(db, order.id),
      builder: (ctx, snap) {
        final total = snap.data ?? 0;
        return Card(
          child: ListTile(
            title: Text(
              'Order ${order.id.substring(0, 8)} • ${order.channel}',
            ),
            subtitle: Text(
              order.tableId == null
                  ? 'Tanpa meja'
                  : 'Meja ${order.tableId!.substring(0, 8)}',
            ),
            trailing: MoneyText(total),
            onTap: () => _openOrderDetail(context, ref, order.id),
          ),
        );
      },
    );
  }
}

/// Detail order: daftar item, tambah item, split, merge, bayar, void.
Future<void> _openOrderDetail(
  BuildContext context,
  WidgetRef ref,
  String orderId, {
  String? ojolPlatform,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) => _OrderDetailSheet(
      orderId: orderId,
      ojolPlatform: ojolPlatform,
    ),
  );
}

class _OrderDetailSheet extends ConsumerStatefulWidget {
  const _OrderDetailSheet({required this.orderId, this.ojolPlatform});
  final String orderId;
  final String? ojolPlatform;

  @override
  ConsumerState<_OrderDetailSheet> createState() => _OrderDetailSheetState();
}

class _OrderDetailSheetState extends ConsumerState<_OrderDetailSheet> {
  var _refresh = 0;

  Future<void> _reload() async => setState(() => _refresh++);

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: FutureBuilder<_OrderDetail>(
        future: _loadDetail(db),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError || !snap.hasData) {
            return Center(child: Text('Gagal memuat order: ${snap.error}'));
          }
          final detail = snap.data!;
          final total = detail.lines.fold<int>(
            0,
            (s, l) => s + l.line.price * l.line.qty,
          );
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Order ${detail.order.id.substring(0, 8)}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                Text(
                  'Channel: ${detail.order.channel}'
                  '${detail.tableName != null ? ' • ${detail.tableName}' : ''} '
                  '• Status: ${detail.order.status}',
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: detail.lines.isEmpty
                      ? const EmptyState(message: 'Belum ada item.')
                      : ListView.builder(
                          itemCount: detail.lines.length,
                          itemBuilder: (ctx, i) {
                            final l = detail.lines[i];
                            return ListTile(
                              title: Text(l.productName),
                              subtitle: Text(
                                '${fmt(l.line.price)} x ${l.line.qty}',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                    ),
                                    onPressed: () async {
                                      await OrderService.setLineQty(
                                        db,
                                        l.line.id,
                                        l.line.qty - 1,
                                      );
                                      _reload();
                                    },
                                  ),
                                  Text('${l.line.qty}'),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add_circle_outline,
                                    ),
                                    onPressed: () async {
                                      await OrderService.setLineQty(
                                        db,
                                        l.line.id,
                                        l.line.qty + 1,
                                      );
                                      _reload();
                                    },
                                  ),
                                  MoneyText(l.line.price * l.line.qty),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    MoneyText(
                      total,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton.icon(
                      onPressed: detail.lines.isEmpty
                          ? null
                          : () => _addItem(context, ref),
                      icon: const Icon(Icons.add),
                      label: const Text('Tambah Item'),
                    ),
                    FilledButton.icon(
                      onPressed: detail.lines.isEmpty
                          ? null
                          : () => _payOrder(context, ref, detail),
                      icon: const Icon(Icons.payment),
                      label: const Text('Bayar'),
                    ),
                    OutlinedButton.icon(
                      onPressed: detail.lines.length < 2
                          ? null
                          : () => _splitByItems(context, ref, detail),
                      icon: const Icon(Icons.call_split),
                      label: const Text('Split per Item'),
                    ),
                    OutlinedButton.icon(
                      onPressed: detail.lines.isEmpty
                          ? null
                          : () => _splitEvenly(context, ref, total),
                      icon: const Icon(Icons.people),
                      label: const Text('Bagi Rata'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => _mergeOrder(context, ref, detail),
                      icon: const Icon(Icons.merge_type),
                      label: const Text('Gabung Bill'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final ok = await showConfirmDialog(
                          context,
                          title: 'Batalkan order?',
                          message:
                              'Order ini dibatalkan (status void). Item tidak '
                              'jadi dipesan.',
                          actionLabel: 'Ya, batalkan',
                        );
                        if (!ok) return;
                        await OrderService.voidOrder(db, detail.order.id);
                        if (context.mounted) Navigator.of(ctx).pop();
                      },
                      icon: const Icon(Icons.cancel_outlined),
                      label: const Text('Batalkan'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<_OrderDetail> _loadDetail(AppDatabase db) async {
    final order = await (db.select(db.orders)
          ..where((o) => o.id.equals(widget.orderId)))
        .getSingle();
    String? tableName;
    if (order.tableId != null) {
      final t = await (db.select(db.shopTables)
            ..where((t) => t.id.equals(order.tableId!)))
          .getSingleOrNull();
      tableName = t?.name;
    }
    final lines = await (db.select(db.orderLines)
          ..where(
            (l) => l.orderId.equals(order.id) & l.isDeleted.equals(0),
          ))
        .get();
    final withNames = <_OrderLineView>[];
    for (final l in lines) {
      final p = await (db.select(db.products)
            ..where((p) => p.id.equals(l.productId)))
          .getSingleOrNull();
      withNames.add(
        _OrderLineView(line: l, productName: p?.name ?? l.productId),
      );
    }
    return _OrderDetail(
      order: order,
      tableName: tableName,
      lines: withNames,
    );
  }

  Future<void> _addItem(BuildContext context, WidgetRef ref) async {
    final db = ref.read(databaseProvider);
    final products = await ref.read(productsProvider.future);
    if (!context.mounted) return;
    final picked = await showDialog<Product>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Tambah Item'),
        children: products
            .map(
              (p) => SimpleDialogOption(
                onPressed: () => Navigator.of(ctx).pop(p),
                child: Text('${p.name} — ${fmt(p.price)}'),
              ),
            )
            .toList(),
      ),
    );
    if (picked == null) return;
    await OrderService.addLine(
      db,
      orderId: widget.orderId,
      productId: picked.id,
      qty: 1,
    );
    _reload();
  }

  Future<void> _payOrder(
    BuildContext context,
    WidgetRef ref,
    _OrderDetail detail,
  ) async {
    final db = ref.read(databaseProvider);
    final lines = <CartLine>[];
    for (final l in detail.lines) {
      // HPP estimasi per unit (tampil saja; final dihitung engine).
      final hpp = await Bom.computeHPP(db, l.line.productId, 1);
      lines.add(
        CartLine(
          productId: l.line.productId,
          name: l.productName,
          basePrice: l.line.price,
          qty: l.line.qty,
          hppPerUnit: hpp,
        ),
      );
    }
    final settings = await ref.read(posSettingsProvider.future);
    ref.read(cartProvider.notifier).loadFromOrder(
          orderId: detail.order.id,
          tableName: detail.tableName,
          channel: detail.order.channel,
          ojolPlatform: widget.ojolPlatform,
          lines: lines,
        );
    // Terapkan default PPN/service dari settings ke keranjang ini.
    ref.read(cartProvider.notifier).setPpn(settings.ppnEnabled);
    ref.read(cartProvider.notifier).setServiceRate(settings.serviceRate);
    ref.read(cartProvider.notifier).setPb1Rate(settings.pb1Rate);
    if (!context.mounted) return;
    Navigator.of(context).pop();
    await showCheckoutSheet(context, ref);
  }

  Future<void> _splitByItems(
    BuildContext context,
    WidgetRef ref,
    _OrderDetail detail,
  ) async {
    final selected = <String>{};
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Split per Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pilih item yang dipisah ke bill baru. '
                'Sisanya tetap di bill ini.',
              ),
              ...detail.lines.map(
                (l) => CheckboxListTile(
                  title: Text('${l.productName} x${l.line.qty}'),
                  subtitle: Text(fmt(l.line.price * l.line.qty)),
                  value: selected.contains(l.line.id),
                  onChanged: (v) => setState(() {
                    if (v == true) {
                      selected.add(l.line.id);
                    } else {
                      selected.remove(l.line.id);
                    }
                  }),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: selected.isEmpty
                  ? null
                  : () => Navigator.of(ctx).pop(true),
              child: const Text('Pisahkan'),
            ),
          ],
        ),
      ),
    );
    if (confirmed != true) return;
    try {
      final newId = await OrderService.splitOrderByItems(
        ref.read(databaseProvider),
        orderId: widget.orderId,
        lineIds: selected.toList(),
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Bill baru dibuat (${newId.substring(0, 8)}). '
            'Kedua bill bisa dibayar terpisah.',
          ),
        ),
      );
      _reload();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        );
      }
    }
  }

  Future<void> _splitEvenly(
    BuildContext context,
    WidgetRef ref,
    int total,
  ) async {
    var parts = 2;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          final shares = splitEvenly(total, parts);
          return AlertDialog(
            title: const Text('Bagi Rata'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Jumlah orang: '),
                    IconButton(
                      onPressed: parts > 2
                          ? () => setState(() => parts--)
                          : null,
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text('$parts'),
                    IconButton(
                      onPressed: parts < 10
                          ? () => setState(() => parts++)
                          : null,
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...shares.asMap().entries.map(
                      (e) => Text(
                        'Orang ${e.key + 1}: ${fmt(e.value)}',
                      ),
                    ),
                const Divider(),
                Text(
                  'Jumlah: ${fmt(shares.fold<int>(0, (s, v) => s + v))} '
                  '(harus = total ${fmt(total)})',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Bagi rata dibayar lewat checkout: satu penjualan, '
                  'tiap orang membayar bagiannya sebagai pembayaran tunai '
                  'terpisah (tombol denominasi / jumlah manual).',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Tutup'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Lanjut ke Bayar'),
              ),
            ],
          );
        },
      ),
    );
    if (confirmed != true) return;
    if (!context.mounted) return;
    final detail = await _loadDetail(ref.read(databaseProvider));
    if (!context.mounted) return;
    await _payOrder(context, ref, detail);
  }

  Future<void> _mergeOrder(
    BuildContext context,
    WidgetRef ref,
    _OrderDetail detail,
  ) async {
    final db = ref.read(databaseProvider);
    final others = await (db.select(db.orders)
          ..where(
            (o) =>
                o.status.equals('open') &
                o.id.isNotIn([detail.order.id]),
          ))
        .get();
    if (others.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak ada open bill lain untuk digabung.'),
          ),
        );
      }
      return;
    }
    if (!context.mounted) return;
    final picked = await showDialog<Order>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Gabung ke bill...'),
        children: others
            .map(
              (o) => SimpleDialogOption(
                onPressed: () => Navigator.of(ctx).pop(o),
                child: Text(
                  'Order ${o.id.substring(0, 8)} • ${o.channel}',
                ),
              ),
            )
            .toList(),
      ),
    );
    if (picked == null) return;
    try {
      await OrderService.mergeOrders(
        db,
        intoOrderId: picked.id,
        fromOrderId: detail.order.id,
      );
      if (context.mounted) Navigator.of(context).pop();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        );
      }
    }
  }
}

class _OrderDetail {
  _OrderDetail({
    required this.order,
    required this.tableName,
    required this.lines,
  });
  final Order order;
  final String? tableName;
  final List<_OrderLineView> lines;
}

class _OrderLineView {
  _OrderLineView({required this.line, required this.productName});
  final OrderLine line;
  final String productName;
}

/// Kartu Takeaway & Delivery: buat open bill tanpa meja.
class _TakeawayDeliveryCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Takeaway & Delivery',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: () => _newOrder(context, ref, 'takeaway', null),
                  icon: const Icon(Icons.shopping_bag),
                  label: const Text('Takeaway Baru'),
                ),
                for (final p in ojolPlatforms)
                  OutlinedButton.icon(
                    onPressed: () => _newOrder(context, ref, 'ojol', p),
                    icon: const Icon(Icons.delivery_dining),
                    label: Text('$p Baru'),
                  ),
              ],
            ),
            const Text(
              'Order ojol dibuat di sini sebagai open bill; '
              'komisi & markup mengikuti Settings > Ojol.',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _newOrder(
    BuildContext context,
    WidgetRef ref,
    String channel,
    String? platform,
  ) async {
    final orderId = await OrderService.createOrder(
      ref.read(databaseProvider),
      channel: channel,
    );
    if (!context.mounted) return;
    // Platform ojol diteruskan ke sheet supaya saat bayar, komisi &
    // markup platform itu yang dipakai (order tidak menyimpan platform).
    await _openOrderDetail(context, ref, orderId, ojolPlatform: platform);
  }
}
