"use client";

import dynamic from "next/dynamic";
import Link from "next/link";
import { motion } from "framer-motion";
import {
  ArrowRight,
  BarChart3,
  Check,
  LayoutDashboard,
  Package,
  Percent,
  ReceiptText,
  Settings,
  ShoppingCart,
  Sparkles,
  Store,
  UserCog,
  Users,
} from "lucide-react";
import LenisProvider from "@/components/landing/LenisProvider";
import { buttonVariants } from "@/components/ui/button";
import { cn } from "@/lib/utils";

// 3D di-load malas (lazy) dan tanpa SSR agar tidak merusak build.
const Hero3D = dynamic(() => import("@/components/landing/Hero3D"), {
  ssr: false,
  loading: () => <div className="h-[320px] w-full sm:h-[420px] lg:h-[520px]" />,
});

const FEATURES = [
  {
    icon: ShoppingCart,
    title: "Kasir",
    desc: "Grid produk, keranjang, promo, diskon, pajak 11%, bayar Tunai / QRIS / Kartu / E-Wallet, hitung kembalian, dan struk.",
  },
  {
    icon: LayoutDashboard,
    title: "Dashboard",
    desc: "Omzet hari ini, laba, grafik penjualan 7 hari, produk terlaris, dan peringatan stok menipis.",
  },
  {
    icon: Package,
    title: "Produk & Inventori",
    desc: "Tambah, ubah, dan hapus produk. Harga modal, stok naik-turun, dan badge stok menipis otomatis.",
  },
  {
    icon: ReceiptText,
    title: "Transaksi",
    desc: "Riwayat penjualan lengkap dengan detail per order. Void transaksi dan stok kembali otomatis.",
  },
  {
    icon: Users,
    title: "Pelanggan",
    desc: "Data pelanggan dengan poin loyalti otomatis — 1 poin per Rp10.000 belanja.",
  },
  {
    icon: Percent,
    title: "Promo",
    desc: "Promo persen atau potongan tetap, lengkap dengan minimal belanja dan status aktif/nonaktif.",
  },
  {
    icon: BarChart3,
    title: "Laporan",
    desc: "Omzet hari ini dan total, penjualan per metode bayar, dan transaksi terbaru dalam satu layar.",
  },
  {
    icon: UserCog,
    title: "Karyawan",
    desc: "Data karyawan, peran, komisi persen, dan absensi harian.",
  },
  {
    icon: Settings,
    title: "Pengaturan Toko",
    desc: "Ubah nama toko, unduh semua data sebagai JSON, dan reset ke data contoh kapan saja.",
  },
];

const fadeUp = {
  initial: { opacity: 0, y: 24 },
  whileInView: { opacity: 1, y: 0 },
  viewport: { once: true, margin: "-80px" },
};

export default function LandingPage() {
  return (
    <LenisProvider>
      <div className="min-h-screen bg-zinc-950 text-zinc-100 antialiased">
        {/* Nav */}
        <header className="fixed inset-x-0 top-0 z-50 border-b border-white/10 bg-zinc-950/80 backdrop-blur">
          <div className="mx-auto flex max-w-6xl items-center justify-between px-4 py-4 sm:px-6">
            <a href="#" className="flex items-center gap-2.5">
              <span className="flex h-9 w-9 items-center justify-center rounded-xl bg-emerald-500 text-zinc-950">
                <Store className="h-5 w-5" />
              </span>
              <span className="text-lg font-bold tracking-tight">Casirz</span>
            </a>
            <nav className="hidden items-center gap-8 text-sm text-zinc-400 md:flex">
              <a href="#fitur" className="transition hover:text-zinc-100">Fitur</a>
              <a href="#cara" className="transition hover:text-zinc-100">Cara Pakai</a>
              <a href="#harga" className="transition hover:text-zinc-100">Harga</a>
            </nav>
            <Link
              href="/app"
              className={cn(buttonVariants(), "bg-emerald-500 text-zinc-950 hover:bg-emerald-400")}
            >
              Buka Kasir <ArrowRight className="ml-1 h-4 w-4" />
            </Link>
          </div>
        </header>

        {/* Hero */}
        <section className="relative overflow-hidden pt-32 pb-16 sm:pt-40">
          <div className="pointer-events-none absolute inset-0">
            <div className="absolute -top-32 left-1/2 h-96 w-[42rem] -translate-x-1/2 rounded-full bg-emerald-500/20 blur-3xl" />
            <div className="absolute right-0 top-64 h-72 w-72 rounded-full bg-amber-500/10 blur-3xl" />
          </div>
          <div className="relative mx-auto grid max-w-6xl items-center gap-10 px-4 sm:px-6 lg:grid-cols-2">
            <motion.div
              initial={{ opacity: 0, y: 28 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.7, ease: "easeOut" }}
            >
              <span className="inline-flex items-center gap-1.5 rounded-full border border-emerald-500/30 bg-emerald-500/10 px-3 py-1 text-xs font-medium text-emerald-300">
                <Sparkles className="h-3 w-3" />
                Gratis selamanya • Tanpa langganan
              </span>
              <h1 className="mt-6 text-5xl font-bold leading-[1.05] tracking-tight sm:text-6xl">
                Kasir yang terasa{" "}
                <span className="bg-gradient-to-r from-emerald-400 to-amber-400 bg-clip-text text-transparent">
                  mahal
                </span>
                , harganya Rp0.
              </h1>
              <p className="mt-5 max-w-lg text-lg leading-relaxed text-zinc-400">
                Casirz adalah aplikasi kasir (POS) gratis untuk UMKM Indonesia.
                Sembilan modul lengkap — kasir, stok, pelanggan, promo, laporan,
                karyawan — semua terbuka dari awal. Tanpa paywall, tanpa batas
                produk atau transaksi.
              </p>
              <div className="mt-8 flex flex-wrap gap-3">
                <Link
                  href="/app"
                  className={cn(buttonVariants({ size: "lg" }), "h-11 px-5 text-base bg-emerald-500 text-zinc-950 hover:bg-emerald-400")}
                >
                  Buka Kasir <ArrowRight className="ml-2 h-4 w-4" />
                </Link>
                <a
                  href="#fitur"
                  className={cn(buttonVariants({ size: "lg", variant: "outline" }), "h-11 px-5 text-base border-white/20 bg-transparent text-zinc-100 hover:bg-white/10")}
                >
                  Lihat Fitur
                </a>
              </div>
              <div className="mt-10 flex gap-8 text-sm">
                {[
                  ["9", "modul lengkap"],
                  ["Rp0", "per bulan"],
                  ["0", "fitur terkunci"],
                ].map(([v, l]) => (
                  <div key={l}>
                    <div className="text-2xl font-bold text-white">{v}</div>
                    <div className="text-zinc-500">{l}</div>
                  </div>
                ))}
              </div>
            </motion.div>
            <motion.div
              initial={{ opacity: 0, scale: 0.92 }}
              animate={{ opacity: 1, scale: 1 }}
              transition={{ duration: 0.8, delay: 0.15 }}
              className="relative"
            >
              <Hero3D />
              <p className="text-center text-xs text-zinc-600">
                Data tersimpan aman di browser kamu — bukan di server orang lain.
              </p>
            </motion.div>
          </div>
        </section>

        {/* Fitur */}
        <section id="fitur" className="mx-auto max-w-6xl px-4 py-20 sm:px-6">
          <motion.div {...fadeUp} transition={{ duration: 0.6 }}>
            <p className="text-sm font-semibold uppercase tracking-widest text-emerald-400">
              Semua fitur terbuka
            </p>
            <h2 className="mt-2 text-3xl font-bold tracking-tight sm:text-4xl">
              Satu aplikasi, sembilan modul.
            </h2>
            <p className="mt-3 max-w-2xl text-zinc-400">
              Tidak ada yang dikunci di balik langganan. Semua yang kamu lihat di
              bawah ini bisa langsung dipakai begitu kamu membuka kasir.
            </p>
          </motion.div>
          <div className="mt-10 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
            {FEATURES.map((f, i) => (
              <motion.div
                key={f.title}
                {...fadeUp}
                transition={{ duration: 0.5, delay: (i % 3) * 0.08 }}
                className="group rounded-2xl border border-white/10 bg-white/[0.03] p-6 transition hover:border-emerald-500/40 hover:bg-white/[0.05]"
              >
                <div className="flex h-11 w-11 items-center justify-center rounded-xl bg-emerald-500/15 text-emerald-400 transition group-hover:bg-emerald-500 group-hover:text-zinc-950">
                  <f.icon className="h-5 w-5" />
                </div>
                <h3 className="mt-4 text-lg font-semibold">{f.title}</h3>
                <p className="mt-1.5 text-sm leading-relaxed text-zinc-400">{f.desc}</p>
              </motion.div>
            ))}
          </div>
        </section>

        {/* Cara pakai */}
        <section id="cara" className="border-y border-white/10 bg-white/[0.02]">
          <div className="mx-auto max-w-6xl px-4 py-20 sm:px-6">
            <motion.div {...fadeUp} transition={{ duration: 0.6 }}>
              <p className="text-sm font-semibold uppercase tracking-widest text-emerald-400">
                Cara pakai
              </p>
              <h2 className="mt-2 text-3xl font-bold tracking-tight sm:text-4xl">
                Tiga langkah, langsung jualan.
              </h2>
            </motion.div>
            <div className="mt-10 grid gap-4 md:grid-cols-3">
              {[
                ["01", "Buka Kasir", "Klik tombol Buka Kasir. Tidak perlu daftar, tidak perlu instal apa pun."],
                ["02", "Atur Produkmu", "Ganti 6 produk contoh kafe dengan menu dan harga tokomu sendiri, atau langsung pakai contohnya."],
                ["03", "Mulai Transaksi", "Klik produk, pilih pelanggan dan promo, terima pembayaran, cetak struk. Selesai."],
              ].map(([n, t, d], i) => (
                <motion.div
                  key={n}
                  {...fadeUp}
                  transition={{ duration: 0.5, delay: i * 0.1 }}
                  className="rounded-2xl border border-white/10 p-6"
                >
                  <div className="text-4xl font-bold text-emerald-500/60">{n}</div>
                  <h3 className="mt-3 text-lg font-semibold">{t}</h3>
                  <p className="mt-1.5 text-sm leading-relaxed text-zinc-400">{d}</p>
                </motion.div>
              ))}
            </div>
          </div>
        </section>

        {/* Harga */}
        <section id="harga" className="mx-auto max-w-6xl px-4 py-20 sm:px-6">
          <motion.div {...fadeUp} transition={{ duration: 0.6 }} className="text-center">
            <p className="text-sm font-semibold uppercase tracking-widest text-emerald-400">
              Harga
            </p>
            <h2 className="mt-2 text-3xl font-bold tracking-tight sm:text-4xl">
              Gratis selamanya.
            </h2>
            <p className="mx-auto mt-3 max-w-xl text-zinc-400">
              Bukan trial 7 hari, bukan freemium. Semua modul, semua fitur,
              selamanya gratis.
            </p>
          </motion.div>
          <motion.div
            {...fadeUp}
            transition={{ duration: 0.6, delay: 0.1 }}
            className="mx-auto mt-10 max-w-md rounded-3xl border border-emerald-500/40 bg-gradient-to-b from-emerald-500/10 to-transparent p-8 text-center"
          >
            <div className="text-6xl font-bold tracking-tight">
              Rp0
              <span className="text-xl font-medium text-zinc-400"> /selamanya</span>
            </div>
            <ul className="mt-6 space-y-3 text-left text-sm">
              {[
                "9 modul lengkap, semua terbuka",
                "Produk & transaksi tanpa batas",
                "Poin loyalti pelanggan otomatis",
                "Promo, pajak, dan struk",
                "Data milikmu, tersimpan di browsermu",
              ].map((x) => (
                <li key={x} className="flex items-start gap-2.5">
                  <Check className="mt-0.5 h-4 w-4 shrink-0 text-emerald-400" />
                  <span className="text-zinc-300">{x}</span>
                </li>
              ))}
            </ul>
            <Link
              href="/app"
              className={cn(buttonVariants({ size: "lg" }), "mt-8 h-11 w-full px-5 text-base bg-emerald-500 text-zinc-950 hover:bg-emerald-400")}
            >
              Buka Kasir Sekarang <ArrowRight className="ml-2 h-4 w-4" />
            </Link>
          </motion.div>
        </section>

        {/* Footer */}
        <footer className="border-t border-white/10">
          <div className="mx-auto flex max-w-6xl flex-col items-center justify-between gap-4 px-4 py-8 text-sm text-zinc-500 sm:flex-row sm:px-6">
            <div className="flex items-center gap-2">
              <span className="flex h-7 w-7 items-center justify-center rounded-lg bg-emerald-500 text-zinc-950">
                <Store className="h-4 w-4" />
              </span>
              <span className="font-semibold text-zinc-300">Casirz</span>
              <span>— Kasir gratis untuk UMKM Indonesia.</span>
            </div>
            <span>MIT License • Dibangun dengan Next.js</span>
          </div>
        </footer>
      </div>
    </LenisProvider>
  );
}
