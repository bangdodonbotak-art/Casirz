// Casirz ERP — Fase 4 (Modul C Akuntansi).
// Aset Tetap: daftar aset (biaya, masa manfaat, residu, tanggal beli,
// akumulasi, nilai buku) + tambah aset (jurnal D 1300 / K 1000 atau
// K 1010) + penyusutan garis lurus bulanan (tombol "Proses Penyusutan
// Bulan Ini", idempotent per refId asset:<id>:<yyyy-MM>) + jadwal
// penyusutan per aset (bulan terakhir = sisa pembulatan).
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

/// Bulan (yyyy-MM) ke-n setelah [start] (n = 0 -> bulan beli).
String _monthAfter(DateTime start, int n) {
  final total = (start.year * 12 + (start.month - 1)) + n;
  final y = total ~/ 12;
  final m = total % 12 + 1;
  return '$y-${m.toString().padLeft(2, '0')}';
}

class AssetsPage extends ConsumerStatefulWidget {
  const AssetsPage({super.key});

  @override
  ConsumerState<AssetsPage> createState() => _AssetsPageState();
}

class _AssetsPageState extends ConsumerState<AssetsPage> {
  final _nameCtrl = TextEditingController();
  final _costCtrl = TextEditingController();
  final _residualCtrl = TextEditingController(text: '0');
  final _lifeCtrl = TextEditingController(text: '60');
  var _cost = 0;
  var _residual = 0;
  var _payFrom = 'tunai';
  var _purchaseDate = DateTime.now();
  var _busy = false;
  String? _result;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _costCtrl.dispose();
    _residualCtrl.dispose();
    _lifeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(accountingVersionProvider);
    final assetsAsync = ref.watch(assetsProvider);
    final now = DateTime.now();
    return Scaffold(
      appBar: AppBar(title: const Text('Aset Tetap')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Proses Penyusutan — ${_monthKey(now)}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Garis lurus: (biaya − residu) / masa manfaat per bulan. '
                    'Aman ditekan 2x — bulan yang sudah diproses tidak '
                    'dijurnal ulang.',
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: _busy ? null : _processDepreciation,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text('Proses Penyusutan Bulan Ini'),
                  ),
                  if (_result != null) ...[
                    const SizedBox(height: 12),
                    Text(_result!),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          assetsAsync.when(
            data: (assets) {
              if (assets.isEmpty) {
                return const EmptyState(
                  message: 'Belum ada aset tetap. Tambah aset di bawah.',
                );
              }
              final totalBook = assets.fold<int>(
                0,
                (s, a) => s + AccountingService.bookValue(a),
              );
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Nilai Buku Aset',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          MoneyText(
                            totalBook,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (final asset in assets) _AssetCard(
                    asset: asset,
                    onSchedule: () => _showSchedule(context, asset),
                  ),
                ],
              );
            },
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Gagal memuat aset: $e'),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Tambah Aset Baru',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nama aset',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  RpInput(
                    controller: _costCtrl,
                    label: 'Biaya perolehan (D 1300)',
                    onChanged: (v) => _cost = v,
                  ),
                  const SizedBox(height: 12),
                  RpInput(
                    controller: _residualCtrl,
                    label: 'Nilai residu',
                    onChanged: (v) => _residual = v,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _lifeCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Masa manfaat (bulan)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Tanggal beli: ${_fmtDate(_purchaseDate.millisecondsSinceEpoch)}',
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _purchaseDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() => _purchaseDate = picked);
                          }
                        },
                        child: const Text('Pilih Tanggal'),
                      ),
                    ],
                  ),
                  DropdownButtonFormField<String>(
                    initialValue: _payFrom,
                    decoration: const InputDecoration(
                      labelText: 'Dibayar dari',
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
                    onPressed: _busy ? null : _addAsset,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text('Simpan Aset'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _processDepreciation() async {
    setState(() {
      _busy = true;
      _result = null;
    });
    try {
      final db = ref.read(databaseProvider);
      final month = _monthKey(DateTime.now());
      final total = await AccountingService.processDepreciation(db, month);
      ref.read(accountingVersionProvider.notifier).state++;
      setState(() {
        _result = total > 0
            ? 'Penyusutan $month: ${fmt(total)} (D 5180 / K 1310).'
            : 'Penyusutan $month sudah diproses sebelumnya / tidak ada aset '
                'yang disusutkan bulan ini.';
      });
    } catch (e) {
      setState(() => _result = 'Gagal memproses penyusutan: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _addAsset() async {
    final life = int.tryParse(_lifeCtrl.text) ?? 0;
    if (_nameCtrl.text.trim().isEmpty || _cost <= 0 || life <= 0) {
      setState(
        () => _result = 'Isi nama, biaya perolehan > 0, dan masa manfaat > 0.',
      );
      return;
    }
    setState(() {
      _busy = true;
      _result = null;
    });
    try {
      final db = ref.read(databaseProvider);
      await AccountingService.recordAsset(
        db,
        name: _nameCtrl.text,
        purchaseDate: _purchaseDate,
        cost: _cost,
        residualValue: _residual,
        usefulLifeMonths: life,
        payFrom: _payFrom,
      );
      ref.read(accountingVersionProvider.notifier).state++;
      _nameCtrl.clear();
      _costCtrl.clear();
      _cost = 0;
      setState(() {
        _result = 'Aset tercatat (D 1300 / K ${_payFrom == 'bank' ? '1010' : '1000'}).';
      });
    } catch (e) {
      setState(() => _result = 'Gagal menambah aset: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showSchedule(BuildContext context, Asset asset) {
    final amounts = AccountingService.depreciationScheduleAmounts(
      cost: asset.cost,
      residualValue: asset.residualValue,
      usefulLifeMonths: asset.usefulLifeMonths,
    );
    final start =
        DateTime.fromMillisecondsSinceEpoch(asset.purchaseDate);
    // Bulan yang sudah diproses: jalan dari awal sampai akumulasi tercapai.
    var walked = 0;
    final processed = <int>{};
    for (var i = 0; i < amounts.length; i++) {
      if (walked >= asset.accumulatedDepreciation) break;
      processed.add(i);
      walked += amounts[i];
    }
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Jadwal Penyusutan — ${asset.name}'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: amounts.length,
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_monthAfter(start, i)}${processed.contains(i) ? ' ✓' : ''}',
                  ),
                  MoneyText(amounts[i]),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}

class _AssetCard extends StatelessWidget {
  const _AssetCard({required this.asset, required this.onSchedule});
  final Asset asset;
  final VoidCallback onSchedule;

  @override
  Widget build(BuildContext context) {
    final book = AccountingService.bookValue(asset);
    return Card(
      child: ListTile(
        title: Text(asset.name),
        subtitle: Text(
          'Beli ${_fmtDate(asset.purchaseDate)} · '
          '${asset.usefulLifeMonths} bln · residu ${fmt(asset.residualValue)}\n'
          'Akumulasi penyusutan: ${fmt(asset.accumulatedDepreciation)}'
          '${asset.lastDepreciationMonth != null ? ' · terakhir ${asset.lastDepreciationMonth}' : ''}',
        ),
        isThreeLine: true,
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text('Nilai buku', style: TextStyle(fontSize: 11)),
            MoneyText(
              book,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        onTap: onSchedule,
      ),
    );
  }
}
