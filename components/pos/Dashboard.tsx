"use client";

import { motion } from "framer-motion";
import {
  AlertTriangle,
  Banknote,
  Package,
  ReceiptText,
  TrendingUp,
} from "lucide-react";
import { fmt, todayStr } from "@/lib/casirz";
import { useCasirz } from "@/lib/store";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

const fadeUp = {
  initial: { opacity: 0, y: 16 },
  animate: { opacity: 1, y: 0 },
};

export default function Dashboard() {
  const { state } = useCasirz();
  const today = todayStr();
  const todaysSales = state.sales.filter(
    (s) => !s.voided && todayStr(s.date) === today,
  );
  const totalToday = todaysSales.reduce((a, s) => a + s.total, 0);
  const profitToday = todaysSales.reduce(
    (a, s) =>
      a +
      s.items.reduce((x, it) => {
        const p = state.products.find((pp) => pp.id === it.productId);
        return x + (p ? (p.price - p.cost) * it.qty : 0);
      }, 0),
    0,
  );

  const lowStock = state.products.filter((p) => p.stock <= 10);

  const counts = new Map<string, number>();
  state.sales.forEach((s) => {
    if (s.voided) return;
    s.items.forEach((it) => counts.set(it.name, (counts.get(it.name) ?? 0) + it.qty));
  });
  const topProducts = [...counts.entries()]
    .sort((a, b) => b[1] - a[1])
    .slice(0, 5);

  // Grafik 7 hari terakhir
  const days: { label: string; total: number }[] = [];
  for (let i = 6; i >= 0; i--) {
    const d = new Date();
    d.setDate(d.getDate() - i);
    const key = d.toISOString().slice(0, 10);
    const total = state.sales
      .filter((s) => !s.voided && todayStr(s.date) === key)
      .reduce((a, s) => a + s.total, 0);
    days.push({
      label: d.toLocaleDateString("id-ID", { weekday: "short" }),
      total,
    });
  }
  const maxDay = Math.max(...days.map((d) => d.total), 1);

  const stats = [
    {
      label: "Penjualan Hari Ini",
      value: fmt(totalToday),
      icon: Banknote,
      hint: `${todaysSales.length} transaksi`,
    },
    {
      label: "Laba Hari Ini",
      value: fmt(profitToday),
      icon: TrendingUp,
      hint: "Setelah dikurangi modal",
    },
    {
      label: "Transaksi Hari Ini",
      value: String(todaysSales.length),
      icon: ReceiptText,
      hint: "Semua metode bayar",
    },
    {
      label: "Total Produk",
      value: String(state.products.length),
      icon: Package,
      hint: `${lowStock.length} stok menipis`,
    },
  ];

  return (
    <div className="space-y-6">
      <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        {stats.map((s, i) => (
          <motion.div
            key={s.label}
            {...fadeUp}
            transition={{ duration: 0.4, delay: i * 0.06 }}
          >
            <Card>
              <CardHeader className="flex flex-row items-center justify-between pb-2">
                <CardTitle className="text-sm font-medium text-muted-foreground">
                  {s.label}
                </CardTitle>
                <s.icon className="h-4 w-4 text-emerald-600" />
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold tracking-tight">{s.value}</div>
                <p className="text-xs text-muted-foreground">{s.hint}</p>
              </CardContent>
            </Card>
          </motion.div>
        ))}
      </div>

      <motion.div {...fadeUp} transition={{ duration: 0.4, delay: 0.2 }}>
        <Card>
          <CardHeader>
            <CardTitle>Penjualan 7 Hari Terakhir</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="flex h-40 items-end gap-2">
              {days.map((d) => (
                <div key={d.label} className="flex flex-1 flex-col items-center gap-2">
                  <span className="text-[11px] font-medium text-muted-foreground">
                    {d.total > 0 ? fmt(d.total) : ""}
                  </span>
                  <motion.div
                    initial={{ height: 0 }}
                    animate={{ height: `${Math.max((d.total / maxDay) * 100, 2)}%` }}
                    transition={{ duration: 0.6, ease: "easeOut" }}
                    className="w-full max-w-12 rounded-t-md bg-emerald-500/90"
                    title={`${d.label}: ${fmt(d.total)}`}
                  />
                  <span className="text-xs text-muted-foreground">{d.label}</span>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      </motion.div>

      <div className="grid gap-4 md:grid-cols-2">
        <motion.div {...fadeUp} transition={{ duration: 0.4, delay: 0.25 }}>
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <AlertTriangle className="h-4 w-4 text-amber-500" />
                Peringatan Stok Menipis
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-2">
              {lowStock.length === 0 ? (
                <p className="text-sm text-muted-foreground">Semua stok aman.</p>
              ) : (
                lowStock.map((p) => (
                  <div
                    key={p.id}
                    className="flex items-center justify-between text-sm"
                  >
                    <span>{p.name}</span>
                    <Badge variant="destructive">Sisa {p.stock}</Badge>
                  </div>
                ))
              )}
            </CardContent>
          </Card>
        </motion.div>

        <motion.div {...fadeUp} transition={{ duration: 0.4, delay: 0.3 }}>
          <Card>
            <CardHeader>
              <CardTitle>Produk Terlaris</CardTitle>
            </CardHeader>
            <CardContent className="space-y-2">
              {topProducts.length === 0 ? (
                <p className="text-sm text-muted-foreground">Belum ada penjualan.</p>
              ) : (
                topProducts.map(([name, qty], i) => (
                  <div
                    key={name}
                    className="flex items-center justify-between text-sm"
                  >
                    <span>
                      {i + 1}. {name}
                    </span>
                    <Badge variant="secondary">{qty} terjual</Badge>
                  </div>
                ))
              )}
            </CardContent>
          </Card>
        </motion.div>
      </div>
    </div>
  );
}
