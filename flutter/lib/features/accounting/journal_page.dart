// Casirz ERP — Fase 4 (Modul C Akuntansi).
// Jurnal & Buku Besar: daftar jurnal terbaru (tanggal, memo, ref,
// total debit = kredit), detail per jurnal (baris D/K per akun),
// filter per akun + rentang tanggal, saldo per akun.
// Jurnal TIDAK bisa diedit/dihapus dari UI — append-only; koreksi hanya
// lewat jurnal pembalik (ditulis jelas di layar).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/accounts.dart';
import '../../core/money.dart';
import '../../shared/widgets/common.dart';
import '../../shared/widgets/money_text.dart';
import '../pos/pos_providers.dart';
import 'accounting_providers.dart';

String _fmtDateTime(int epochMs) {
  final d = DateTime.fromMillisecondsSinceEpoch(epochMs);
  return DateFormat('dd MMM yyyy HH:mm', 'id_ID').format(d);
}

String _fmtDate(int epochMs) {
  final d = DateTime.fromMillisecondsSinceEpoch(epochMs);
  return DateFormat('dd MMM yyyy', 'id_ID').format(d);
}

class JournalPage extends ConsumerStatefulWidget {
  const JournalPage({super.key});

  @override
  ConsumerState<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends ConsumerState<JournalPage> {
  String? _accountCode;
  late DateTime _from;
  late DateTime _to;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _from = DateTime(now.year, now.month, 1);
    _to = now;
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(accountingVersionProvider);
    final balancesAsync = ref.watch(balancesProvider);
    final db = ref.read(databaseProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Jurnal & Buku Besar')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const Card(
            color: Color(0xFFFFF8E1),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Jurnal bersifat append-only: tidak bisa diedit atau dihapus '
                'dari UI. Salah catat dikoreksi dengan jurnal pembalik baru '
                '(bukan dengan mengubah jurnal lama).',
              ),
            ),
          ),
          const SizedBox(height: 12),
          ExpansionTile(
            title: const Text('Saldo per Akun (Buku Besar)'),
            children: [
              balancesAsync.when(
                data: (balances) => Column(
                  children: [
                    for (final def in ChartOfAccounts.all)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 2,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${def.code} — ${def.name}'),
                            MoneyText(
                              balances[def.code] ?? 0,
                              style: TextStyle(
                                color: (balances[def.code] ?? 0) == 0
                                    ? Theme.of(context)
                                        .colorScheme
                                        .outline
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Gagal memuat saldo: $e'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String?>(
                    initialValue: _accountCode,
                    decoration: const InputDecoration(
                      labelText: 'Filter akun',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Semua akun'),
                      ),
                      for (final def in ChartOfAccounts.all)
                        DropdownMenuItem(
                          value: def.code,
                          child: Text('${def.code} — ${def.name}'),
                        ),
                    ],
                    onChanged: (v) => setState(() => _accountCode = v),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text('Dari: ${_fmtDate(_from.millisecondsSinceEpoch)}'),
                      ),
                      TextButton(
                        onPressed: () => _pickDate(true),
                        child: const Text('Pilih'),
                      ),
                      Expanded(
                        child: Text('Sampai: ${_fmtDate(_to.millisecondsSinceEpoch)}'),
                      ),
                      TextButton(
                        onPressed: () => _pickDate(false),
                        child: const Text('Pilih'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          FutureBuilder<List<JournalWithLines>>(
            future: AccountingQueries.journalsWithLines(
              db,
              accountCode: _accountCode,
              from: _from,
              to: _to,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Text('Gagal memuat jurnal: ${snapshot.error}');
              }
              final items = snapshot.data ?? [];
              if (items.isEmpty) {
                return const EmptyState(
                  message: 'Tidak ada jurnal untuk filter ini.',
                );
              }
              return Column(
                children: [
                  for (final item in items) _JournalTile(item: item),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate(bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? _from : _to,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked == null) return;
    setState(() {
      if (isFrom) {
        _from = picked;
        if (_to.isBefore(_from)) _to = _from;
      } else {
        _to = picked;
        if (_from.isAfter(_to)) _from = _to;
      }
    });
  }
}

class _JournalTile extends StatelessWidget {
  const _JournalTile({required this.item});
  final JournalWithLines item;

  @override
  Widget build(BuildContext context) {
    final totalDebit =
        item.lines.fold<int>(0, (s, l) => s + l.debit);
    final totalCredit =
        item.lines.fold<int>(0, (s, l) => s + l.credit);
    return Card(
      child: ListTile(
        title: Text(item.journal.memo),
        subtitle: Text(
          '${_fmtDateTime(item.journal.date)} · '
          '${item.journal.refType}:${item.journal.refId}'
          '${item.journal.isReversal == 1 ? ' · PEMBALIK' : ''}',
        ),
        trailing: MoneyText(
          totalDebit,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: () => _showDetail(context, totalDebit, totalCredit),
      ),
    );
  }

  void _showDetail(
    BuildContext context,
    int totalDebit,
    int totalCredit,
  ) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(item.journal.memo),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_fmtDateTime(item.journal.date)),
              Text('Ref: ${item.journal.refType}:${item.journal.refId}'),
              if (item.journal.isReversal == 1)
                const Text('Jurnal pembalik (koreksi jurnal asal).'),
              const SizedBox(height: 12),
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(3),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                },
                children: [
                  const TableRow(
                    children: [
                      Text(
                        'Akun',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Debit',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Kredit',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  for (final line in item.lines)
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            '${line.accountCode} — ${_accountName(line.accountCode)}',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            line.debit > 0 ? fmt(line.debit) : '-',
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            line.credit > 0 ? fmt(line.credit) : '-',
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Text(
                          'Total',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          fmt(totalDebit),
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          fmt(totalCredit),
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                totalDebit == totalCredit
                    ? 'Seimbang (debit = kredit).'
                    : 'TIDAK SEIMBANG — laporkan ke koordinator.',
                style: TextStyle(
                  color: totalDebit == totalCredit
                      ? Colors.green.shade700
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
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

  String _accountName(String code) {
    try {
      return ChartOfAccounts.byCode(code).name;
    } catch (_) {
      return '-';
    }
  }
}
