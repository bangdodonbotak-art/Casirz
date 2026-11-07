# Casirz — Rebuild Next.js

**Casirz** adalah aplikasi kasir (POS — Point of Sale) gratis untuk usaha kecil
Indonesia (UMKM). Semua fitur terbuka, tanpa paywall, tanpa langganan, tanpa
batas produk atau transaksi.

> **English summary:** Casirz is a free, open-source point-of-sale app for
> small Indonesian businesses. All features are free — no paywall, no
> subscription. Data is stored in your browser's localStorage.

Rebuild ini adalah **Casirz v2**: versi Next.js dari Casirz v1 (aplikasi
single-file HTML di `../casirz`). Semua fungsi POS dipertahankan, dengan
tampilan kelas premium dan stack modern.

## Stack

- **Next.js 15** (App Router) + **TypeScript** + **React 19**
- **Tailwind CSS v4** untuk styling
- **Framer Motion** untuk animasi halus (transisi tab, kartu, modal, grafik)
- **Lenis** untuk smooth scrolling di landing page
- **Three.js** via **@react-three/fiber** + **@react-three/drei** untuk elemen
  3D di hero landing (koin emas melayang, lazy-load, `ssr: false`)
- **shadcn/ui** untuk komponen siap pakai (Button, Card, Input, Badge, Tabs,
  Dialog, Table, Select, Label)
- **lucide-react** untuk ikon

## Fitur (9 Modul)

| Modul | Isi |
| --- | --- |
| **Landing** (`/`) | Hero premium gelap + aksen emerald/amber, elemen 3D, animasi Framer Motion, smooth scroll Lenis, section fitur, harga "Gratis selamanya" |
| **Dashboard** | Penjualan hari ini, laba, grafik 7 hari, produk terlaris, peringatan stok menipis |
| **Kasir** | Grid produk, keranjang (+/- jumlah), pelanggan, promo & diskon, pajak 11% (opsional), bayar Tunai / QRIS / Kartu / E-Wallet, hitung kembalian, struk |
| **Produk & Inventori** | Tambah / ubah / hapus produk, harga modal, stok naik-turun |
| **Transaksi** | Riwayat penjualan, detail transaksi, void (stok kembali) |
| **Pelanggan** | Data pelanggan, poin loyalti otomatis — 1 poin per Rp10.000 belanja |
| **Promo** | Promo persen (%) atau potongan tetap (Rp), dengan minimal belanja |
| **Laporan** | Omzet hari ini & total, penjualan per metode bayar, transaksi terbaru |
| **Karyawan** | Data karyawan, peran, komisi (%), absensi hadir |
| **Pengaturan Toko** | Ubah nama toko, unduh data (JSON), reset ke data contoh |

Data contoh awal: 6 produk kafe (Kopi Susu Gula Aren Rp18.000, Es Kopi Hitam
Rp12.000, Matcha Latte Rp20.000, Roti Bakar Rp15.000, Kentang Goreng Rp13.000,
Air Mineral Rp5.000). Semua data tersimpan di localStorage (key `casirz`) dan
kompatibel dengan Casirz v1.

## Cara Menjalankan

```bash
npm install
npm run dev     # buka http://localhost:3000
npm run build   # build produksi
npm run start   # jalankan hasil build
```

## Lisensi

MIT — lihat file `LICENSE` di repo Casirz v1.
