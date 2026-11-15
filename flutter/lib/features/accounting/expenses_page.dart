// Casirz ERP — Fase 4 (Modul C Akuntansi).
// Beban OPEX: catat beban (kategori -> akun 51xx, jumlah, tanggal,
// tunai/bank, keterangan) -> jurnal D 51xx / K 1000 atau K 1010.
// Daftar beban + filter kategori/bulan. Gaji/payroll lengkapnya di
// Fase 5 (Staf); di sini catat beban gaji manual tetap bisa.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/accounting_service.dart';
import '../../core/db.dart';
import '../../core/money.dart';
import '../../shared/widgets/common.dart';
import '../../shared/widgets/money_text.dart';
import '../pos/pos_providers.dart';
import '../staff/staff_page.dart';
import 'accounting_providers.dart';

String _fmtDate(int epochMs) {
  final d = DateTime.fromMillisecondsSinceEpoch(epochMs);
  return DateFormat('dd MMM yyyy', 'id_ID').format(d);
}

String _monthKey(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}';

String _monthLabel(String key) {
  final parts = key.split('-');
  final d = DateTime(int.parse(parts[0]), int.parse(parts[1]));
  return DateFormat('MMMM yyyy', 'id_ID').format(d);
}

class ExpensesPage extends ConsumerStatefulWidget {
  const ExpensesPage({super.key});

  @override
  ConsumerState<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends ConsumerState<ExpensesPage> {
  String _category = 'Listrik';
  var _amount = 0;
  var _payFrom = 'tunai';
  var _date = DateTime.now();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  var _filterCategory = 'Semua';
  var _filterMonth = 'Semua';
  var _busy = false;
  String? _result;

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(accountingVersionProvider);
    final expensesAsync = ref.watch(expensesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Beban OPEX')),
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
                    'Catat Beban',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _category,
                    decoration: const InputDecoration(
                      labelText: 'Kategori',
                      border: OutlineInputBorder(),
                    ),
                    items: AccountingService.opexAccounts.keys
                        .map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Text(
                              '$c (${AccountingService.opexAccounts[c]})',
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _category = v);
                    },
                  ),
                  const SizedBox(height: 12),
                  RpInput(
                    controller: _amountCtrl,
                    label: 'Jumlah',
                    onChanged: (v) => _amount = v,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text('Tanggal: ${_fmtDate(_date.millisecondsSinceEpoch)}'),
                      ),
                      TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _date,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) setState(() => _date = picked);
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
                  TextField(
                    controller: _noteCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Keterangan',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: _busy ? null : _save,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text('Simpan Beban'),
                  ),
                  if (_result != null) ...[
                    const SizedBox(height: 12),
                    Text(_result!),
                  ],
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const StaffPage(initialTab: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.payments),
                    label: const Text('Buka Payroll (Fase 5)'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Catatan: gaji lengkap lewat Payroll di menu Staf — '
                    'proses gaji menjurnal otomatis D 5130 / K 1000 '
                    '(tunai) atau K 1010 (bank) dan idempotent per '
                    'karyawan + periode. Beban gaji manual tetap bisa '
                    'dicatat di sini (Owner/Manager).',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          expensesAsync.when(
            data: (expenses) {
              final months = <String>{
                for (final e in expenses)
                  _monthKey(
                    DateTime.fromMillisecondsSinceEpoch(e.date),
                  ),
              }.toList()
                ..sort((a, b) => b.compareTo(a));
              final filtered = expenses.where((e) {
                if (_filterCategory != 'Semua' &&
                    e.category != _filterCategory) {
                  return false;
                }
                if (_filterMonth != 'Semua' &&
                    _monthKey(
                          DateTime.fromMillisecondsSinceEpoch(e.date),
                        ) !=
                        _filterMonth) {
                  return false;
                }
                return true;
              }).toList();
              final total =
                  filtered.fold<int>(0, (s, e) => s + e.amount);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _filterCategory,
                          decoration: const InputDecoration(
                            labelText: 'Filter kategori',
                            border: OutlineInputBorder(),
                          ),
                          items: ['Semua', ...AccountingService.opexAccounts.keys]
                              .map(
                                (c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(c),
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            if (v != null) {
                              setState(() => _filterCategory = v);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _filterMonth,
                          decoration: const InputDecoration(
                            labelText: 'Filter bulan',
                            border: OutlineInputBorder(),
                          ),
                          items: ['Semua', ...months]
                              .map(
                                (m) => DropdownMenuItem(
                                  value: m,
                                  child: Text(
                                    m == 'Semua' ? 'Semua' : _monthLabel(m),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            if (v != null) {
                              setState(() => _filterMonth = v);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total tampil (${filtered.length} beban)',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          MoneyText(
                            total,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (filtered.isEmpty)
                    const EmptyState(
                      message: 'Tidak ada beban untuk filter ini.',
                    )
                  else
                    for (final e in filtered) _ExpenseTile(expense: e),
                ],
              );
            },
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Gagal memuat beban: $e'),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (_amount <= 0) {
      setState(() => _result = 'Jumlah beban harus > 0.');
      return;
    }
    setState(() {
      _busy = true;
      _result = null;
    });
    try {
      final db = ref.read(databaseProvider);
      final account =
          AccountingService.expenseAccountForCategory(_category);
      final savedAmount = _amount;
      final savedCategory = _category;
      await AccountingService.recordExpense(
        db,
        date: _date,
        category: _category,
        amount: _amount,
        accountCode: account,
        note: _noteCtrl.text.trim().isEmpty
            ? _category
            : _noteCtrl.text.trim(),
        payFrom: _payFrom,
      );
      ref.read(accountingVersionProvider.notifier).state++;
      _amountCtrl.clear();
      _noteCtrl.clear();
      _amount = 0;
      setState(() {
        _result = 'Beban $savedCategory ${fmt(savedAmount)} tercatat '
            '(D $account / K ${_payFrom == 'bank' ? '1010' : '1000'}).';
      });
    } catch (e) {
      setState(() => _result = 'Gagal menyimpan beban: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

class _ExpenseTile extends StatelessWidget {
  const _ExpenseTile({required this.expense});
  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('${expense.category} — ${expense.note}'),
        subtitle: Text(
          '${_fmtDate(expense.date)} · akun ${expense.accountCode}',
        ),
        trailing: MoneyText(
          expense.amount,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
