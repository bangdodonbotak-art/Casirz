// Casirz ERP — Fase 2.
// Abstraksi printer (BLUEPRINT-FLUTTER.md §5.5 — BEKU).
// UI, service kasir, dan fitur lain DILARANG import
// `unified_esc_pos_printer` langsung — hanya boleh bicara ke PrinterPort
// (di-inject via Riverpod). Satu-satunya implementasi ada di
// esc_pos_printer.dart.
//
// PERINGATAN JUJUR: printer thermal TIDAK BISA dites penuh di VM —
// klaim "jalan" baru sah setelah struk beneran keluar dari printer
// fisik di HP Dony (Fase 8). Karena itu setiap pemanggilan cetak harus
// melaporkan status (berhasil/gagal + alasan), dan preview struk di
// layar harus 100% benar (lihat receipt_text.dart).
import 'dart:async';

import 'receipt_model.dart';

enum PrinterKind { usb, bluetooth, ble, network }

class DiscoveredPrinter {
  const DiscoveredPrinter({
    required this.id,
    required this.name,
    required this.kind,
  });
  final String id;
  final String name;
  final PrinterKind kind;
}

enum PrinterStatus { disconnected, connecting, connected, error }

abstract class PrinterPort {
  Future<List<DiscoveredPrinter>> discover();
  Future<void> connect(DiscoveredPrinter printer);
  Future<void> printReceipt(ReceiptModel receipt);
  Future<void> printKitchenTicket(KitchenTicket ticket);
  Future<void> disconnect();
  Stream<PrinterStatus> get statusStream;
}
