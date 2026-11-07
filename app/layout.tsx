import type { Metadata } from "next";
import "./globals.css";

// Catatan: font sistem dipakai sengaja (tanpa next/font/google) agar build
// tidak bergantung pada unduhan Google Fonts saat runtime build.

export const metadata: Metadata = {
  title: "Casirz — Kasir Gratis untuk UMKM",
  description:
    "Casirz adalah aplikasi kasir (POS) gratis untuk UMKM Indonesia. Semua fitur terbuka: kasir, produk & stok, pelanggan & poin loyalti, promo, laporan, karyawan, dan pengaturan toko. Tanpa paywall, tanpa langganan.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="id">
      <body className="antialiased">{children}</body>
    </html>
  );
}
