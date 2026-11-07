"use client";

import { useState } from "react";
import { motion } from "framer-motion";
import { Minus, Pencil, Plus, Trash2 } from "lucide-react";
import { fmt, type Product } from "@/lib/casirz";
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
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";

interface FormState {
  name: string;
  category: string;
  price: string;
  cost: string;
  stock: string;
}

const emptyForm: FormState = { name: "", category: "", price: "", cost: "", stock: "" };

export default function Products() {
  const { state, addProduct, updateProduct, adjustStock, deleteProduct } = useCasirz();
  const [form, setForm] = useState<FormState>(emptyForm);
  const [editing, setEditing] = useState<Product | null>(null);
  const [editForm, setEditForm] = useState<FormState>(emptyForm);

  function submit() {
    const price = Number(form.price || 0);
    if (!form.name.trim() || price < 0) return;
    addProduct({
      name: form.name.trim(),
      category: form.category.trim() || "Umum",
      price,
      cost: Number(form.cost || 0),
      stock: Number(form.stock || 0),
    });
    setForm(emptyForm);
  }

  function openEdit(p: Product) {
    setEditing(p);
    setEditForm({
      name: p.name,
      category: p.category,
      price: String(p.price),
      cost: String(p.cost),
      stock: String(p.stock),
    });
  }

  function submitEdit() {
    if (!editing) return;
    const price = Number(editForm.price || 0);
    if (!editForm.name.trim() || price < 0) return;
    updateProduct(editing.id, {
      name: editForm.name.trim(),
      category: editForm.category.trim() || "Umum",
      price,
      cost: Number(editForm.cost || 0),
      stock: Number(editForm.stock || 0),
    });
    setEditing(null);
  }

  return (
    <div className="space-y-6">
      <motion.div initial={{ opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }}>
        <Card>
          <CardHeader>
            <CardTitle>Tambah Produk</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
              <div className="space-y-1.5">
                <Label>Nama Produk</Label>
                <Input
                  placeholder="cth: Kopi Susu"
                  value={form.name}
                  onChange={(e) => setForm({ ...form, name: e.target.value })}
                />
              </div>
              <div className="space-y-1.5">
                <Label>Kategori</Label>
                <Input
                  placeholder="Minuman"
                  value={form.category}
                  onChange={(e) => setForm({ ...form, category: e.target.value })}
                />
              </div>
              <div className="space-y-1.5">
                <Label>Harga Jual (Rp)</Label>
                <Input
                  type="number"
                  min={0}
                  value={form.price}
                  onChange={(e) => setForm({ ...form, price: e.target.value })}
                />
              </div>
              <div className="space-y-1.5">
                <Label>Harga Modal (Rp)</Label>
                <Input
                  type="number"
                  min={0}
                  value={form.cost}
                  onChange={(e) => setForm({ ...form, cost: e.target.value })}
                />
              </div>
              <div className="space-y-1.5">
                <Label>Stok</Label>
                <Input
                  type="number"
                  min={0}
                  value={form.stock}
                  onChange={(e) => setForm({ ...form, stock: e.target.value })}
                />
              </div>
              <div className="flex items-end">
                <Button onClick={submit} className="bg-emerald-600 hover:bg-emerald-700">
                  Tambah Produk
                </Button>
              </div>
            </div>
          </CardContent>
        </Card>
      </motion.div>

      <Card>
        <CardContent className="pt-6">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Produk</TableHead>
                <TableHead>Harga</TableHead>
                <TableHead>Modal</TableHead>
                <TableHead>Stok</TableHead>
                <TableHead className="text-right">Aksi</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {state.products.map((p) => (
                <TableRow key={p.id}>
                  <TableCell>
                    <div className="font-medium">{p.name}</div>
                    <div className="text-xs text-muted-foreground">{p.category}</div>
                  </TableCell>
                  <TableCell>{fmt(p.price)}</TableCell>
                  <TableCell>{fmt(p.cost)}</TableCell>
                  <TableCell>
                    <Badge variant={p.stock <= 10 ? "destructive" : "secondary"}>
                      {p.stock}
                    </Badge>
                  </TableCell>
                  <TableCell>
                    <div className="flex justify-end gap-1">
                      <Button size="icon" variant="outline" className="h-8 w-8" onClick={() => adjustStock(p.id, -1)}>
                        <Minus className="h-3 w-3" />
                      </Button>
                      <Button size="icon" variant="outline" className="h-8 w-8" onClick={() => adjustStock(p.id, 1)}>
                        <Plus className="h-3 w-3" />
                      </Button>
                      <Button size="icon" variant="outline" className="h-8 w-8" onClick={() => openEdit(p)}>
                        <Pencil className="h-3 w-3" />
                      </Button>
                      <Button size="icon" variant="ghost" className="h-8 w-8 text-destructive" onClick={() => deleteProduct(p.id)}>
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

      <Dialog open={editing !== null} onOpenChange={(o) => !o && setEditing(null)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Ubah Produk</DialogTitle>
          </DialogHeader>
          <div className="grid gap-4">
            <div className="space-y-1.5">
              <Label>Nama Produk</Label>
              <Input value={editForm.name} onChange={(e) => setEditForm({ ...editForm, name: e.target.value })} />
            </div>
            <div className="space-y-1.5">
              <Label>Kategori</Label>
              <Input value={editForm.category} onChange={(e) => setEditForm({ ...editForm, category: e.target.value })} />
            </div>
            <div className="grid grid-cols-3 gap-4">
              <div className="space-y-1.5">
                <Label>Harga Jual</Label>
                <Input type="number" min={0} value={editForm.price} onChange={(e) => setEditForm({ ...editForm, price: e.target.value })} />
              </div>
              <div className="space-y-1.5">
                <Label>Modal</Label>
                <Input type="number" min={0} value={editForm.cost} onChange={(e) => setEditForm({ ...editForm, cost: e.target.value })} />
              </div>
              <div className="space-y-1.5">
                <Label>Stok</Label>
                <Input type="number" min={0} value={editForm.stock} onChange={(e) => setEditForm({ ...editForm, stock: e.target.value })} />
              </div>
            </div>
            <Button onClick={submitEdit} className="bg-emerald-600 hover:bg-emerald-700">
              Simpan Perubahan
            </Button>
          </div>
        </DialogContent>
      </Dialog>
    </div>
  );
}
