"use client";

import { motion } from "framer-motion";
import { fmt, todayStr } from "@/lib/casirz";
import { useCasirz } from "@/lib/store";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

const fadeUp = {
  initial: { opacity: 0, y: 16 },
  animate: { opacity: 1, y: 0 },
};

export default function Reports() {
  const { state } = useCasirz();
  const valid = state.sales.filter((s) => !s.voided);
  const today = todayStr();
  const todaysSales = valid.filter((s) => todayStr(s.date) === today);
  const totalToday = todaysSales.reduce((a, s) => a + s.total, 0);
  const totalAll = valid.reduce((a, s) => a + s.total, 0);

  const byMethod = new Map<string, number>();
  valid.forEach((s) => byMethod.set(s.method, (byMethod.get(s.method) ?? 0) + s.total));
  const maxMethod = Math.max(...byMethod.values(), 1);
  const recent = [...state.sales].reverse().slice(0, 10);

  const cards = [
    { label: "Omzet Hari Ini", value: fmt(totalToday) },
    { label: "Transaksi Hari Ini", value: String(todaysSales.length) },
    { label: "Total Omzet", value: fmt(totalAll) },
    { label: "Total Transaksi", value: String(valid.length) },
  ];

  return (
    <div className="space-y-6">
      <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        {cards.map((c, i) => (
          <motion.div
            key={c.label}
            {...fadeUp}
            transition={{ duration: 0.4, delay: i * 0.06 }}
          >
            <Card>
              <CardHeader className="pb-2">
                <CardTitle className="text-sm font-medium text-muted-foreground">
                  {c.label}
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold tracking-tight">{c.value}</div>
              </CardContent>
            </Card>
          </motion.div>
        ))}
      </div>

      <motion.div {...fadeUp} transition={{ duration: 0.4, delay: 0.2 }}>
        <Card>
          <CardHeader>
            <CardTitle>Penjualan per Metode Bayar</CardTitle>
          </CardHeader>
          <CardContent className="space-y-3">
            {byMethod.size === 0 ? (
              <p className="text-sm text-muted-foreground">Belum ada penjualan.</p>
            ) : (
              [...byMethod.entries()].map(([method, total]) => (
                <div key={method}>
                  <div className="mb-1 flex justify-between text-sm">
                    <span>{method}</span>
                    <span className="font-semibold">{fmt(total)}</span>
                  </div>
                  <div className="h-2 overflow-hidden rounded-full bg-muted">
                    <motion.div
                      initial={{ width: 0 }}
                      animate={{ width: `${(total / maxMethod) * 100}%` }}
                      transition={{ duration: 0.6 }}
                      className="h-full rounded-full bg-emerald-500"
                    />
                  </div>
                </div>
              ))
            )}
          </CardContent>
        </Card>
      </motion.div>

      <motion.div {...fadeUp} transition={{ duration: 0.4, delay: 0.25 }}>
        <Card>
          <CardHeader>
            <CardTitle>Transaksi Terbaru</CardTitle>
          </CardHeader>
          <CardContent className="space-y-2">
            {recent.length === 0 ? (
              <p className="text-sm text-muted-foreground">Belum ada transaksi.</p>
            ) : (
              recent.map((s) => (
                <div
                  key={s.id}
                  className="flex justify-between border-b pb-2 text-sm last:border-0"
                >
                  <span>
                    {s.code} — {s.method}
                    {s.voided ? " — VOID" : ""}
                  </span>
                  <span className="font-semibold">{fmt(s.total)}</span>
                </div>
              ))
            )}
          </CardContent>
        </Card>
      </motion.div>
    </div>
  );
}
