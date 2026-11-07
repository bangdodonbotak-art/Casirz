"use client";

import { useEffect, useState } from "react";
import { motion } from "framer-motion";
import { Download, RotateCcw, Save } from "lucide-react";
import { useCasirz } from "@/lib/store";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

export default function Settings() {
  const { state, saveStoreName, resetData } = useCasirz();
  const [name, setName] = useState(state.store.name);
  const [saved, setSaved] = useState(false);

  useEffect(() => {
    setName(state.store.name);
  }, [state.store.name]);

  function save() {
    const trimmed = name.trim();
    if (!trimmed) return;
    saveStoreName(trimmed);
    setSaved(true);
    setTimeout(() => setSaved(false), 2000);
  }

  function exportData() {
    const blob = new Blob([JSON.stringify(state, null, 2)], {
      type: "application/json",
    });
    const a = document.createElement("a");
    a.href = URL.createObjectURL(blob);
    a.download = "casirz-data.json";
    a.click();
    URL.revokeObjectURL(a.href);
  }

  function reset() {
    if (!window.confirm("Reset semua data ke contoh awal?")) return;
    resetData();
  }

  return (
    <div className="max-w-2xl space-y-6">
      <motion.div initial={{ opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }}>
        <Card>
          <CardHeader>
            <CardTitle>Pengaturan Toko</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="space-y-1.5">
              <Label>Nama Toko</Label>
              <Input value={name} onChange={(e) => setName(e.target.value)} />
            </div>
            <Button onClick={save} className="bg-emerald-600 hover:bg-emerald-700">
              <Save className="mr-2 h-4 w-4" />
              {saved ? "Tersimpan!" : "Simpan Nama Toko"}
            </Button>
          </CardContent>
        </Card>
      </motion.div>

      <motion.div
        initial={{ opacity: 0, y: 12 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.08 }}
      >
        <Card>
          <CardHeader>
            <CardTitle>Data</CardTitle>
          </CardHeader>
          <CardContent className="space-y-3">
            <p className="text-sm text-muted-foreground">
              Data tersimpan di browser ini (localStorage, key &quot;casirz&quot;).
              Semua modul — produk, pelanggan, promo, transaksi, karyawan —
              tersimpan otomatis setiap ada perubahan.
            </p>
            <div className="flex flex-wrap gap-2">
              <Button variant="secondary" onClick={exportData}>
                <Download className="mr-2 h-4 w-4" />
                Unduh Data (JSON)
              </Button>
              <Button variant="destructive" onClick={reset}>
                <RotateCcw className="mr-2 h-4 w-4" />
                Reset ke Data Contoh
              </Button>
            </div>
          </CardContent>
        </Card>
      </motion.div>
    </div>
  );
}
