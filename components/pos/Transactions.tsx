"use client";

import { useState } from "react";
import { motion } from "framer-motion";
import { Eye } from "lucide-react";
import { fmt, type Sale } from "@/lib/casirz";
import { useCasirz } from "@/lib/store";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";

export default function Transactions() {
  const { state, voidSale } = useCasirz();
  const [detail, setDetail] = useState<Sale | null>(null);
  const list = [...state.sales].reverse();

  return (
    <motion.div initial={{ opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }}>
      <Card>
        <CardContent className="pt-6">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>No. Order</TableHead>
                <TableHead>Waktu</TableHead>
                <TableHead>Item</TableHead>
                <TableHead>Total</TableHead>
                <TableHead>Bayar</TableHead>
                <TableHead className="text-right">Aksi</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {list.length === 0 && (
                <TableRow>
                  <TableCell colSpan={6} className="text-muted-foreground">
                    Belum ada transaksi.
                  </TableCell>
                </TableRow>
              )}
              {list.map((s) => (
                <TableRow key={s.id} className={s.voided ? "opacity-60" : ""}>
                  <TableCell>
                    <span className="font-medium">{s.code}</span>{" "}
                    {s.voided && <Badge variant="destructive">VOID</Badge>}
                  </TableCell>
                  <TableCell>{new Date(s.date).toLocaleString("id-ID")}</TableCell>
                  <TableCell className="max-w-64 truncate">
                    {s.items.map((it) => `${it.name} x${it.qty}`).join(", ")}
                  </TableCell>
                  <TableCell className="font-semibold">{fmt(s.total)}</TableCell>
                  <TableCell>{s.method}</TableCell>
                  <TableCell>
                    <div className="flex justify-end gap-1">
                      <Button size="icon" variant="outline" className="h-8 w-8" onClick={() => setDetail(s)}>
                        <Eye className="h-3 w-3" />
                      </Button>
                      {!s.voided && (
                        <Button
                          size="sm"
                          variant="destructive"
                          onClick={() => voidSale(s.id)}
                        >
                          Void
                        </Button>
                      )}
                    </div>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </CardContent>
      </Card>

      <Dialog open={detail !== null} onOpenChange={(o) => !o && setDetail(null)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>
              Detail {detail?.code}
              {detail?.voided ? " (VOID)" : ""}
            </DialogTitle>
          </DialogHeader>
          {detail && (
            <div className="space-y-3 text-sm">
              <div className="flex justify-between">
                <span className="text-muted-foreground">Waktu</span>
                <span>{new Date(detail.date).toLocaleString("id-ID")}</span>
              </div>
              <div className="flex justify-between">
                <span className="text-muted-foreground">Metode</span>
                <span>{detail.method}</span>
              </div>
              <div className="rounded-lg border p-3 font-mono text-xs whitespace-pre-line">
                {detail.items
                  .map((it) => `${it.name} x${it.qty}  ${fmt(it.price * it.qty)}`)
                  .join("\n")}
              </div>
              <div className="space-y-1">
                <div className="flex justify-between">
                  <span>Subtotal</span>
                  <span>{fmt(detail.subtotal)}</span>
                </div>
                <div className="flex justify-between">
                  <span>Diskon</span>
                  <span>−{fmt(detail.discount)}</span>
                </div>
                <div className="flex justify-between">
                  <span>Pajak</span>
                  <span>{fmt(detail.tax)}</span>
                </div>
                <div className="flex justify-between border-t pt-1 font-bold">
                  <span>Total</span>
                  <span>{fmt(detail.total)}</span>
                </div>
              </div>
              {detail.voided && (
                <p className="text-xs text-muted-foreground">
                  Transaksi ini sudah di-void — stok sudah dikembalikan.
                </p>
              )}
            </div>
          )}
        </DialogContent>
      </Dialog>
    </motion.div>
  );
}
