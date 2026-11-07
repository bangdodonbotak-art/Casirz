# Casirz

**Casirz** adalah aplikasi kasir (POS — Point of Sale) gratis untuk usaha kecil Indonesia (UMKM). Semua fitur terbuka, tanpa paywall, tanpa langganan, tanpa batas produk atau transaksi.

> **English summary:** Casirz is a free, open-source point-of-sale app for small Indonesian businesses. All features are free — no paywall, no subscription. Just open `index.html` in a browser; data is saved in your browser's localStorage. Single self-contained HTML file, vanilla JavaScript, no build step, no dependencies.

## Fitur (9 Modul)

| Modul | Isi |
| --- | --- |
| **Kasir** | Grid produk, keranjang (+/- jumlah), promo & diskon, pajak 11% (opsional), bayar Tunai / QRIS / Kartu / E-Wallet, hitung kembalian, struk |
| **Dashboard** | Penjualan hari ini, jumlah transaksi, laba hari ini, produk terlaris, peringatan stok menipis |
| **Produk & Inventori** | Tambah / ubah / hapus produk, harga modal, stok naik-turun |
| **Transaksi** | Riwayat penjualan, detail transaksi, void (stok kembali) |
| **Pelanggan** | Data pelanggan, poin loyalti otomatis — 1 poin per Rp10.000 belanja |
| **Promo** | Promo persen (%) atau potongan tetap (Rp), dengan minimal belanja |
| **Laporan** | Omzet hari ini & total, penjualan per metode bayar, transaksi terbaru |
| **Karyawan** | Data karyawan, peran, komisi (%), absensi hadir |
| **Pengaturan Toko** | Ubah nama toko, reset data ke contoh awal |

## Cara Menjalankan

Tidak perlu install apa-apa:

1. Download / clone repo ini.
2. Buka `index.html` di browser (Chrome, Firefox, Edge, Safari).
3. Selesai. Data tersimpan otomatis di browser (localStorage, key `casirz`).

Tidak ada build step, tidak ada server, tidak ada database eksternal.

### Data Contoh

Aplikasi dimulai dengan 6 produk contoh (kafe):

- Kopi Susu Gula Aren — Rp18.000
- Es Kopi Hitam — Rp12.000
- Matcha Latte — Rp20.000
- Roti Bakar — Rp15.000
- Kentang Goreng — Rp13.000
- Air Mineral — Rp5.000

Plus 2 pelanggan contoh, 2 promo contoh, dan 2 karyawan contoh. Semua bisa dihapus atau diubah dari dalam aplikasi. Tombol **Reset Data** di Pengaturan akan mengembalikan data contoh ini.

## Teknologi

- Satu file HTML mandiri (`index.html`) — CSS dan JavaScript inline
- Vanilla JavaScript, tanpa framework dan tanpa dependensi wajib
- Penyimpanan: `localStorage` browser
- Font: system font (dengan opsi Google Font bila online)

## Lisensi

MIT — lihat file [LICENSE](LICENSE). Bebas dipakai, diubah, dan dibagikan, termasuk untuk usaha komersial.

## Catatan

Casirz adalah aplikasi kasir original yang ditulis dari nol. Bukan afiliasi dari aplikasi kasir lain mana pun.
