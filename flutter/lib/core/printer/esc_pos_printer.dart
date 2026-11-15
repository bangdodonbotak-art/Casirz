// Casirz ERP — Fase 2.
// Implementasi PrinterPort SATU-SATUNYA yang memakai
// `unified_esc_pos_printer` (BLUEPRINT-FLUTTER.md §5.5).
// UI dilarang import package printer langsung — hanya lewat port ini.
//
// PERINGATAN JUJUR (dicatat di kode + laporan Fase 2):
// printer fisik TIDAK BISA dites di VM — tidak ada printer USB/BT/
// network di lingkungan ini. Semua pemanggilan di sini melaporkan
// status lewat throw / PrinterStatus.error dengan alasan yang jelas,
// supaya di HP Dony terlihat gagalnya di mana, bukan diam-diam.
// Yang 100% benar di VM: isi struk (receipt_text.dart) + preview layar.
import 'dart:async';

import 'package:unified_esc_pos_printer/unified_esc_pos_printer.dart'
    as esc;

import 'printer_port.dart';
import 'receipt_model.dart';
import 'receipt_text.dart';

class EscPosPrinterPort implements PrinterPort {
  EscPosPrinterPort() : _manager = esc.PrinterManager() {
    _manager.stateStream.listen((s) {
      _statusController.add(_mapState(s));
    });
  }

  final esc.PrinterManager _manager;
  final _statusController = StreamController<PrinterStatus>.broadcast();
  DiscoveredPrinter? _connected;

  static PrinterStatus _mapState(esc.PrinterConnectionState s) {
    switch (s) {
      case esc.PrinterConnectionState.connected:
      case esc.PrinterConnectionState.printing:
        return PrinterStatus.connected;
      case esc.PrinterConnectionState.connecting:
      case esc.PrinterConnectionState.scanning:
        return PrinterStatus.connecting;
      case esc.PrinterConnectionState.error:
        return PrinterStatus.error;
      case esc.PrinterConnectionState.disconnected:
      case esc.PrinterConnectionState.disconnecting:
        return PrinterStatus.disconnected;
    }
  }

  @override
  Stream<PrinterStatus> get statusStream => _statusController.stream;

  @override
  Future<List<DiscoveredPrinter>> discover() async {
    try {
      final devices = await _manager.scanPrinters(
        timeout: const Duration(seconds: 8),
      );
      return devices.map((d) {
        final kind = switch (d.connectionType) {
          esc.PrinterConnectionType.usb => PrinterKind.usb,
          esc.PrinterConnectionType.bluetooth => PrinterKind.bluetooth,
          esc.PrinterConnectionType.ble => PrinterKind.ble,
          esc.PrinterConnectionType.network => PrinterKind.network,
        };
        return DiscoveredPrinter(
          id: d.name,
          name: d.name,
          kind: kind,
        );
      }).toList();
    } catch (e) {
      throw StateError('Pencarian printer gagal: $e');
    }
  }

  @override
  Future<void> connect(DiscoveredPrinter printer) async {
    try {
      // Cari ulang device yang cocok namanya (scan mengembalikan
      // objek device yang dibutuhkan connector).
      final devices = await _manager.scanPrinters(
        timeout: const Duration(seconds: 8),
      );
      final match = devices.where((d) => d.name == printer.id).toList();
      if (match.isEmpty) {
        throw StateError(
          'Printer "${printer.name}" tidak ditemukan saat pemindaian ulang. '
          'Pastikan printer menyala dan masih dalam jangkauan.',
        );
      }
      await _manager.connect(match.first);
      _connected = printer;
    } catch (e) {
      _statusController.add(PrinterStatus.error);
      throw StateError('Gagal terhubung ke printer "${printer.name}": $e');
    }
  }

  @override
  Future<void> printReceipt(ReceiptModel receipt) async {
    if (_connected == null) {
      throw StateError(
        'Belum ada printer terhubung. Cari dan hubungkan printer dulu '
        'di Pengaturan > Printer.',
      );
    }
    final paper = receipt.paperWidth == PaperWidth.mm58
        ? esc.PaperSize.mm58
        : esc.PaperSize.mm80;
    final ticket = await esc.Ticket.create(paper);
    // Isi struk = teks yang sama persis dengan preview layar
    // (receipt_text.dart) — satu sumber kebenaran.
    for (final line in formatReceiptText(receipt).split('\n')) {
      ticket.text(line);
    }
    ticket.feed(2);
    ticket.cut();
    try {
      await _manager.printTicket(ticket);
    } catch (e) {
      throw StateError('Gagal mencetak struk: $e');
    }
  }

  @override
  Future<void> printKitchenTicket(KitchenTicket ticket) async {
    if (_connected == null) {
      throw StateError(
        'Belum ada printer terhubung. Cari dan hubungkan printer dulu '
        'di Pengaturan > Printer.',
      );
    }
    final paper = esc.PaperSize.mm80;
    final t = await esc.Ticket.create(paper);
    for (final line in formatKitchenTicketText(ticket, PaperWidth.mm80)
        .split('\n')) {
      t.text(line);
    }
    t.feed(2);
    t.cut();
    try {
      await _manager.printTicket(t);
    } catch (e) {
      throw StateError('Gagal mencetak tiket dapur: $e');
    }
  }

  @override
  Future<void> disconnect() async {
    await _manager.disconnect();
    _connected = null;
  }
}
