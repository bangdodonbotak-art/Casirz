// Casirz ERP — Fase 2.
// Layar Kasir: grid kartu menu besar, cari instan, tab kategori,
// varian/modifier, keranjang, promo, PPN, service/PB1, ringkasan total.
//
// - Stok minus TIDAK memblokir jualan (keputusan Dony): hanya badge
//   merah "Stok Minus" di kartu menu.
// - HPP estimasi tampil di kartu (Bom.computeHPP — BUKAN angka final).
// - Touch target >= 44px; angka uang tabularFigures (MoneyText).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db.dart';
import '../../core/money.dart';
import '../../shared/widgets/common.dart';
import '../../shared/widgets/money_text.dart';
import '../../shared/widgets/stock_qty_text.dart';
import '../settings/settings_page.dart';
import '../staff/staff_providers.dart';
import 'cart.dart';
import 'checkout.dart';
import 'pos_providers.dart';
import 'shift.dart';

const List<String> ojolPlatforms = ['GoFood', 'GrabFood', 'ShopeeFood'];

class PosPage extends ConsumerStatefulWidget {
  const PosPage({super.key});

  @override
  ConsumerState<PosPage> createState() => _PosPageState();
}

class _PosPageState extends ConsumerState<PosPage> {
  String _search = '';
  String _category = 'Semua';

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);
    final cart = ref.watch(cartProvider);
    final settingsAsync = ref.watch(posSettingsProvider);
    final shiftAsync = ref.watch(activeShiftProvider);
    final settings = settingsAsync.value ?? PosSettings.fromMap({});
    final totals = cart.totals(settings);
    final isWide = MediaQuery.of(context).size.width >= 900;

    return Column(
      children: [
        _header(context, settings, shiftAsync),
        Expanded(
          child: productsAsync.when(
            data: (products) {
              if (products.isEmpty) {
                return EmptyState(
                  message:
                      'Belum ada menu.\nIsi Data Demo Warkop dulu di Pengaturan '
                      'untuk mencoba kasir dengan 10 menu warkop.',
                  action: FilledButton(
                    onPressed: () => _openSettings(context),
                    child: const Text('Buka Pengaturan'),
                  ),
                );
              }
              final categories = <String>{
                'Semua',
                ...products.map((p) => p.category),
              }.toList();
              final filtered = products.where((p) {
                final matchCat =
                    _category == 'Semua' || p.category == _category;
                final matchSearch = _search.isEmpty ||
                    p.name.toLowerCase().contains(_search.toLowerCase());
                return matchCat && matchSearch;
              }).toList();
              final menu = Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Cari menu...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (v) => setState(() => _search = v),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: categories
                          .map(
                            (c) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(c),
                                selected: _category == c,
                                onSelected: (_) =>
                                    setState(() => _category = c),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Expanded(
                    child: filtered.isEmpty
                        ? const EmptyState(
                            message: 'Tidak ada menu yang cocok.',
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.all(12),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isWide ? 3 : 2,
                              childAspectRatio: 1.35,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: filtered.length,
                            itemBuilder: (ctx, i) =>
                                _ProductCard(product: filtered[i]),
                          ),
                  ),
                ],
              );
              final cartPanel = _CartPanel(
                totals: totals,
                onCheckout: () => showCheckoutSheet(context, ref),
              );
              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: menu),
                    SizedBox(width: 380, child: cartPanel),
                  ],
                );
              }
              return Column(
                children: [
                  Expanded(child: menu),
                  _MobileCartBar(totals: totals),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Gagal memuat menu: $e')),
          ),
        ),
      ],
    );
  }

  Widget _header(
    BuildContext context,
    PosSettings settings,
    AsyncValue<Shift?> shiftAsync,
  ) {
    final cart = ref.watch(cartProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: const Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // Channel.
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'dine-in', label: Text('Dine-in')),
              ButtonSegment(value: 'takeaway', label: Text('Takeaway')),
              ButtonSegment(value: 'ojol', label: Text('Ojol')),
            ],
            selected: {cart.channel},
            onSelectionChanged: (s) {
              final ch = s.first;
              ref.read(cartProvider.notifier).setChannel(
                    ch,
                    platform: ch == 'ojol'
                        ? (cart.ojolPlatform ?? 'GoFood')
                        : null,
                  );
            },
          ),
          if (cart.channel == 'ojol')
            DropdownButton<String>(
              value: cart.ojolPlatform ?? 'GoFood',
              items: ojolPlatforms
                  .map(
                    (p) => DropdownMenuItem(
                      value: p,
                      child: Text(
                        '$p (fee ${settings.ojolFeeFor(p)}%, '
                        'markup ${settings.ojolMarkupFor(p)}%)',
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (p) {
                if (p != null) {
                  ref.read(cartProvider.notifier).setChannel(
                        'ojol',
                        platform: p,
                      );
                }
              },
            ),
          // Shift aktif.
          shiftAsync.when(
            data: (shift) {
              if (shift == null) {
                return OutlinedButton.icon(
                  onPressed: () => _openShift(context),
                  icon: const Icon(Icons.lock_open),
                  label: const Text('Buka Shift'),
                );
              }
              final opened = DateTime.fromMillisecondsSinceEpoch(
                shift.openedAt,
              );
              return ActionChip(
                avatar: const Icon(Icons.store, size: 18),
                label: Text(
                  'Shift ${opened.hour.toString().padLeft(2, '0')}:'
                  '${opened.minute.toString().padLeft(2, '0')} • '
                  'Float ${fmt(shift.openingFloat)}',
                ),
                onPressed: () => _openShift(context),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
          // Kasir yang login (tampilan saja — bukan dropdown; penjualan
          // dicatat atas sesi login, Fase 6).
          const _CashierChip(),
        ],
      ),
    );
  }

  void _openSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SettingsPage()),
    );
  }

  void _openShift(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ShiftPage()),
    );
  }
}

/// Chip kasir yang sedang login — hanya tampilan, bukan pilihan.
/// Penjualan dicatat atas karyawan di sesi login (Fase 6); tanpa sesi
/// tampil "Tanpa login" dan penjualan dicatat employeeId null.
class _CashierChip extends ConsumerWidget {
  const _CashierChip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employee = ref.watch(sessionProvider).employee;
    return Chip(
      avatar: const Icon(Icons.person, size: 18),
      label: Text(
        employee == null ? 'Kasir: Tanpa login' : 'Kasir: ${employee.name}',
      ),
    );
  }
}

/// Kartu menu: nama + harga + HPP estimasi + badge HERO / Stok Minus.
class _ProductCard extends ConsumerWidget {
  const _ProductCard({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hppAsync = ref.watch(hppProvider(product.id));
    final minusAsync = ref.watch(productStockMinusProvider(product.id));
    final heroAsync = ref.watch(heroProductIdsProvider);
    final isHero = heroAsync.value?.contains(product.id) ?? false;
    final isMinus = minusAsync.value ?? false;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showProductOptions(context, ref),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (isHero) const HeroBadge(),
                  if (isHero && isMinus) const SizedBox(width: 4),
                  if (isMinus) const StokMinusBadge(),
                  const Spacer(),
                  Text(
                    product.category,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                product.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              MoneyText(
                product.price,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF059669),
                      fontWeight: FontWeight.bold,
                    ),
              ),
              hppAsync.when(
                data: (hpp) => Text(
                  'HPP ${fmt(hpp)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                loading: () => const Text(
                  'HPP ...',
                  style: TextStyle(fontSize: 12),
                ),
                error: (_, _) => const SizedBox.shrink(),
              ),
              if (!isMinus && product.stock > 0)
                Text(
                  'Stok: ${product.stock} pcs',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Sheet pilihan varian: tiap grup punya judul + cara pilihnya.
  /// Minuman: Level Gula (pilih 1) + Es (pilih 1) + Extra (boleh banyak).
  /// Makanan: Extra (boleh banyak).
  Future<void> _showProductOptions(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final isDrink = product.category.toLowerCase() == 'minuman';
    final groups = Modifiers.forCategory(product.category);
    final groupTitles = isDrink
        ? const ['Level Gula', 'Es', 'Extra']
        : const ['Extra'];
    // Grup Extra = grup terakhir; pilih-banyak. Grup lain = pilih-satu.
    bool isMultiGroup(int g) => g == groups.length - 1;
    final singleChoice = <int, CartModifier>{
      for (var g = 0; g < groups.length; g++)
        if (!isMultiGroup(g)) g: groups[g].first,
    };
    final extraSelected = <CartModifier>{};
    var qty = 1;
    final noteCtrl = TextEditingController();
    final hpp = await ref.read(hppProvider(product.id).future);
    if (!context.mounted) return;
    final added = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: Theme.of(ctx).textTheme.titleLarge,
                ),
                MoneyText(
                  product.price,
                  style: Theme.of(ctx).textTheme.titleMedium,
                ),
                Text('HPP estimasi ${fmt(hpp)} per unit'),
                const SizedBox(height: 12),
                for (var g = 0; g < groups.length; g++) ...[
                  Text(
                    groupTitles[g],
                    style: Theme.of(ctx).textTheme.titleMedium,
                  ),
                  Wrap(
                    spacing: 8,
                    children: groups[g].map((m) {
                      final multi = isMultiGroup(g);
                      final chosen = multi
                          ? extraSelected.contains(m)
                          : singleChoice[g] == m;
                      return FilterChip(
                        label: Text(
                          m.priceDelta > 0
                              ? '${m.name} +${fmt(m.priceDelta)}'
                              : m.name,
                        ),
                        selected: chosen,
                        onSelected: (_) => setState(() {
                          if (multi) {
                            if (extraSelected.contains(m)) {
                              extraSelected.remove(m);
                            } else {
                              extraSelected.add(m);
                            }
                          } else {
                            singleChoice[g] = m;
                          }
                        }),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                ],
                TextField(
                  controller: noteCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Catatan per item (opsional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    IconButton(
                      onPressed:
                          qty > 1 ? () => setState(() => qty--) : null,
                      icon: const Icon(Icons.remove_circle_outline),
                      iconSize: 32,
                    ),
                    Text(
                      '$qty',
                      style: Theme.of(ctx).textTheme.titleLarge,
                    ),
                    IconButton(
                      onPressed: () => setState(() => qty++),
                      icon: const Icon(Icons.add_circle_outline),
                      iconSize: 32,
                    ),
                    const Spacer(),
                    FilledButton(
                      onPressed: () {
                        final mods = <CartModifier>[
                          ...singleChoice.values,
                          ...extraSelected,
                        ];
                        for (var i = 0; i < qty; i++) {
                          ref.read(cartProvider.notifier).addProduct(
                                product: product,
                                hppPerUnit: hpp,
                                modifiers: mods,
                                note: noteCtrl.text.trim(),
                              );
                        }
                        Navigator.of(ctx).pop(true);
                      },
                      child: const Text('Tambah ke Keranjang'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (added == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${product.name} masuk keranjang')),
      );
    }
  }
}

/// Panel keranjang (layar lebar).
class _CartPanel extends ConsumerWidget {
  const _CartPanel({required this.totals, required this.onCheckout});
  final CartTotals totals;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: const Border(left: BorderSide(color: Colors.black12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Text(
                  'Keranjang',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (cart.orderId != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Chip(
                      label: Text('Open bill ${cart.tableName ?? ''}'),
                    ),
                  ),
                const Spacer(),
                if (cart.lines.isNotEmpty)
                  TextButton(
                    onPressed: () =>
                        ref.read(cartProvider.notifier).clear(),
                    child: const Text('Kosongkan'),
                  ),
              ],
            ),
          ),
          Expanded(
            child: cart.lines.isEmpty
                ? const EmptyState(message: 'Keranjang masih kosong.')
                : ListView.builder(
                    itemCount: cart.lines.length,
                    itemBuilder: (ctx, i) {
                      final line = cart.lines[i];
                      return _CartLineTile(index: i, line: line);
                    },
                  ),
          ),
          if (cart.lines.isNotEmpty) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const _PromoRow(),
                  const SizedBox(height: 8),
                  _NumberEditRow(
                    label: 'Diskon',
                    display: cart.discountRp == 0
                        ? 'Rp0'
                        : fmt(cart.discountRp),
                    onEdit: () => _editAmount(
                      context,
                      title: 'Diskon (Rp)',
                      initial: cart.discountRp,
                      onSave: (v) => ref
                          .read(cartProvider.notifier)
                          .setDiscount(v),
                    ),
                  ),
                  Row(
                    children: [
                      const Text('PPN 11%'),
                      Switch(
                        value: cart.ppnEnabled,
                        onChanged: (v) => ref
                            .read(cartProvider.notifier)
                            .setPpn(v),
                      ),
                      const Spacer(),
                      _NumberEditRow(
                        label: 'Service',
                        display: '${cart.serviceRate}%',
                        onEdit: () => _editAmount(
                          context,
                          title: 'Service Charge (%)',
                          initial: cart.serviceRate,
                          onSave: (v) => ref
                              .read(cartProvider.notifier)
                              .setServiceRate(v),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _NumberEditRow(
                        label: 'PB1',
                        display: '${cart.pb1Rate}%',
                        onEdit: () => _editAmount(
                          context,
                          title: 'PB1 (%)',
                          initial: cart.pb1Rate,
                          onSave: (v) => ref
                              .read(cartProvider.notifier)
                              .setPb1Rate(v),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _totalRow('Subtotal', totals.subtotal, context),
                  if (totals.discount > 0)
                    _totalRow('Diskon', -totals.discount, context),
                  if (totals.serviceCharge > 0)
                    _totalRow(
                      'Service / PB1',
                      totals.serviceCharge,
                      context,
                    ),
                  if (totals.tax > 0)
                    _totalRow('PPN 11%', totals.tax, context),
                  if (totals.ojolFee > 0)
                    _totalRow('Komisi ojol', -totals.ojolFee, context),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      MoneyText(
                        totals.total,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text(
                    'Estimasi HPP ${fmt(totals.totalHpp)} • '
                    'Poin didapat ${totals.pointsEarned}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: onCheckout,
                      icon: const Icon(Icons.payment),
                      label: Text('Bayar ${fmt(totals.total)}'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _totalRow(String label, int amount, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), MoneyText(amount)],
      ),
    );
  }

  Future<void> _editAmount(
    BuildContext context, {
    required String title,
    required int initial,
    required void Function(int value) onSave,
  }) async {
    final ctrl = TextEditingController(
      text: initial == 0 ? '' : initial.toString(),
    );
    final saved = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            prefixText: 'Rp ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              final v = int.tryParse(
                    ctrl.text.replaceAll(RegExp(r'[^0-9]'), ''),
                  ) ??
                  0;
              Navigator.of(ctx).pop(v);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    if (saved != null) onSave(saved);
  }
}

/// Baris edit angka: label + nilai + tombol ubah (dialog, bukan
/// TextField di dalam build — supaya kursor tidak lompat tiap ketik).
class _NumberEditRow extends StatelessWidget {
  const _NumberEditRow({
    required this.label,
    required this.display,
    required this.onEdit,
  });
  final String label;
  final String display;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onEdit,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            const SizedBox(width: 4),
            Text(
              display,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.edit, size: 16),
          ],
        ),
      ),
    );
  }
}

/// Baris promo: input kode + chip promo aktif + promo terpasang.
class _PromoRow extends ConsumerStatefulWidget {
  const _PromoRow();

  @override
  ConsumerState<_PromoRow> createState() => _PromoRowState();
}

class _PromoRowState extends ConsumerState<_PromoRow> {
  final _codeCtrl = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final promosAsync = ref.watch(promosProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (cart.promoCode != null)
          Chip(
            label: Text(
              'Promo ${cart.promoCode} '
              '(${cart.promoPercent > 0 ? '${cart.promoPercent}%' : fmt(cart.promoFixedRp)})',
            ),
            onDeleted: () => ref.read(cartProvider.notifier).clearPromo(),
          )
        else
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _codeCtrl,
                  decoration: InputDecoration(
                    labelText: 'Kode promo',
                    border: const OutlineInputBorder(),
                    errorText: _error,
                  ),
                  textCapitalization: TextCapitalization.characters,
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () async {
                  final code = _codeCtrl.text.trim().toUpperCase();
                  final promos = await ref.read(promosProvider.future);
                  final match = promos.where(
                    (p) => p.code.toUpperCase() == code,
                  );
                  if (match.isEmpty) {
                    setState(() => _error = 'Kode tidak ditemukan.');
                    return;
                  }
                  final promo = match.first;
                  if (promo.type == 'persen' && promo.value >= 100) {
                    setState(
                      () => _error =
                          'Promo 100% tidak diizinkan (total Rp0 ditolak).',
                    );
                    return;
                  }
                  setState(() => _error = null);
                  ref.read(cartProvider.notifier).applyPromo(promo);
                  _codeCtrl.clear();
                },
                child: const Text('Pakai'),
              ),
            ],
          ),
        promosAsync.when(
          data: (promos) => promos.isEmpty
              ? const SizedBox.shrink()
              : Wrap(
                  spacing: 6,
                  children: promos
                      .map(
                        (p) => ActionChip(
                          label: Text(
                            '${p.code} — ${p.type == 'persen' ? '${p.value}%' : fmt(p.value)}',
                          ),
                          onPressed: () {
                            if (p.type == 'persen' && p.value >= 100) {
                              setState(
                                () => _error =
                                    'Promo 100% tidak diizinkan.',
                              );
                              return;
                            }
                            ref
                                .read(cartProvider.notifier)
                                .applyPromo(p);
                          },
                        ),
                      )
                      .toList(),
                ),
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}

/// Satu baris keranjang: qty +/-, catatan, modifier, hapus.
class _CartLineTile extends ConsumerWidget {
  const _CartLineTile({required this.index, required this.line});
  final int index;
  final CartLine line;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(line.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (line.modifierLabel.isNotEmpty) Text(line.modifierLabel),
          if (line.note.isNotEmpty) Text('Catatan: ${line.note}'),
          Text(
            '${fmt(line.unitPrice)} x ${line.qty} • HPP ${fmt(line.hppPerUnit)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () => ref
                .read(cartProvider.notifier)
                .setQty(index, line.qty - 1),
          ),
          Text('${line.qty}'),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => ref
                .read(cartProvider.notifier)
                .setQty(index, line.qty + 1),
          ),
          MoneyText(line.lineTotal),
        ],
      ),
      onTap: () => _editLine(context, ref),
    );
  }

  Future<void> _editLine(BuildContext context, WidgetRef ref) async {
    final noteCtrl = TextEditingController(text: line.note);
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(line.name),
        content: TextField(
          controller: noteCtrl,
          decoration: const InputDecoration(
            labelText: 'Catatan per item',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    if (saved == true) {
      ref
          .read(cartProvider.notifier)
          .setLineNote(index, noteCtrl.text.trim());
    }
  }
}

/// Bar total di layar sempit: jumlah item + total + tombol Bayar.
class _MobileCartBar extends ConsumerWidget {
  const _MobileCartBar({required this.totals});
  final CartTotals totals;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    if (cart.lines.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: const Border(top: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${cart.lines.length} item',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                MoneyText(
                  totals.total,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              builder: (ctx) => SizedBox(
                height: MediaQuery.of(ctx).size.height * 0.85,
                child: _CartPanel(
                  totals: totals,
                  onCheckout: () {
                    Navigator.of(ctx).pop();
                    showCheckoutSheet(context, ref);
                  },
                ),
              ),
            ),
            child: const Text('Keranjang'),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: () => showCheckoutSheet(context, ref),
            child: const Text('Bayar'),
          ),
        ],
      ),
    );
  }
}
