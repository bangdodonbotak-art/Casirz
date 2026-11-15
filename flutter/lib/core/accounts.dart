// Casirz ERP — Fase 1 Core Engine.
// Bagan akun standar warkop, PERSIS laporan analisa §3.3 /
// BLUEPRINT-FLUTTER.md §7.1, DITAMBAH akun 1110 (Adendum pasca-Fase 1
// butir 2, Fase 4): 30 akun, kode 1000-5220.
// Di-seed ke tabel accounts saat onCreate database (bukan lewat seed demo).
// BEKU: jangan tambah/kurangi/ubah akun tanpa persetujuan koordinator.

/// Jenis akun.
enum AccountType { aset, kewajiban, ekuitas, pendapatan, beban }

/// Posisi normal akun: debit atau kredit.
enum Normal { debit, kredit }

/// Satu baris bagan akun.
class AccountDef {
  const AccountDef(this.code, this.name, this.type, this.normal);
  final String code;
  final String name;
  final AccountType type;
  final Normal normal;
}

/// Bagan akun standar warkop (30 akun — 29 laporan + 1110 Fase 4).
class ChartOfAccounts {
  static const List<AccountDef> all = [
    AccountDef('1000', 'Kas Tunai / Laci', AccountType.aset, Normal.debit),
    AccountDef('1010', 'Bank', AccountType.aset, Normal.debit),
    AccountDef('1020', 'QRIS / E-Wallet', AccountType.aset, Normal.debit),
    AccountDef('1030', 'Kas Petty', AccountType.aset, Normal.debit),
    AccountDef('1100', 'Persediaan Bahan Baku', AccountType.aset, Normal.debit),
    // Fase 4 (Adendum pasca-Fase 1 butir 2): persediaan barang dagangan
    // (produk TANPA BOM, mis. Air Mineral). HPP produk tanpa BOM dijurnal
    // D 5000 / K 1110 — supaya saldo 1100 = Σ totalValue bahan persis.
    AccountDef(
      '1110',
      'Persediaan Barang Dagangan',
      AccountType.aset,
      Normal.debit,
    ),
    AccountDef('1200', 'Sewa Dibayar di Muka', AccountType.aset, Normal.debit),
    AccountDef('1300', 'Aset Tetap', AccountType.aset, Normal.debit),
    AccountDef('1310', 'Akum. Penyusutan', AccountType.aset, Normal.kredit),
    AccountDef('2000', 'Utang Usaha', AccountType.kewajiban, Normal.kredit),
    AccountDef('2100', 'Utang Pajak', AccountType.kewajiban, Normal.kredit),
    AccountDef('3000', 'Modal Disetor', AccountType.ekuitas, Normal.kredit),
    AccountDef('3100', 'Laba Ditahan', AccountType.ekuitas, Normal.kredit),
    AccountDef('4000', 'Pendapatan Penjualan', AccountType.pendapatan,
        Normal.kredit),
    AccountDef('4100', 'Diskon Penjualan', AccountType.pendapatan,
        Normal.debit),
    AccountDef('4200', 'Komisi Ojol', AccountType.beban, Normal.debit),
    AccountDef('5000', 'HPP', AccountType.beban, Normal.debit),
    AccountDef('5100', 'Beban Listrik', AccountType.beban, Normal.debit),
    AccountDef('5110', 'Beban Air', AccountType.beban, Normal.debit),
    AccountDef('5120', 'Beban Internet', AccountType.beban, Normal.debit),
    AccountDef('5130', 'Beban Gaji', AccountType.beban, Normal.debit),
    AccountDef('5140', 'Beban Sewa', AccountType.beban, Normal.debit),
    AccountDef('5150', 'Beban Kebersihan', AccountType.beban, Normal.debit),
    AccountDef('5160', 'Beban Marketing', AccountType.beban, Normal.debit),
    AccountDef('5170', 'Beban Lain-lain', AccountType.beban, Normal.debit),
    AccountDef('5180', 'Beban Penyusutan', AccountType.beban, Normal.debit),
    AccountDef('5190', 'Beban Sewa Diamortisasi', AccountType.beban,
        Normal.debit),
    AccountDef('5200', 'Selisih Stok', AccountType.beban, Normal.debit),
    AccountDef('5210', 'Beban Wastage', AccountType.beban, Normal.debit),
    AccountDef('5220', 'Selisih Kas', AccountType.beban, Normal.debit),
  ];

  /// Cari akun berdasarkan kode. Throw [ArgumentError] jika kode tidak ada.
  static AccountDef byCode(String code) {
    for (final a in all) {
      if (a.code == code) return a;
    }
    throw ArgumentError('Kode akun tidak dikenal: $code');
  }

  /// True jika kode ada di bagan akun.
  static bool exists(String code) => all.any((a) => a.code == code);
}
