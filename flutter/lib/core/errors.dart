// Casirz ERP — Fase 1 Core Engine.
// Exception domain. Pesan berbahasa Indonesia.

/// Jurnal tidak seimbang (total debit != total kredit) atau melanggar
/// aturan satu baris (debit > 0 dan kredit > 0 sekaligus).
class JurnalTidakSeimbang implements Exception {
  JurnalTidakSeimbang(this.message);
  final String message;
  @override
  String toString() => 'JurnalTidakSeimbang: $message';
}

/// Pembayaran struk tidak cocok dengan total yang harus dibayar
/// (uang diterima netto + komisi ojol != total).
class PembayaranTidakCocok implements Exception {
  PembayaranTidakCocok(this.message);
  final String message;
  @override
  String toString() => 'PembayaranTidakCocok: $message';
}

/// File export web v2 tidak valid (format salah, struktur rusak,
/// tipe salah, referensi tidak ditemukan).
class MigrasiTidakValid implements Exception {
  MigrasiTidakValid(this.message);
  final String message;
  @override
  String toString() => 'MigrasiTidakValid: $message';
}

/// Penjualan sudah dibatalkan sebelumnya — void kedua ditolak.
class PenjualanSudahDibatalkan implements Exception {
  PenjualanSudahDibatalkan(this.saleId);
  final String saleId;
  @override
  String toString() =>
      'PenjualanSudahDibatalkan: penjualan $saleId sudah dibatalkan.';
}
