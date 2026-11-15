// Casirz ERP — Fase 2.
// Model struk (BLUEPRINT-FLUTTER.md §5.5 — bentuk data BEKU).
// Satu-satunya bentuk data yang boleh lewat ke PrinterPort.
import 'package:flutter/foundation.dart';

enum PaperWidth { mm58, mm80 }

extension PaperWidthX on PaperWidth {
  /// Lebar karakter teks mono per baris (font A).
  int get charsPerLine => this == PaperWidth.mm58 ? 32 : 42;
  String get label => this == PaperWidth.mm58 ? '58mm' : '80mm';
}

@immutable
class ReceiptLine {
  const ReceiptLine({
    required this.name,
    required this.qty,
    required this.price,
    this.note,
  });
  final String name;
  final int qty;
  final int price; // harga satuan (sudah termasuk modifier), Rp
  final String? note; // catatan / modifier per item

  int get subtotal => qty * price;
}

@immutable
class ReceiptPayment {
  const ReceiptPayment({required this.methodLabel, required this.amount});
  final String methodLabel; // label tampil: 'Tunai', 'QRIS', 'Debit', ...
  final int amount; // Rp
}

@immutable
class ReceiptModel {
  const ReceiptModel({
    required this.storeName,
    required this.saleCode,
    required this.date,
    required this.lines,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.serviceCharge,
    required this.ojolFee,
    required this.total,
    required this.payments,
    required this.change,
    required this.paperWidth,
    this.cashierName,
    this.channelLabel,
    this.customerName,
    this.pointsEarned = 0,
    this.customerPointsTotal,
  });
  final String storeName;
  final String saleCode;
  final DateTime date;
  final List<ReceiptLine> lines;
  final int subtotal;
  final int discount;
  final int tax;
  final int serviceCharge;
  final int ojolFee;
  final int total;
  final List<ReceiptPayment> payments;
  final int change;
  final PaperWidth paperWidth;
  final String? cashierName;
  final String? channelLabel;
  final String? customerName;
  final int pointsEarned; // poin didapat dari struk ini
  final int? customerPointsTotal; // total poin pelanggan setelah struk ini
}

/// Tiket dapur (KDS / printer dapur): pesanan yang baru masuk.
@immutable
class KitchenTicket {
  const KitchenTicket({
    required this.orderLabel,
    required this.date,
    required this.lines,
    this.tableName,
    this.channelLabel,
  });
  final String orderLabel; // kode order / nomor meja
  final DateTime date;
  final List<ReceiptLine> lines;
  final String? tableName;
  final String? channelLabel;
}
