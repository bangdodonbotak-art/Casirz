// Casirz ERP — Fase 4 (Modul C Akuntansi).
// Export laporan: CSV (paket csv) + PDF print (paket printing/pdf).
// Fungsi di sini MURNI (String/Uint8List dari objek Reports.*) supaya
// bisa dites tanpa UI: angka CSV/PDF selalu sama dengan angka layar,
// karena sama-sama dari jurnal (bukan angka ketik).
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/money.dart';
import '../../core/reports.dart';

/// Satu baris laporan untuk PDF: label + jumlah Rp.
class ReportPdfRow {
  const ReportPdfRow(this.label, this.amount, {this.bold = false});
  final String label;
  final int amount;
  final bool bold;
}

String profitLossCsv(ProfitLoss pl, String periodLabel) {
  const converter = ListToCsvConverter();
  return converter.convert([
    ['Laporan Laba Rugi', periodLabel],
    ['Baris', 'Jumlah (Rp)'],
    ['Pendapatan Kotor', pl.grossRevenue],
    ['Diskon Penjualan', -pl.discount],
    ['Komisi Ojol', -pl.ojolFee],
    ['Pendapatan Bersih', pl.netRevenue],
    ['HPP', -pl.hpp],
    ['Laba Kotor', pl.grossProfit],
    ['Beban Operasional (OPEX)', -pl.opex],
    ['Beban Penyusutan', -pl.depreciation],
    ['Beban Sewa Diamortisasi', -pl.rentAmortization],
    ['Selisih Stok', -pl.stockDiff],
    ['Beban Wastage', -pl.wastage],
    ['Selisih Kas', -pl.cashDiff],
    ['Laba Bersih', pl.netProfit],
    ['Margin Kotor (%)', pl.grossMarginPct.toStringAsFixed(1)],
    ['Margin Bersih (%)', pl.netMarginPct.toStringAsFixed(1)],
  ]);
}

String balanceSheetCsv(BalanceSheet bs, String asOfLabel) {
  const converter = ListToCsvConverter();
  return converter.convert([
    ['Neraca', asOfLabel],
    ['Baris', 'Jumlah (Rp)'],
    ['Kas Tunai / Laci (1000)', bs.cash],
    ['Bank (1010)', bs.bank],
    ['QRIS / E-Wallet (1020)', bs.qris],
    ['Kas Petty (1030)', bs.petty],
    ['Persediaan Bahan Baku (1100)', bs.inventoryMaterials],
    ['Persediaan Barang Dagangan (1110)', bs.inventoryGoods],
    ['Persediaan (1100 + 1110)', bs.inventory],
    ['Sewa Dibayar di Muka (1200)', bs.prepaidRent],
    ['Aset Tetap (1300)', bs.fixedAssets],
    ['Akum. Penyusutan (1310)', -bs.accumulatedDepreciation],
    ['Nilai Buku Aset (1300 - 1310)',
      bs.fixedAssets - bs.accumulatedDepreciation],
    ['Total Aktiva', bs.totalAssets],
    ['Utang Usaha (2000)', bs.payables],
    ['Utang Pajak (2100)', bs.taxPayable],
    ['Total Kewajiban', bs.totalLiabilities],
    ['Modal Disetor (3000)', bs.capital],
    ['Laba Ditahan (3100)', bs.retainedEarnings],
    ['Laba Tahun Berjalan', bs.currentProfit],
    ['Total Ekuitas', bs.totalEquity],
    ['Selisih Balance (harus 0)', bs.difference],
  ]);
}

String cashFlowCsv(CashFlow cf, String periodLabel) {
  const converter = ListToCsvConverter();
  return converter.convert([
    ['Laporan Arus Kas', periodLabel],
    ['Baris', 'Jumlah (Rp)'],
    ['Arus Kas Operasi', cf.operating],
    ['Arus Kas Investasi', cf.investing],
    ['Arus Kas Pendanaan', cf.financing],
    ['Perubahan Bersih Kas', cf.netChange],
    ['Saldo Awal Kas', cf.openingBalance],
    ['Saldo Akhir Kas', cf.closingBalance],
  ]);
}

/// PDF satu laporan: judul + periode + tabel baris + catatan kaki.
/// Mengembalikan bytes PDF (untuk Printing.layoutPdf).
Future<Uint8List> reportPdfBytes({
  required String title,
  required String subtitle,
  required List<ReportPdfRow> rows,
  String? footerNote,
}) async {
  final doc = pw.Document();
  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(subtitle, style: const pw.TextStyle(fontSize: 12)),
          pw.SizedBox(height: 16),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey400),
            columnWidths: {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(2),
            },
            children: [
              pw.TableRow(
                decoration:
                    const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  _cell('Baris', bold: true),
                  _cell('Jumlah', bold: true, right: true),
                ],
              ),
              for (final row in rows)
                pw.TableRow(
                  children: [
                    _cell(row.label, bold: row.bold),
                    _cell(
                      fmt(row.amount),
                      bold: row.bold,
                      right: true,
                    ),
                  ],
                ),
            ],
          ),
          pw.SizedBox(height: 16),
          pw.Text(
            footerNote ??
                'Dihitung dari jurnal akuntansi - bukan angka ketik.',
            style: pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey600,
            ),
          ),
        ],
      ),
    ),
  );
  return doc.save();
}

pw.Widget _cell(String text, {bool bold = false, bool right = false}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    child: pw.Text(
      text,
      textAlign: right ? pw.TextAlign.right : pw.TextAlign.left,
      style: pw.TextStyle(
        fontSize: 11,
        fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
      ),
    ),
  );
}
