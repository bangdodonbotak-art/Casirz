// Casirz ERP — Fase 4 (Modul C Akuntansi).
// Modal Awal & Saldo Awal: form sekali isi (Kas Tunai, Bank, Sewa
// Dibayar di Muka + masa sewa, Persediaan, Aset Tetap) -> jurnal
// D 1000/1010/1200/1300/1100 / K 3000 Modal Disetor.
// Bila sudah tercatat (termasuk seed demo 'seed-modal'), form terkunci
// dan hanya menampilkan jurnal yang terbentuk + penjelasan. Reset hanya
// lewat reset demo/seed di Pengaturan — tidak ada tombol reset di sini.
// Sewa diamortisasi bulanan via tombol di bawah (D 5190 / K 1200,
// idempotent per bulan — lihat AccountingService).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/accounting_service.dart';
import '../../core/db.dart';
import '../../core/money.dart';
import '../../shared/widgets/common.dart';
import '../../shared/widgets/money_text.dart';
import '../pos/pos_providers.dart';
import 'accounting_providers.dart';

String _monthKey(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}';

String _fmtDate(int epochMs) {
  final d = DateTime.fromMillisecondsSinceEpoch(epochMs);
  return DateFormat('dd MMM yyyy', 'id_ID').format(d);
}

class CapitalPage extends ConsumerStatefulWidget {
  const CapitalPage({super.key});

  @override
  ConsumerState<CapitalPage> createState() => _CapitalPageState();
}

class _CapitalPageState extends ConsumerState<CapitalPage> {
  final _cashCtrl = TextEditingController();
  final _bankCtrl = TextEditingController();
  final _rentCtrl = TextEditingController();
  final _inventoryCtrl = TextEditingController();
  final _assetsCtrl = TextEditingController();
  final _rentMonthsCtrl = TextEditingController(text: '12');
  var _cash = 0;
  var _bank = 0;
  var _rent = 0;
  var _inventory = 0;
  var _assets = 0;
  var _busy = false;
  String? _result;

  @override
  void dispose() {
    _cashCtrl.dispose();
    _bankCtrl.dispose();
    _rentCtrl.dispose();
    _inventoryCtrl.dispose();
    _assetsCtrl.dispose();
    _rentMonthsCtrl.dispose();
    super.dispose();
  }

  int get _total => _cash + _bank + _rent + _inventory + _assets;

  int get _rentMonths => int.tryParse(_rentMonthsCtrl.text) ?? 0;

  @override
  Widget build(BuildContext context) {
    ref.watch(accountingVersionProvider);
    final capitalAsync = ref.watch(capitalJournalProvider);
    final rentAsync = ref.watch(rentSettingsProvider);
    final balancesAsync = ref.watch(balancesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Modal Awal & Saldo Awal')),
      body: capitalAsync.when(
        data: (journal) {
          if (journal != null) {
            return _LockedView(
              journal: journal,
              rentSettings: rentAsync.value,
              prepaidBalance:
                  balancesAsync.value?['1200'] ?? 0,
              onAmortize: _processRent,
              busy: _busy,
              result: _result,
            );
          }
          return _FormView(
            cashCtrl: _cashCtrl,
            bankCtrl: _bankCtrl,
            rentCtrl: _rentCtrl,
            inventoryCtrl: _inventoryCtrl,
            assetsCtrl: _assetsCtrl,
            rentMonthsCtrl: _rentMonthsCtrl,
            onCash: (v) => setState(() => _cash = v),
            onBank: (v) => setState(() => _bank = v),
            onRent: (v) => setState(() => _rent = v),
            onInventory: (v) => setState(() => _inventory = v),
            onAssets: (v) => setState(() => _assets = v),
            onMonthsChanged: (_) => setState(() {}),
            total: _total,
            rent: _rent,
            rentMonths: _rentMonths,
            busy: _busy,
            result: _result,
            onSave: _save,
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Gagal memuat: $e')),
      ),
    );
  }

  Future<void> _save() async {
    if (_total <= 0) {
      setState(() => _result = 'Isi minimal satu komponen modal (total > 0).');
      return;
    }
    if (_rent > 0 && _rentMonths <= 0) {
      setState(
        () => _result = 'Masa sewa harus > 0 bulan bila ada sewa muka.',
      );
      return;
    }
    setState(() {
      _busy = true;
      _result = null;
    });
    try {
      final db = ref.read(databaseProvider);
      final now = DateTime.now();
      await AccountingService.recordCapital(
        db,
        date: now,
        cash: _cash,
        bank: _bank,
        rentPrepaid: _rent,
        assets: _assets,
        inventory: _inventory,
      );
      if (_rent > 0) {
        await db.setSetting('rentTotal', '$_rent');
        await db.setSetting('rentMonths', '$_rentMonths');
        await db.setSetting('rentStartMonth', _monthKey(now));
      }
      ref.read(accountingVersionProvider.notifier).state++;
      ref.read(settingsVersionProvider.notifier).state++;
      setState(() {
        _result = 'Modal awal ${_fmtTotal()} tercatat. '
            'Jurnal: D Kas/Bank/Sewa/Aset/Persediaan / K 3000 Modal Disetor.';
      });
    } catch (e) {
      setState(() => _result = 'Gagal menyimpan modal awal: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _fmtTotal() => fmt(_total);

  Future<void> _processRent() async {
    setState(() {
      _busy = true;
      _result = null;
    });
    try {
      final db = ref.read(databaseProvider);
      final month = _monthKey(DateTime.now());
      final amount =
          await AccountingService.processRentAmortization(db, month);
      ref.read(accountingVersionProvider.notifier).state++;
      setState(() {
        _result = amount > 0
            ? 'Amortisasi sewa $month: ${fmt(amount)} '
                '(D 5190 / K 1200).'
            : 'Amortisasi sewa $month sudah diproses / di luar masa sewa.';
      });
    } catch (e) {
      setState(() => _result = 'Gagal memproses amortisasi: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

class _FormView extends StatelessWidget {
  const _FormView({
    required this.cashCtrl,
    required this.bankCtrl,
    required this.rentCtrl,
    required this.inventoryCtrl,
    required this.assetsCtrl,
    required this.rentMonthsCtrl,
    required this.onCash,
    required this.onBank,
    required this.onRent,
    required this.onInventory,
    required this.onAssets,
    required this.onMonthsChanged,
    required this.total,
    required this.rent,
    required this.rentMonths,
    required this.busy,
    required this.result,
    required this.onSave,
  });
  final TextEditingController cashCtrl;
  final TextEditingController bankCtrl;
  final TextEditingController rentCtrl;
  final TextEditingController inventoryCtrl;
  final TextEditingController assetsCtrl;
  final TextEditingController rentMonthsCtrl;
  final void Function(int) onCash;
  final void Function(int) onBank;
  final void Function(int) onRent;
  final void Function(int) onInventory;
  final void Function(int) onAssets;
  final void Function(String) onMonthsChanged;
  final int total;
  final int rent;
  final int rentMonths;
  final bool busy;
  final String? result;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const Card(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Modal awal hanya bisa dicatat SEKALI. Isi sesuai uang/aset '
              'yang benar-benar disetor saat usaha mulai — jurnal yang '
              'terbentuk tidak bisa diedit (append-only).',
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Bentuk Modal Disetor',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                RpInput(
                  controller: cashCtrl,
                  label: 'Kas Tunai Awal (D 1000)',
                  onChanged: onCash,
                ),
                const SizedBox(height: 12),
                RpInput(
                  controller: bankCtrl,
                  label: 'Saldo Bank Awal (D 1010)',
                  onChanged: onBank,
                ),
                const SizedBox(height: 12),
                RpInput(
                  controller: rentCtrl,
                  label: 'Sewa Dibayar di Muka (D 1200)',
                  onChanged: onRent,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: rentMonthsCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Masa sewa (bulan)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: onMonthsChanged,
                ),
                if (rent > 0 && rentMonths > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Amortisasi otomatis: ${fmt(rent ~/ rentMonths)}/bulan '
                      '(D 5190 / K 1200).',
                    ),
                  ),
                const SizedBox(height: 12),
                RpInput(
                  controller: inventoryCtrl,
                  label: 'Persediaan Awal — bahan (D 1100, opsional)',
                  onChanged: onInventory,
                ),
                const SizedBox(height: 12),
                RpInput(
                  controller: assetsCtrl,
                  label: 'Aset Tetap (D 1300, opsional)',
                  onChanged: onAssets,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Modal Disetor (K 3000)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    MoneyText(
                      total,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: busy ? null : onSave,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: busy
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Simpan Modal Awal'),
                ),
                if (result != null) ...[
                  const SizedBox(height: 12),
                  Text(result!),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LockedView extends ConsumerWidget {
  const _LockedView({
    required this.journal,
    required this.rentSettings,
    required this.prepaidBalance,
    required this.onAmortize,
    required this.busy,
    required this.result,
  });
  final Journal journal;
  final Map<String, String?>? rentSettings;
  final int prepaidBalance;
  final Future<void> Function() onAmortize;
  final bool busy;
  final String? result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final linesAsync = ref.watch(journalLinesProvider(journal.id));
    final rentTotal =
        int.tryParse(rentSettings?['rentTotal'] ?? '') ?? 0;
    final rentMonths =
        int.tryParse(rentSettings?['rentMonths'] ?? '') ?? 0;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Card(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          child: const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Modal awal SUDAH tercatat dan terkunci. Jurnal tidak bisa '
              'diubah/dihapus. Bila salah catat, koreksi lewat jurnal '
              'pembalik (Fase 4 — minta bantuan koordinator), atau reset '
              'demo/seed di Pengaturan untuk mulai dari nol.',
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jurnal Modal Awal',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(journal.memo),
                Text(
                  '${_fmtDate(journal.date)} · ref ${journal.refType}:${journal.refId}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                linesAsync.when(
                  data: (lines) => Column(
                    children: [
                      for (final line in lines)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${line.accountCode} — ${line.debit > 0 ? 'D' : 'K'}',
                              ),
                              MoneyText(
                                line.debit > 0 ? line.debit : line.credit,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Gagal memuat baris: $e'),
                ),
              ],
            ),
          ),
        ),
        if (rentTotal > 0) ...[
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Amortisasi Sewa',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text('Sewa total: ${fmt(rentTotal)}'),
                  Text(
                    'Masa sewa: $rentMonths bulan · '
                    'Mulai: ${rentSettings?['rentStartMonth'] ?? '-'}',
                  ),
                  Text(
                    'Amortisasi/bulan: ${fmt(rentMonths > 0 ? rentTotal ~/ rentMonths : 0)}',
                  ),
                  Text('Sisa sewa muka (1200): ${fmt(prepaidBalance)}'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: busy ? null : onAmortize,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text('Proses Amortisasi Sewa Bulan Ini'),
                  ),
                  if (result != null) ...[
                    const SizedBox(height: 12),
                    Text(result!),
                  ],
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
