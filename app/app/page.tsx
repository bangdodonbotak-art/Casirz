"use client";

import { useState } from "react";
import Link from "next/link";
import { AnimatePresence, motion } from "framer-motion";
import {
  BarChart3,
  LayoutDashboard,
  Package,
  Percent,
  ReceiptText,
  Settings,
  ShoppingCart,
  Store,
  UserCog,
  Users,
} from "lucide-react";
import { CasirzProvider, useCasirz } from "@/lib/store";
import Customers from "@/components/pos/Customers";
import Dashboard from "@/components/pos/Dashboard";
import Employees from "@/components/pos/Employees";
import Kasir from "@/components/pos/Kasir";
import Products from "@/components/pos/Products";
import Promos from "@/components/pos/Promos";
import Reports from "@/components/pos/Reports";
import SettingsPanel from "@/components/pos/Settings";
import Transactions from "@/components/pos/Transactions";
import { cn } from "@/lib/utils";

const TABS = [
  { id: "dashboard", label: "Dashboard", icon: LayoutDashboard },
  { id: "kasir", label: "Kasir", icon: ShoppingCart },
  { id: "produk", label: "Produk", icon: Package },
  { id: "transaksi", label: "Transaksi", icon: ReceiptText },
  { id: "pelanggan", label: "Pelanggan", icon: Users },
  { id: "promo", label: "Promo", icon: Percent },
  { id: "laporan", label: "Laporan", icon: BarChart3 },
  { id: "karyawan", label: "Karyawan", icon: UserCog },
  { id: "pengaturan", label: "Pengaturan", icon: Settings },
] as const;

type TabId = (typeof TABS)[number]["id"];

const TITLES: Record<TabId, { title: string; desc: string }> = {
  dashboard: { title: "Dashboard", desc: "Ringkasan usaha hari ini" },
  kasir: { title: "Kasir", desc: "Buat penjualan baru" },
  produk: { title: "Produk & Inventori", desc: "Kelola produk, harga, dan stok" },
  transaksi: { title: "Transaksi", desc: "Riwayat penjualan dan void" },
  pelanggan: { title: "Pelanggan", desc: "Data pelanggan dan poin loyalti" },
  promo: { title: "Promo", desc: "Kode promo persen dan potongan" },
  laporan: { title: "Laporan", desc: "Omzet dan penjualan per metode bayar" },
  karyawan: { title: "Karyawan", desc: "Tim, komisi, dan absensi" },
  pengaturan: { title: "Pengaturan Toko", desc: "Nama toko dan data" },
};

function Shell() {
  const [tab, setTab] = useState<TabId>("kasir");
  const { state } = useCasirz();

  return (
    <div className="flex min-h-screen bg-zinc-50">
      {/* Sidebar */}
      <aside className="fixed inset-y-0 left-0 z-30 hidden w-64 flex-col bg-zinc-950 text-zinc-100 md:flex">
        <div className="flex items-center gap-2.5 px-5 pb-5 pt-6">
          <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-emerald-500 text-zinc-950">
            <Store className="h-5 w-5" />
          </div>
          <div className="min-w-0">
            <div className="truncate font-bold leading-tight">{state.store.name}</div>
            <div className="text-xs text-emerald-400">Casirz POS</div>
          </div>
        </div>
        <nav className="flex-1 space-y-1 px-3">
          {TABS.map((t) => (
            <button
              key={t.id}
              onClick={() => setTab(t.id)}
              className={cn(
                "flex w-full items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium transition",
                tab === t.id
                  ? "bg-emerald-500/15 text-emerald-300"
                  : "text-zinc-400 hover:bg-white/5 hover:text-zinc-100",
              )}
            >
              <t.icon className="h-4 w-4 shrink-0" />
              {t.label}
              {tab === t.id && (
                <motion.span
                  layoutId="tab-dot"
                  className="ml-auto h-2 w-2 rounded-full bg-emerald-400"
                />
              )}
            </button>
          ))}
        </nav>
        <div className="p-4 text-xs leading-relaxed text-zinc-500">
          Gratis selamanya.
          <br />
          Data tersimpan di browser ini.
        </div>
      </aside>

      {/* Konten */}
      <div className="flex min-h-screen flex-1 flex-col md:pl-64">
        <header className="sticky top-0 z-20 border-b bg-white/80 backdrop-blur">
          <div className="flex items-center justify-between px-4 py-4 sm:px-8">
            <div>
              <h1 className="text-xl font-bold tracking-tight">{TITLES[tab].title}</h1>
              <p className="text-sm text-muted-foreground">{TITLES[tab].desc}</p>
            </div>
            <Link
              href="/"
              className="rounded-lg border px-3 py-2 text-sm font-medium transition hover:bg-zinc-100"
            >
              ← Beranda
            </Link>
          </div>
          {/* Navigasi mobile */}
          <nav className="flex gap-1 overflow-x-auto px-4 pb-3 md:hidden">
            {TABS.map((t) => (
              <button
                key={t.id}
                onClick={() => setTab(t.id)}
                className={cn(
                  "whitespace-nowrap rounded-full border px-3 py-1.5 text-xs font-medium",
                  tab === t.id
                    ? "border-emerald-600 bg-emerald-600 text-white"
                    : "bg-white",
                )}
              >
                {t.label}
              </button>
            ))}
          </nav>
        </header>

        <main className="flex-1 px-4 py-6 sm:px-8">
          <AnimatePresence mode="wait">
            <motion.div
              key={tab}
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -8 }}
              transition={{ duration: 0.22 }}
            >
              {tab === "dashboard" && <Dashboard />}
              {tab === "kasir" && <Kasir />}
              {tab === "produk" && <Products />}
              {tab === "transaksi" && <Transactions />}
              {tab === "pelanggan" && <Customers />}
              {tab === "promo" && <Promos />}
              {tab === "laporan" && <Reports />}
              {tab === "karyawan" && <Employees />}
              {tab === "pengaturan" && <SettingsPanel />}
            </motion.div>
          </AnimatePresence>
        </main>
      </div>
    </div>
  );
}

export default function AppPage() {
  return (
    <CasirzProvider>
      <Shell />
    </CasirzProvider>
  );
}
