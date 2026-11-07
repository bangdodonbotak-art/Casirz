"use client";

import { useState } from "react";
import { motion } from "framer-motion";
import { Trash2 } from "lucide-react";
import { fmt } from "@/lib/casirz";
import { useCasirz } from "@/lib/store";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";

export default function Promos() {
  const { state, addPromo, togglePromo, deletePromo } = useCasirz();
  const [code, setCode] = useState("");
  const [type, setType] = useState<"percent" | "fixed">("percent");
  const [value, setValue] = useState("");
  const [minSpend, setMinSpend] = useState("0");

  function submit() {
    const v = Number(value || 0);
    if (!code.trim() || v <= 0) return;
    addPromo({
      code: code.trim().toUpperCase(),
      type,
      value: v,
      minSpend: Number(minSpend || 0),
    });
    setCode("");
    setValue("");
    setMinSpend("0");
  }

  return (
    <div className="space-y-6">
      <motion.div initial={{ opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }}>
        <Card>
          <CardHeader>
            <CardTitle>Tambah Promo</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
              <div className="space-y-1.5">
                <Label>Kode Promo</Label>
                <Input
                  placeholder="cth: HEMAT10"
                  value={code}
                  onChange={(e) => setCode(e.target.value)}
                />
              </div>
              <div className="space-y-1.5">
                <Label>Jenis</Label>
                <Select
                  value={type}
                  onValueChange={(v) => setType(v as "percent" | "fixed")}
                >
                  <SelectTrigger>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="percent">Persen (%)</SelectItem>
                    <SelectItem value="fixed">Potongan Tetap (Rp)</SelectItem>
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-1.5">
                <Label>Nilai</Label>
                <Input
                  type="number"
                  min={0}
                  placeholder="10 untuk 10%"
                  value={value}
                  onChange={(e) => setValue(e.target.value)}
                />
              </div>
              <div className="space-y-1.5">
                <Label>Minimal Belanja (Rp)</Label>
                <Input
                  type="number"
                  min={0}
                  value={minSpend}
                  onChange={(e) => setMinSpend(e.target.value)}
                />
              </div>
            </div>
            <Button
              onClick={submit}
              className="mt-4 bg-emerald-600 hover:bg-emerald-700"
            >
              Tambah Promo
            </Button>
          </CardContent>
        </Card>
      </motion.div>

      <Card>
        <CardContent className="pt-6">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Kode</TableHead>
                <TableHead>Jenis</TableHead>
                <TableHead>Nilai</TableHead>
                <TableHead>Min. Belanja</TableHead>
                <TableHead>Status</TableHead>
                <TableHead className="text-right">Aksi</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {state.promos.map((pr) => (
                <TableRow key={pr.id}>
                  <TableCell className="font-semibold">{pr.code}</TableCell>
                  <TableCell>{pr.type === "percent" ? "Persen" : "Potongan"}</TableCell>
                  <TableCell>
                    {pr.type === "percent" ? `${pr.value}%` : fmt(pr.value)}
                  </TableCell>
                  <TableCell>{fmt(pr.minSpend || 0)}</TableCell>
                  <TableCell>
                    <Badge variant={pr.active ? "default" : "secondary"}>
                      {pr.active ? "Aktif" : "Nonaktif"}
                    </Badge>
                  </TableCell>
                  <TableCell>
                    <div className="flex justify-end gap-1">
                      <Button
                        size="sm"
                        variant="outline"
                        onClick={() => togglePromo(pr.id)}
                      >
                        {pr.active ? "Nonaktifkan" : "Aktifkan"}
                      </Button>
                      <Button
                        size="icon"
                        variant="ghost"
                        className="h-8 w-8 text-destructive"
                        onClick={() => deletePromo(pr.id)}
                      >
                        <Trash2 className="h-3 w-3" />
                      </Button>
                    </div>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </CardContent>
      </Card>
    </div>
  );
}
