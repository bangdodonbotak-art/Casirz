// Casirz ERP — Fase 4 (Modul C Akuntansi).
// Laporan Keuangan: Laba Rugi, Neraca, Arus Kas — SEMUA angka dari
// Reports.* (jurnal), bukan angka ketik. Filter Hari Ini / Bulan Ini /
// Tahun Ini / Custom. Export CSV per laporan + Print PDF.
// Neraca menampilkan SELISIH BALANCE — harus 0 (merah bila tidak 0).
import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import '../../core/money.dart';
import '../../core/reports.dart';
import '../../shared/widgets/money_text.dart';
import '../pos/pos_providers.dart';
import 'accounting_providers.dart';
import 'report_export.dart';

enum _Period { today, month, year, custom }

class _ReportsData {
  const _ReportsData(this.pl, this.bs, this.cf);
  final ProfitLoss pl;
  final BalanceSheet bs;
  final CashFlow cf;
}

String _fmtDateShort(DateTime d) =>
    DateFormat('d MMM yyyy', 'id_ID').format(d);

class ReportsPage extends ConsumerStatefulWidget {
  const ReportsPage({super.key});

  @override
  ConsumerState<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends ConsumerState<ReportsPage> {
  var _period = _Period.month;
  late DateTime _from;
  late DateTime _to;
  Future<_ReportsData>? _future;

  @override
  void initState() {
    super.initState();
    _applyPeriod(_Period.month);
  }

  void _applyPeriod(_Period period) {
    final now = DateTime.now();
    switch (period) {
      case _Period.today:
        _from = DateTime(now.year, now.month, now.day);
        _to = now;
      case _Period.month:
        _from = DateTime(now.year, now.month, 1);
        _to = now;
      case _Period.year:
        _from = DateTime(now.year, 1, 1);
        _to = now;
      case _Period.custom:
        break; // _from/_to sudah dipilih pengguna
    }
    _period = period;
    _refresh();
  }

  void _refresh() {
    final db = ref.read(databaseProvider);
    final from = _from;
    final to = _to;
    setState(() {
      _future = Future.wait([
        Reports.profitLoss(db, from, to),
        Reports.balanceSheet(db, to),
        Reports.cashFlow(db, from, to),
      ]).then((v) => _ReportsData(v[0] as ProfitLoss, v[1] as BalanceSheet, v[2] as CashFlow));
    });
  }

  String get _periodLabel {
    switch (_period) {
      case _Period.today:
        return _fmtDateShort(_to);
      case _Period.month:
        return DateFormat('MMMM yyyy', 'id_ID').format(_to);
      case _Period.year:
        return '${_to.year}';
      case _Period.custom:
        return '${_fmtDateShort(_from)} – ${_fmtDateShort(_to)}';
    }
  }

  String get _fileSuffix {
    final d = _to;
    return '${d.year}${d.month.toString().padLeft(2, '0')}${d.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(accountingVersionProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Laporan Keuangan')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Wrap(
            spacing: 8,
            children: [
              for (final p in _Period.values)
                ChoiceChip(
                  label: Text(
                    switch (p) {
                      _Period.today => 'Hari Ini',
                      _Period.month => 'Bulan Ini',
                      _Period.year => 'Tahun Ini',
                      _Period.custom => 'Custom',
                    },
                  ),
                  selected: _period == p,
                  onSelected: (_) async {
                    if (p == _Period.custom) {
                      await _pickCustomRange();
                    } else {
                      setState(() => _applyPeriod(p));
                    }
                  },
                ),
            ],
          ),
          if (_period == _Period.custom) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text('Dari: ${_fmtDateShort(_from)}'),
                ),
                TextButton(
                  onPressed: () => _pickCustomDate(true),
                  child: const Text('Pilih'),
                ),
                Expanded(
                  child: Text('Sampai: ${_fmtDateShort(_to)}'),
                ),
                TextButton(
                  onPressed: () => _pickCustomDate(false),
                  child: const Text('Pilih'),
                ),
              ],
            ),
          ],
          const SizedBox(height: 4),
          Text(
            'Periode: $_periodLabel',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Text(
            'Semua angka dihitung dari jurnal akuntansi.',
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 12),
          FutureBuilder<_ReportsData>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Text('Gagal memuat laporan: ${snapshot.error}');
              }
              final data = snapshot.data;
              if (data == null) {
                return const Text('Tidak ada data laporan.');
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SectionCard(
                    title: 'Laba Rugi',
                    rows: _plRows(data.pl),
                    marginNote:
                        'Margin kotor ${data.pl.grossMarginPct.toStringAsFixed(1)}% · '
                        'Margin bersih ${data.pl.netMarginPct.toStringAsFixed(1)}%',
                    onExportCsv: () => _exportCsv(
                      'laba-rugi-$_fileSuffix.csv',
                      profitLossCsv(data.pl, _periodLabel),
                    ),
                    onPrint: () => _printReport(
                      'Laporan Laba Rugi',
                      _plRows(data.pl),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SectionCard(
                    title: 'Neraca',
                    rows: _bsRows(data.bs),
                    highlightDifference: data.bs.difference,
                    onExportCsv: () => _exportCsv(
                      'neraca-$_fileSuffix.csv',
                      balanceSheetCsv(data.bs, _periodLabel),
                    ),
                    onPrint: () => _printReport(
                      'Neraca',
                      _bsRows(data.bs),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SectionCard(
                    title: 'Arus Kas',
                    rows: _cfRows(data.cf),
                    onExportCsv: () => _exportCsv(
                      'arus-kas-$_fileSuffix.csv',
                      cashFlowCsv(data.cf, _periodLabel),
                    ),
                    onPrint: () => _printReport(
                      'Laporan Arus Kas',
                      _cfRows(data.cf),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  List<ReportPdfRow> _plRows(ProfitLoss pl) => [
        ReportPdfRow('Pendapatan Kotor', pl.grossRevenue),
        ReportPdfRow('Diskon Penjualan', -pl.discount),
        ReportPdfRow('Komisi Ojol', -pl.ojolFee),
        ReportPdfRow('Pendapatan Bersih', pl.netRevenue, bold: true),
        ReportPdfRow('HPP', -pl.hpp),
        ReportPdfRow('Laba Kotor', pl.grossProfit, bold: true),
        ReportPdfRow('Beban Operasional (OPEX)', -pl.opex),
        ReportPdfRow('Beban Penyusutan', -pl.depreciation),
        ReportPdfRow('Beban Sewa Diamortisasi', -pl.rentAmortization),
        ReportPdfRow('Selisih Stok', -pl.stockDiff),
        ReportPdfRow('Beban Wastage', -pl.wastage),
        ReportPdfRow('Selisih Kas', -pl.cashDiff),
        ReportPdfRow('Laba Bersih', pl.netProfit, bold: true),
      ];

  List<ReportPdfRow> _bsRows(BalanceSheet bs) => [
        ReportPdfRow('Kas Tunai / Laci (1000)', bs.cash),
        ReportPdfRow('Bank (1010)', bs.bank),
        ReportPdfRow('QRIS / E-Wallet (1020)', bs.qris),
        ReportPdfRow('Kas Petty (1030)', bs.petty),
        ReportPdfRow('Persediaan Bahan Baku (1100)', bs.inventoryMaterials),
        ReportPdfRow(
          'Persediaan Barang Dagangan (1110)',
          bs.inventoryGoods,
        ),
        ReportPdfRow('Persediaan (1100 + 1110)', bs.inventory),
        ReportPdfRow('Sewa Dibayar di Muka (1200)', bs.prepaidRent),
        ReportPdfRow('Aset Tetap (1300)', bs.fixedAssets),
        ReportPdfRow('Akum. Penyusutan (1310)', -bs.accumulatedDepreciation),
        ReportPdfRow(
          'Nilai Buku Aset (1300 - 1310)',
          bs.fixedAssets - bs.accumulatedDepreciation,
        ),
        ReportPdfRow('Total Aktiva', bs.totalAssets, bold: true),
        ReportPdfRow('Utang Usaha (2000)', bs.payables),
        ReportPdfRow('Utang Pajak (2100)', bs.taxPayable),
        ReportPdfRow('Total Kewajiban', bs.totalLiabilities, bold: true),
        ReportPdfRow('Modal Disetor (3000)', bs.capital),
        ReportPdfRow('Laba Ditahan (3100)', bs.retainedEarnings),
        ReportPdfRow('Laba Tahun Berjalan', bs.currentProfit),
        ReportPdfRow('Total Ekuitas', bs.totalEquity, bold: true),
        ReportPdfRow('SELISIH BALANCE (harus 0)', bs.difference, bold: true),
      ];

  List<ReportPdfRow> _cfRows(CashFlow cf) => [
        ReportPdfRow('Arus Kas Operasi', cf.operating),
        ReportPdfRow('Arus Kas Investasi', cf.investing),
        ReportPdfRow('Arus Kas Pendanaan', cf.financing),
        ReportPdfRow('Perubahan Bersih Kas', cf.netChange, bold: true),
        ReportPdfRow('Saldo Awal Kas', cf.openingBalance),
        ReportPdfRow('Saldo Akhir Kas', cf.closingBalance, bold: true),
      ];

  Future<void> _exportCsv(String fileName, String csv) async {
    // bytes diserahkan ke saveFile supaya platform yang menulis file
    // (Android scoped storage tidak selalu bisa ditulis lewat path).
    final path = await FilePicker.saveFile(
      dialogTitle: 'Simpan $fileName',
      fileName: fileName,
      type: FileType.custom,
      allowedExtensions: ['csv'],
      bytes: Uint8List.fromList(utf8.encode(csv)),
    );
    if (path == null) return; // pengguna batal — bukan error
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('CSV tersimpan: $path')),
      );
    }
  }

  Future<void> _printReport(
    String title,
    List<ReportPdfRow> rows,
  ) async {
    try {
      await Printing.layoutPdf(
        onLayout: (_) => reportPdfBytes(
          title: title,
          subtitle: 'Periode: $_periodLabel',
          rows: rows,
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mencetak: $e')),
        );
      }
    }
  }

  Future<void> _pickCustomRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _from, end: _to),
    );
    if (picked == null) return;
    setState(() {
      _period = _Period.custom;
      _from = picked.start;
      _to = picked.end;
      _refresh();
    });
  }

  Future<void> _pickCustomDate(bool isFrom) async {
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
      _refresh();
    });
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.rows,
    this.marginNote,
    this.highlightDifference,
    required this.onExportCsv,
    required this.onPrint,
  });
  final String title;
  final List<ReportPdfRow> rows;
  final String? marginNote;
  final int? highlightDifference;
  final VoidCallback onExportCsv;
  final VoidCallback onPrint;

  @override
  Widget build(BuildContext context) {
    final balanced = highlightDifference == null || highlightDifference == 0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: onExportCsv,
                      icon: const Icon(Icons.download, size: 18),
                      label: const Text('CSV'),
                    ),
                    TextButton.icon(
                      onPressed: onPrint,
                      icon: const Icon(Icons.print, size: 18),
                      label: const Text('Print'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            for (final row in rows)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        row.label,
                        style: TextStyle(
                          fontWeight:
                              row.bold ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    MoneyText(
                      row.amount,
                      style: TextStyle(
                        fontWeight:
                            row.bold ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            if (marginNote != null) ...[
              const SizedBox(height: 8),
              Text(marginNote!, style: const TextStyle(fontSize: 12)),
            ],
            if (highlightDifference != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: balanced
                      ? Colors.green.withValues(alpha: 0.12)
                      : Colors.red.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  balanced
                      ? 'SELISIH BALANCE: Rp0 — Neraca seimbang.'
                      : 'SELISIH BALANCE: ${fmt(highlightDifference!)} — '
                          'Neraca TIDAK seimbang, laporkan ke koordinator.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: balanced ? Colors.green.shade800 : Colors.red,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
