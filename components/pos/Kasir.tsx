"use client";

import { useMemo, useState } from "react";
import { AnimatePresence, motion } from "framer-motion";
import { Minus, Plus, Printer, Search, ShoppingCart, Trash2 } from "lucide-react";
import { PAY_METHODS, fmt, orderCode, type Sale } from "@/lib/casirz";
import { useCasirz } from "@/lib/store";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";

interface CartLine {
  productId: string;
  qty: number;
}

export default function Kasir() {
  const { state, recordSale } = useCasirz();
  const [cart, setCart] = useState<CartLine[]>([]);
  const [query, setQuery] = useState("");
  const [customerId, setCustomerId] = useState<string>("");
  const [promoId, setPromoId] = useState<string>("");
  const [taxOn, setTaxOn] = useState(false);
  const [method, setMethod] = useState<string>("Tunai");
  const [cash, setCash] = useState("");
  const [receipt, setReceipt] = useState<Sale | null>(null);

  const productById = (id: string) => state.products.find((p) => p.id === id);

  const filtered = useMemo(
    () =>
      state.products.filter((p) =>
        p.name.toLowerCase().includes(query.toLowerCase()),
      ),
    [state.products, query],
  );

  const totals = useMemo(() => {
    const subtotal = cart.reduce((a, c) => {
      const p = productById(c.productId);
      return a + (p ? p.price * c.qty : 0);
    }, 0);
    const promo = state.promos.find((pr) => pr.id === promoId && pr.active);
    let discount = 0;
    if (promo && subtotal >= (promo.minSpend || 0)) {
      discount =
        promo.type === "percent"
          ? Math.round((subtotal * promo.value) / 100)
          : Math.min(promo.value, subtotal);
    }
    const taxable = subtotal - discount;
    const tax = taxOn ? Math.round(taxable * 0.11) : 0;
    return { subtotal, discount, tax, total: taxable + tax, promo };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [cart, promoId, taxOn, state.products, state.promos]);

  const cashNum = Number(cash || 0);
  const change = method === "Tunai" ? cashNum - totals.total : 0;

  function addToCart(id: string) {
    const p = productById(id);
    if (!p || p.stock <= 0) return;
    setCart((prev) => {
      const line = prev.find((c) => c.productId === id);
      const inCart = line ? line.qty : 0;
      if (inCart + 1 > p.stock) return prev;
      return line
        ? prev.map((c) => (c.productId === id ? { ...c, qty: c.qty + 1 } : c))
        : [...prev, { productId: id, qty: 1 }];
    });
  }

  function changeQty(id: string, d: number) {
    setCart((prev) => {
      const p = productById(id);
      return prev
        .map((c) => {
          if (c.productId !== id) return c;
          const nq = c.qty + d;
          if (nq <= 0) return null;
          if (p && nq > p.stock) return c;
          return { ...c, qty: nq };
        })
        .filter((c): c is CartLine => c !== null);
    });
  }

  function checkout() {
    if (cart.length === 0) return;
    if (method === "Tunai" && cashNum < totals.total) return;
    const items = cart
      .map((c) => {
        const p = productById(c.productId);
        if (!p || p.stock < c.qty) return null;
        return { productId: p.id, name: p.name, price: p.price, qty: c.qty };
      })
      .filter((x): x is NonNullable<typeof x> => x !== null);
    if (items.length !== cart.length) return;
    const sale = recordSale({
      code: orderCode(state.sales.length + 1),
      items,
      subtotal: totals.subtotal,
      discount: totals.discount,
      tax: totals.tax,
      total: totals.total,
      method,
      cash: method === "Tunai" ? cashNum : totals.total,
      customerId: customerId || null,
    });
    setReceipt(sale);
    setCart([]);
    setCash("");
    setPromoId("");
  }

  return (
    <div className="grid gap-6 lg:grid-cols-[1fr_360px] lg:items-start">
      <div>
        <div className="relative mb-4">
          <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
          <Input
            placeholder="Cari produk..."
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            className="pl-9"
          />
        </div>
        <div className="grid gap-3 sm:grid-cols-2 xl:grid-cols-3">
          <AnimatePresence>
            {filtered.map((p) => (
              <motion.button
                key={p.id}
                layout
                initial={{ opacity: 0, scale: 0.96 }}
                animate={{ opacity: 1, scale: 1 }}
                exit={{ opacity: 0, scale: 0.96 }}
                transition={{ duration: 0.2 }}
                onClick={() => addToCart(p.id)}
                disabled={p.stock <= 0}
                className="rounded-xl border bg-card p-4 text-left shadow-sm transition hover:border-emerald-500 hover:shadow-md disabled:opacity-45"
              >
                <div className="font-semibold">{p.name}</div>
                <div className="mt-1 font-bold text-emerald-600">{fmt(p.price)}</div>
                <div className="mt-1 text-xs text-muted-foreground">
                  Stok: {p.stock} • {p.category}
                </div>
              </motion.button>
            ))}
          </AnimatePresence>
          {filtered.length === 0 && (
            <p className="text-sm text-muted-foreground">Produk tidak ditemukan.</p>
          )}
        </div>
      </div>

      <Card className="lg:sticky lg:top-20">
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <ShoppingCart className="h-5 w-5 text-emerald-600" />
            Keranjang
          </CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          {cart.length === 0 ? (
            <p className="text-sm text-muted-foreground">Keranjang masih kosong.</p>
          ) : (
            <div className="space-y-2">
              {cart.map((c) => {
                const p = productById(c.productId);
                if (!p) return null;
                return (
                  <div
                    key={c.productId}
                    className="flex items-center justify-between gap-2 border-b pb-2 last:border-0"
                  >
                    <div className="min-w-0">
                      <div className="truncate text-sm font-medium">{p.name}</div>
                      <div className="text-xs text-muted-foreground">
                        {fmt(p.price)} × {c.qty} = {fmt(p.price * c.qty)}
                      </div>
                    </div>
                    <div className="flex items-center gap-1">
                      <Button
                        size="icon"
                        variant="outline"
                        className="h-7 w-7"
                        onClick={() => changeQty(c.productId, -1)}
                      >
                        <Minus className="h-3 w-3" />
                      </Button>
                      <span className="w-5 text-center text-sm font-semibold">
                        {c.qty}
                      </span>
                      <Button
                        size="icon"
                        variant="outline"
                        className="h-7 w-7"
                        onClick={() => changeQty(c.productId, 1)}
                      >
                        <Plus className="h-3 w-3" />
                      </Button>
                      <Button
                        size="icon"
                        variant="ghost"
                        className="h-7 w-7 text-destructive"
                        onClick={() => setCart((prev) => prev.filter((x) => x.productId !== c.productId))}
                      >
                        <Trash2 className="h-3 w-3" />
                      </Button>
                    </div>
                  </div>
                );
              })}
            </div>
          )}

          <div className="space-y-2">
            <Label>Pelanggan</Label>
            <Select value={customerId} onValueChange={(v) => setCustomerId(v ?? "")}>
              <SelectTrigger>
                <SelectValue placeholder="— Tanpa Pelanggan —" />
              </SelectTrigger>
              <SelectContent>
                {state.customers.map((cu) => (
                  <SelectItem key={cu.id} value={cu.id}>
                    {cu.name} ({cu.points} poin)
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          <div className="space-y-2">
            <Label>Promo</Label>
            <Select value={promoId} onValueChange={(v) => setPromoId(v ?? "")}>
              <SelectTrigger>
                <SelectValue placeholder="— Tanpa Promo —" />
              </SelectTrigger>
              <SelectContent>
                {state.promos
                  .filter((x) => x.active)
                  .map((pr) => (
                    <SelectItem key={pr.id} value={pr.id}>
                      {pr.code}
                    </SelectItem>
                  ))}
              </SelectContent>
            </Select>
          </div>

          <label className="flex cursor-pointer items-center gap-2 text-sm">
            <input
              type="checkbox"
              checked={taxOn}
              onChange={(e) => setTaxOn(e.target.checked)}
              className="h-4 w-4 accent-emerald-600"
            />
            Pajak 11%
          </label>

          <div className="space-y-1 text-sm">
            <div className="flex justify-between">
              <span>Subtotal</span>
              <span>{fmt(totals.subtotal)}</span>
            </div>
            <div className="flex justify-between">
              <span>
                Diskon
                {totals.promo ? ` (${totals.promo.code})` : ""}
              </span>
              <span>−{fmt(totals.discount)}</span>
            </div>
            <div className="flex justify-between">
              <span>Pajak 11%</span>
              <span>{fmt(totals.tax)}</span>
            </div>
            <div className="flex justify-between border-t pt-2 text-base font-bold">
              <span>Total</span>
              <span>{fmt(totals.total)}</span>
            </div>
          </div>

          <div className="space-y-2">
            <Label>Metode Bayar</Label>
            <div className="flex flex-wrap gap-2">
              {PAY_METHODS.map((m) => (
                <Button
                  key={m}
                  size="sm"
                  variant={method === m ? "default" : "outline"}
                  className={method === m ? "bg-emerald-600 hover:bg-emerald-700" : ""}
                  onClick={() => setMethod(m)}
                >
                  {m}
                </Button>
              ))}
            </div>
          </div>

          {method === "Tunai" && (
            <div className="space-y-2">
              <Label>Uang Tunai (Rp)</Label>
              <Input
                type="number"
                min={0}
                value={cash}
                onChange={(e) => setCash(e.target.value)}
                placeholder="0"
              />
              <div className="flex justify-between text-sm">
                <span>Kembalian</span>
                <span className="font-semibold">{fmt(Math.max(change, 0))}</span>
              </div>
              {cashNum > 0 && cashNum < totals.total && (
                <p className="text-xs text-amber-600">
                  Uang tunai kurang {fmt(totals.total - cashNum)}.
                </p>
              )}
            </div>
          )}

          <Button
            className="w-full bg-emerald-600 hover:bg-emerald-700"
            size="lg"
            disabled={cart.length === 0 || (method === "Tunai" && cashNum < totals.total)}
            onClick={checkout}
          >
            <Printer className="mr-2 h-4 w-4" />
            Bayar &amp; Cetak Struk
          </Button>
        </CardContent>
      </Card>

      <Dialog open={receipt !== null} onOpenChange={(o) => !o && setReceipt(null)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Struk — {receipt?.code}</DialogTitle>
          </DialogHeader>
          {receipt && (
            <div className="rounded-lg border border-dashed p-4 font-mono text-sm whitespace-pre-line">
              {[
                state.store.name,
                receipt.code,
                new Date(receipt.date).toLocaleString("id-ID"),
                "------------------------------",
                ...receipt.items.map(
                  (it) => `${it.name} x${it.qty}  ${fmt(it.price * it.qty)}`,
                ),
                "------------------------------",
                `Subtotal: ${fmt(receipt.subtotal)}`,
                `Diskon: -${fmt(receipt.discount)}`,
                `Pajak: ${fmt(receipt.tax)}`,
                `TOTAL: ${fmt(receipt.total)}`,
                `Bayar (${receipt.method}): ${fmt(receipt.cash)}`,
                ...(receipt.method === "Tunai"
                  ? [`Kembalian: ${fmt(receipt.change)}`]
                  : []),
                "Terima kasih!",
              ].join("\n")}
            </div>
          )}
          <Badge variant="secondary" className="w-fit">
            Stok sudah dikurangi &amp; penjualan tercatat
          </Badge>
        </DialogContent>
      </Dialog>
    </div>
  );
}
