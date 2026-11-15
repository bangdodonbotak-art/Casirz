// Casirz ERP — Fase 2.
// Formatter teks struk thermal 58/80mm — FUNGSI MURNI (tanpa plugin).
//
// Satu sumber kebenaran isi struk: preview di layar, teks yang dikirim
// ke printer ESC/POS, DAN teks yang di-share ke WA semuanya berasal
// dari fungsi ini. Jadi yang terlihat di preview = yang tercetak =
// yang di-share. Diuji unit test (lebar baris tidak boleh melebihi
// lebar kertas).
import '../money.dart';
import 'receipt_model.dart';

String _pad2(int n) => n.toString().padLeft(2, '0');

String _dateLine(DateTime d) =>
    '${_pad2(d.day)}/${_pad2(d.month)}/${d.year} '
    '${_pad2(d.hour)}:${_pad2(d.minute)}';

String _line(String left, String right, int width) {
  if (left.length + right.length + 1 > width) {
    final maxLeft = width - right.length - 1;
    final trimmed = maxLeft > 0 ? left.substring(0, maxLeft) : '';
    return '$trimmed $right';
  }
  return left + ' ' * (width - left.length - right.length) + right;
}

String _center(String text, int width) {
  if (text.length >= width) return text.substring(0, width);
  final pad = (width - text.length) ~/ 2;
  return ' ' * pad + text;
}

/// Format satu baris item: nama (dipotong bila perlu), lalu baris
/// "  qty x harga" rata kanan dengan subtotal.
List<String> _itemLines(ReceiptLine line, int width) {
  final out = <String>[];
  final name = line.name.length > width
      ? line.name.substring(0, width)
      : line.name;
  out.add(name);
  final qtyPart = '${line.qty} x ${fmt(line.price)}';
  out.add(_line('  $qtyPart', fmt(line.subtotal), width));
  if (line.note != null && line.note!.isNotEmpty) {
    final note = '  * ${line.note!}';
    out.add(note.length > width ? note.substring(0, width) : note);
  }
  return out;
}

/// Seluruh isi struk sebagai teks mono. [width] = lebar karakter
/// kertas (32 untuk 58mm, 42 untuk 80mm).
String formatReceiptText(ReceiptModel receipt) {
  final width = receipt.paperWidth.charsPerLine;
  final sep = '-' * width;
  final buf = StringBuffer();
  buf.writeln(_center(receipt.storeName, width));
  buf.writeln(_center(receipt.saleCode, width));
  buf.writeln(_center(_dateLine(receipt.date), width));
  if (receipt.channelLabel != null) {
    buf.writeln(_center(receipt.channelLabel!, width));
  }
  if (receipt.cashierName != null) {
    buf.writeln(_center('Kasir: ${receipt.cashierName}', width));
  }
  buf.writeln(sep);
  for (final line in receipt.lines) {
    for (final l in _itemLines(line, width)) {
      buf.writeln(l);
    }
  }
  buf.writeln(sep);
  buf.writeln(_line('Subtotal', fmt(receipt.subtotal), width));
  if (receipt.discount > 0) {
    buf.writeln(_line('Diskon', '-${fmt(receipt.discount)}', width));
  }
  if (receipt.serviceCharge > 0) {
    buf.writeln(
      _line('Service / PB1', fmt(receipt.serviceCharge), width),
    );
  }
  if (receipt.tax > 0) {
    buf.writeln(_line('PPN 11%', fmt(receipt.tax), width));
  }
  if (receipt.ojolFee > 0) {
    buf.writeln(_line('Komisi ojol', '-${fmt(receipt.ojolFee)}', width));
  }
  buf.writeln(_line('TOTAL', fmt(receipt.total), width));
  buf.writeln(sep);
  for (final p in receipt.payments) {
    buf.writeln(_line(p.methodLabel, fmt(p.amount), width));
  }
  if (receipt.change > 0) {
    buf.writeln(_line('Kembalian', fmt(receipt.change), width));
  }
  if (receipt.customerName != null) {
    buf.writeln(sep);
    buf.writeln('Pelanggan: ${receipt.customerName}');
    buf.writeln('Poin didapat: ${receipt.pointsEarned}');
    if (receipt.customerPointsTotal != null) {
      buf.writeln('Total poin: ${receipt.customerPointsTotal}');
    }
  }
  buf.writeln(sep);
  buf.writeln(_center('Terima kasih!', width));
  buf.writeln(_center('Barang yang sudah dibeli', width));
  buf.writeln(_center('tidak dapat ditukar/dikembalikan', width));
  return buf.toString();
}

/// Teks tiket dapur (sederhana: label + daftar item + jam).
String formatKitchenTicketText(KitchenTicket ticket, PaperWidth width) {
  final w = width.charsPerLine;
  final sep = '-' * w;
  final buf = StringBuffer();
  buf.writeln(_center('DAPUR — ${ticket.orderLabel}', w));
  if (ticket.tableName != null) buf.writeln(_center(ticket.tableName!, w));
  if (ticket.channelLabel != null) {
    buf.writeln(_center(ticket.channelLabel!, w));
  }
  buf.writeln(_center(_dateLine(ticket.date), w));
  buf.writeln(sep);
  for (final line in ticket.lines) {
    buf.writeln('${line.qty}x ${line.name}');
    if (line.note != null && line.note!.isNotEmpty) {
      buf.writeln('   * ${line.note}');
    }
  }
  buf.writeln(sep);
  return buf.toString();
}
