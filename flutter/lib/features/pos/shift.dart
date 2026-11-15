// Casirz ERP — Fase 2.
// Shift & laci kas: buka shift (wajib Opening Float), Petty Cash
// (isi + belanja + alasan), tutup shift = rekonsiliasi
// (kas harapan vs kas fisik -> selisih ke akun Selisih Kas 5220
// via engine), laporan shift ringkas.
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db.dart';
import '../../core/money.dart';
import '../../shared/widgets/money_text.dart';
import '../staff/staff_providers.dart';
import 'pos_providers.dart';
import 'shift_service.dart';

class ShiftPage extends ConsumerStatefulWidget {
  const ShiftPage({super.key});

  @override
  ConsumerState<ShiftPage> createState() => _ShiftPageState();
}

class _ShiftPageState extends ConsumerState<ShiftPage> {
  Future<void> _bumpShift() async {
    ref.read(shiftVersionProvider.notifier).state++;
  }

  @override
  Widget build(BuildContext context) {
    final shiftAsync = ref.watch(activeShiftProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Shift & Laci Kas')),
      body: shiftAsync.when(
        data: (shift) {
          if (shift == null) {
            return _OpenShiftForm(onOpened: _bumpShift);
          }
          return _ActiveShiftView(shift: shift, onClosed: _bumpShift);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Gagal memuat shift: $e')),
      ),
    );
  }
}

/// Form buka shift: Opening Float WAJIB diisi.
class _OpenShiftForm extends ConsumerStatefulWidget {
  const _OpenShiftForm({required this.onOpened});
  final VoidCallback onOpened;

  @override
  ConsumerState<_OpenShiftForm> createState() => _OpenShiftFormState();
}

class _OpenShiftFormState extends ConsumerState<_OpenShiftForm> {
  final _floatCtrl = TextEditingController();
  String? _error;
  var _busy = false;

  @override
  void dispose() {
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Tidak ada shift yang terbuka.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Text(
            'Buka Shift',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _floatCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Opening Float (modal kasir harian, Rp) *',
              border: OutlineInputBorder(),
              prefixText: 'Rp ',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Opening float adalah uang modal di laci saat shift dibuka. '
            'Wajib diisi (boleh 0 bila laci kosong).',
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _busy
                ? null
                : () async {
                    final text = _floatCtrl.text.replaceAll(
                      RegExp(r'[^0-9]'),
                      '',
                    );
                    if (text.isEmpty) {
                      setState(
                        () => _error = 'Opening float wajib diisi.',
                      );
                      return;
                    }
                    final amount = int.tryParse(text) ?? 0;
                    setState(() {
                      _busy = true;
                      _error = null;
                    });
                    try {
                      // Shift dicatat atas karyawan yang login (Fase 6);
                      // tanpa sesi -> null ("Tanpa login").
                      final employeeId =
                          ref.read(sessionProvider).employee?.id;
                      await ShiftService.openShift(
                        ref.read(databaseProvider),
                        openingFloat: amount,
                        employeeId: employeeId,
                      );
                      widget.onOpened();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Shift dibuka, float ${fmt(amount)}.',
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        setState(() => _error = '$e');
                      }
                    } finally {
                      if (mounted) setState(() => _busy = false);
                    }
                  },
            child: const Text('Buka Shift'),
          ),
          const SizedBox(height: 24),
          _PastShiftsList(db: ref.watch(databaseProvider)),
        ],
      ),
    );
  }
}

/// Tampilan shift aktif: ringkasan + petty + tutup shift.
class _ActiveShiftView extends ConsumerStatefulWidget {
  const _ActiveShiftView({required this.shift, required this.onClosed});
  final Shift shift;
  final VoidCallback onClosed;

  @override
  ConsumerState<_ActiveShiftView> createState() => _ActiveShiftViewState();
}

class _ActiveShiftViewState extends ConsumerState<_ActiveShiftView> {
  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    final shift = widget.shift;
    final opened = DateTime.fromMillisecondsSinceEpoch(shift.openedAt);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shift aktif',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    'Dibuka ${_pad2(opened.day)}/${_pad2(opened.month)}/${opened.year} '
                    '${_pad2(opened.hour)}:${_pad2(opened.minute)}',
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Opening Float'),
                      MoneyText(shift.openingFloat),
                    ],
                  ),
                  FutureBuilder<Map<String, int>>(
                    future: ShiftService.shiftSummary(db, shift.id),
                    builder: (ctx, snap) {
                      final s = snap.data;
                      if (s == null) {
                        return const Text('Memuat ringkasan...');
                      }
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Transaksi'),
                              Text('${s['transactions']}'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Omzet'),
                              MoneyText(s['total'] ?? 0),
                            ],
                          ),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Tunai (netto)'),
                              MoneyText(s['tunaiNet'] ?? 0),
                            ],
                          ),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('QRIS / E-Wallet'),
                              MoneyText(s['qris'] ?? 0),
                            ],
                          ),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Bank (Transfer/Debit)'),
                              MoneyText(s['bank'] ?? 0),
                            ],
                          ),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Ojol (netto)'),
                              MoneyText(s['ojol'] ?? 0),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  FutureBuilder<int>(
                    future: ShiftService.expectedCash(db, shift.id),
                    builder: (ctx, snap) {
                      if (!snap.hasData) {
                        return const Text('Menghitung kas harapan...');
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Kas harapan di laci',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          MoneyText(
                            snap.data!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pettyFill(context, ref),
                  icon: const Icon(Icons.add),
                  label: const Text('Isi Petty'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pettySpend(context, ref),
                  icon: const Icon(Icons.remove),
                  label: const Text('Belanja Petty'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => _closeShift(context, ref),
            icon: const Icon(Icons.lock),
            label: const Text('Tutup Shift (Rekonsiliasi)'),
          ),
          const SizedBox(height: 24),
          _PastShiftsList(db: db),
        ],
      ),
    );
  }

  String _pad2(int n) => n.toString().padLeft(2, '0');

  Future<void> _pettyFill(BuildContext context, WidgetRef ref) async {
    final amountCtrl = TextEditingController();
    final noteCtrl = TextEditingController(text: 'Isi petty cash');
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Isi Petty Cash'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah (Rp)',
                border: OutlineInputBorder(),
                prefixText: 'Rp ',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteCtrl,
              decoration: const InputDecoration(
                labelText: 'Keterangan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            const Text('Uang diambil dari laci (D 1030 / K 1000).'),
          ],
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
    if (ok != true) return;
    final amount = int.tryParse(
          amountCtrl.text.replaceAll(RegExp(r'[^0-9]'), ''),
        ) ??
        0;
    if (amount <= 0) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jumlah isi petty harus > 0.')),
        );
      }
      return;
    }
    try {
      // Petty dicatat atas karyawan yang login; tanpa sesi pakai
      // karyawan aktif pertama (pettyCash.employeeId tidak boleh null).
      final employeeId = await _pettyEmployeeId(ref);
      await ShiftService.fillPetty(
        ref.read(databaseProvider),
        amount: amount,
        employeeId: employeeId,
        shiftId: widget.shift.id,
        note: noteCtrl.text.trim().isEmpty
            ? 'Isi petty cash'
            : noteCtrl.text.trim(),
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Petty diisi ${fmt(amount)}.')),
        );
      }
      setState(() {});
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        );
      }
    }
  }

  Future<void> _pettySpend(BuildContext context, WidgetRef ref) async {
    final amountCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    var accountCode = '5170';
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Belanja dari Petty'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah (Rp)',
                  border: OutlineInputBorder(),
                  prefixText: 'Rp ',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: accountCode,
                decoration: const InputDecoration(
                  labelText: 'Kategori beban',
                  border: OutlineInputBorder(),
                ),
                items: pettyExpenseAccounts.entries
                    .map(
                      (e) => DropdownMenuItem(
                        value: e.key,
                        child: Text('${e.key} — ${e.value}'),
                      ),
                    )
                    .toList(),
                onChanged: (v) =>
                    setState(() => accountCode = v ?? '5170'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noteCtrl,
                decoration: const InputDecoration(
                  labelText: 'Alasan (wajib)',
                  border: OutlineInputBorder(),
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
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
    if (ok != true) return;
    final amount = int.tryParse(
          amountCtrl.text.replaceAll(RegExp(r'[^0-9]'), ''),
        ) ??
        0;
    try {
      final employeeId = await _pettyEmployeeId(ref);
      await ShiftService.spendPetty(
        ref.read(databaseProvider),
        amount: amount,
        note: noteCtrl.text,
        accountCode: accountCode,
        employeeId: employeeId,
        shiftId: widget.shift.id,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Belanja petty ${fmt(amount)} dicatat.')),
        );
      }
      setState(() {});
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        );
      }
    }
  }

  Future<void> _closeShift(BuildContext context, WidgetRef ref) async {
    final db = ref.read(databaseProvider);
    final expected = await ShiftService.expectedCash(db, widget.shift.id);
    if (!context.mounted) return;
    final actualCtrl = TextEditingController(text: expected.toString());
    final result = await showDialog<ShiftCloseResult>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          final actual = int.tryParse(
                actualCtrl.text.replaceAll(RegExp(r'[^0-9]'), ''),
              ) ??
              0;
          final diff = actual - expected;
          return AlertDialog(
            title: const Text('Tutup Shift — Rekonsiliasi'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Kas harapan'),
                    MoneyText(expected),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: actualCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Kas fisik di laci (Rp)',
                    border: OutlineInputBorder(),
                    prefixText: 'Rp ',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Selisih'),
                    MoneyText(
                      diff,
                      negativeRed: true,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  diff == 0
                      ? 'Pas — tidak ada jurnal selisih.'
                      : diff < 0
                          ? 'Kurang ${fmt(-diff)} — dijurnal D 5220 / K 1000.'
                          : 'Lebih ${fmt(diff)} — dijurnal D 1000 / K 5220.',
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
                    final r = await ShiftService.closeShift(
                      db,
                      shiftId: widget.shift.id,
                      actualCash: actual,
                    );
                    if (ctx.mounted) Navigator.of(ctx).pop(r);
                  } catch (e) {
                    if (ctx.mounted) {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        SnackBar(content: Text('$e')),
                      );
                    }
                  }
                },
                child: const Text('Tutup Shift'),
              ),
            ],
          );
        },
      ),
    );
    if (result != null) {
      widget.onClosed();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Shift ditutup. Harapan ${fmt(result.expectedCash)}, '
              'fisik ${fmt(result.actualCash)}, '
              'selisih ${fmt(result.cashDiff)}.',
            ),
          ),
        );
      }
    }
  }
}

/// Karyawan untuk baris pettyCash (kolom employeeId tidak boleh null):
/// sesi login dulu, fallback karyawan aktif pertama. Throw bila belum
/// ada karyawan sama sekali.
Future<String> _pettyEmployeeId(WidgetRef ref) async {
  final sessionId = ref.read(sessionProvider).employee?.id;
  if (sessionId != null) return sessionId;
  final employees = await ref.read(employeesProvider.future);
  if (employees.isEmpty) {
    throw StateError(
      'Belum ada karyawan. Isi Data Demo Warkop dulu di Pengaturan.',
    );
  }
  return employees.first.id;
}

/// Daftar shift yang sudah ditutup (ringkas).
class _PastShiftsList extends ConsumerWidget {
  const _PastShiftsList({required this.db});
  final AppDatabase db;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<Shift>>(
      future: (db.select(db.shifts)
            ..where((s) => s.status.equals('closed'))
            ..orderBy([(s) => OrderingTerm.desc(s.closedAt)])
            ..limit(10))
          .get(),
      builder: (ctx, snap) {
        final rows = snap.data ?? const <Shift>[];
        if (rows.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shift sebelumnya',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            ...rows.map((s) {
              final closedStr = s.closedAt == null
                  ? '-'
                  : () {
                      final c = DateTime.fromMillisecondsSinceEpoch(
                        s.closedAt!,
                      );
                      return '${c.day}/${c.month}/${c.year} '
                          '${c.hour.toString().padLeft(2, '0')}:'
                          '${c.minute.toString().padLeft(2, '0')}';
                    }();
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text('Tutup $closedStr'),
                subtitle: Text(
                  'Float ${fmt(s.openingFloat)} • Harapan '
                  '${fmt(s.expectedCash)} • Fisik ${fmt(s.actualCash)}',
                ),
                trailing: MoneyText(
                  s.cashDiff,
                  negativeRed: true,
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
