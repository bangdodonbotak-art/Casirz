// Casirz ERP — Fase 3 (Modul B Bahan/BOM).
// Tab Opname: daftar sesi opname (draft/posted), buat sesi baru
// (input hitung fisik per bahan, selisih otomatis fisik - sistem),
// posting sesi (jurnal selisih susut D 5200 / K 1100, surplus
// D 1100 / K 5200 — engine AccountingService.postOpname).
// Sesi yang sudah diposting TIDAK bisa diubah / diposting ulang.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/accounting_service.dart';
import '../../core/db.dart';
import '../../core/money.dart';
import '../../shared/widgets/common.dart';
import '../pos/pos_providers.dart';
import '../staff/staff_providers.dart';
import 'inventory_page.dart';
import 'inventory_providers.dart';
import 'inventory_service.dart';

String _fmtDate(int epochMs) {
  final d = DateTime.fromMillisecondsSinceEpoch(epochMs);
  return '${d.day}/${d.month}/${d.year} '
      '${d.hour.toString().padLeft(2, '0')}:'
      '${d.minute.toString().padLeft(2, '0')}';
}

class OpnameTab extends ConsumerWidget {
  const OpnameTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opnamesAsync = ref.watch(opnamesProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Stok opname menghitung fisik vs sistem. '
                  'Selisih minus tampil apa adanya.',
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: () => _showCreateSheet(context, ref),
                icon: const Icon(Icons.add),
                label: const Text('Buat Opname'),
              ),
            ],
          ),
        ),
        Expanded(
          child: opnamesAsync.when(
            data: (opnames) {
              if (opnames.isEmpty) {
                return const EmptyState(
                  message: 'Belum ada sesi opname.',
                );
              }
              return ListView.builder(
                itemCount: opnames.length,
                itemBuilder: (ctx, i) {
                  final o = opnames[i];
                  final posted = o.status == 'posted';
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    child: ListTile(
                      title: Text('Opname ${_fmtDate(o.date)}'),
                      subtitle: o.note == null || o.note!.isEmpty
                          ? null
                          : Text(o.note!),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: posted
                              ? Colors.green.shade600
                              : Colors.orange.shade600,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          posted ? 'Posted' : 'Draft',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                OpnameDetailPage(opname: o),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => EmptyState(message: 'Gagal memuat: $e'),
          ),
        ),
      ],
    );
  }

  Future<void> _showCreateSheet(BuildContext context, WidgetRef ref) async {
    final ingredients = await ref.read(ingredientsProvider.future);
    if (!context.mounted) return;
    if (ingredients.isEmpty) {
      showErrorSnack(context, 'Belum ada bahan untuk diopname.');
      return;
    }
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => _CreateOpnameSheet(ingredients: ingredients),
    );
  }
}

class _CreateOpnameSheet extends ConsumerStatefulWidget {
  const _CreateOpnameSheet({required this.ingredients});
  final List<Ingredient> ingredients;

  @override
  ConsumerState<_CreateOpnameSheet> createState() =>
      _CreateOpnameSheetState();
}

class _CreateOpnameSheetState extends ConsumerState<_CreateOpnameSheet> {
  late final Map<String, TextEditingController> _ctrls;
  final _noteCtrl = TextEditingController();
  var _busy = false;

  @override
  void initState() {
    super.initState();
    _ctrls = {
      for (final ing in widget.ingredients)
        ing.id: TextEditingController(text: fmtQty(ing.stockQty)),
    };
  }

  @override
  void dispose() {
    for (final c in _ctrls.values) {
      c.dispose();
    }
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            Text(
              'Opname Baru — Hitung Fisik',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Isi stok fisik hasil hitungan. Selisih = fisik − sistem.',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteCtrl,
              decoration: const InputDecoration(
                labelText: 'Catatan (opsional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            for (final ing in widget.ingredients)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${ing.name} (sistem: '
                        '${fmtQty(ing.stockQty)} ${ing.unit})',
                      ),
                    ),
                    SizedBox(
                      width: 110,
                      child: TextField(
                        controller: _ctrls[ing.id],
                        keyboardType:
                            const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: ing.unit,
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _busy ? null : _save,
              child: const Text('Simpan sebagai Draft'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final actualByIngredient = <String, double>{};
    for (final ing in widget.ingredients) {
      final v = parseQty(_ctrls[ing.id]!.text);
      if (v == null || v < 0) {
        showErrorSnack(
          context,
          'Hitung fisik "${ing.name}" tidak valid.',
        );
        return;
      }
      actualByIngredient[ing.id] = v;
    }
    setState(() => _busy = true);
    try {
      final db = ref.read(databaseProvider);
      final employeeId = await _resolveEmployeeId(ref);
      await AccountingService.createOpnameDraft(
        db,
        employeeId: employeeId,
        actualByIngredient: actualByIngredient,
        note: _noteCtrl.text.trim().isEmpty
            ? null
            : _noteCtrl.text.trim(),
      );
      if (mounted) {
        Navigator.of(context).pop();
        showOkSnack(context, 'Draft opname dibuat.');
      }
    } catch (e) {
      if (mounted) showErrorSnack(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

/// Karyawan pelaksana opname: sesi login dulu (Fase 6), fallback
/// karyawan aktif pertama. Throw bila belum ada karyawan sama sekali.
Future<String> _resolveEmployeeId(WidgetRef ref) async {
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

/// Detail sesi opname: tabel sistem / fisik / selisih + posting.
class OpnameDetailPage extends ConsumerStatefulWidget {
  const OpnameDetailPage({super.key, required this.opname});
  final StockOpname opname;

  @override
  ConsumerState<OpnameDetailPage> createState() => _OpnameDetailPageState();
}

class _OpnameDetailPageState extends ConsumerState<OpnameDetailPage> {
  var _busy = false;

  @override
  Widget build(BuildContext context) {
    final linesAsync = ref.watch(opnameLinesProvider(widget.opname.id));
    final posted = widget.opname.status == 'posted';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Opname ${_fmtDate(widget.opname.date)}',
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    posted
                        ? 'Sudah diposting — tidak bisa diubah.'
                        : 'Status: Draft — ubah hitung fisik lalu posting.',
                  ),
                ),
                if (!posted)
                  FilledButton.icon(
                    onPressed: _busy ? null : _post,
                    icon: const Icon(Icons.check),
                    label: const Text('Posting'),
                  ),
              ],
            ),
          ),
          Expanded(
            child: linesAsync.when(
              data: (lines) {
                if (lines.isEmpty) {
                  return const EmptyState(
                    message: 'Sesi ini tidak punya baris.',
                  );
                }
                return ListView.builder(
                  itemCount: lines.length,
                  itemBuilder: (ctx, i) =>
                      _OpnameLineTile(line: lines[i], editable: !posted),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => EmptyState(message: 'Gagal memuat: $e'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _post() async {
    final ok = await showConfirmDialog(
      context,
      title: 'Posting opname?',
      message: 'Stok akan disesuaikan ke hitung fisik dan jurnal '
          'selisih diposting. Sesi ini tidak bisa diubah lagi.',
      actionLabel: 'Ya, posting',
    );
    if (!ok || !mounted) return;
    setState(() => _busy = true);
    try {
      final db = ref.read(databaseProvider);
      await AccountingService.postOpname(db, widget.opname.id);
      if (mounted) {
        Navigator.of(context).pop();
        showOkSnack(context, 'Opname diposting.');
      }
    } catch (e) {
      if (mounted) showErrorSnack(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

class _OpnameLineTile extends ConsumerStatefulWidget {
  const _OpnameLineTile({required this.line, required this.editable});
  final StockOpnameLine line;
  final bool editable;

  @override
  ConsumerState<_OpnameLineTile> createState() => _OpnameLineTileState();
}

class _OpnameLineTileState extends ConsumerState<_OpnameLineTile> {
  late final _ctrl = TextEditingController(
    text: fmtQty(widget.line.actualQty),
  );

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nameAsync =
        ref.watch(ingredientNameProvider(widget.line.ingredientId));
    final diff = widget.line.diffQty;
    final diffColor = diff < 0
        ? Colors.red
        : (diff > 0 ? Colors.green.shade700 : null);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            nameAsync.when(
              data: (name) => Text(
                name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              loading: () => const Text('...'),
              error: (_, _) => const Text('-'),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Sistem'),
                Text(fmtQty(widget.line.systemQty)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Fisik'),
                widget.editable
                    ? SizedBox(
                        width: 110,
                        child: TextField(
                          controller: _ctrl,
                          keyboardType:
                              const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          onSubmitted: (_) => _saveActual(),
                        ),
                      )
                    : Text(fmtQty(widget.line.actualQty)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Selisih (fisik − sistem)'),
                Text(
                  '${diff > 0 ? '+' : ''}${fmtQty(diff)}',
                  style: TextStyle(
                    color: diffColor,
                    fontWeight:
                        diff != 0 ? FontWeight.bold : FontWeight.normal,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
            if (widget.editable)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _saveActual,
                  child: const Text('Simpan hitung'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveActual() async {
    final v = parseQty(_ctrl.text);
    if (v == null || v < 0) {
      showErrorSnack(context, 'Hitung fisik tidak valid.');
      return;
    }
    try {
      final db = ref.read(databaseProvider);
      await InventoryService.updateOpnameLine(
        db,
        lineId: widget.line.id,
        actualQty: v,
      );
      ref.invalidate(opnameLinesProvider(widget.line.opnameId));
    } catch (e) {
      if (mounted) showErrorSnack(context, e);
    }
  }
}
