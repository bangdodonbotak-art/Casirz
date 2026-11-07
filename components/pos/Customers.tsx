"use client";

import { useState } from "react";
import { motion } from "framer-motion";
import { Trash2 } from "lucide-react";
import { useCasirz } from "@/lib/store";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
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

export default function Customers() {
  const { state, addCustomer, deleteCustomer } = useCasirz();
  const [name, setName] = useState("");
  const [phone, setPhone] = useState("");

  function submit() {
    if (!name.trim()) return;
    addCustomer({ name: name.trim(), phone: phone.trim() });
    setName("");
    setPhone("");
  }

  return (
    <div className="space-y-6">
      <motion.div initial={{ opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }}>
        <Card>
          <CardHeader>
            <CardTitle>Tambah Pelanggan</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="grid gap-4 sm:grid-cols-3">
              <div className="space-y-1.5">
                <Label>Nama</Label>
                <Input
                  placeholder="cth: Budi"
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                />
              </div>
              <div className="space-y-1.5">
                <Label>No. HP</Label>
                <Input
                  placeholder="08xxxxxxxxxx"
                  value={phone}
                  onChange={(e) => setPhone(e.target.value)}
                />
              </div>
              <div className="flex items-end">
                <Button onClick={submit} className="bg-emerald-600 hover:bg-emerald-700">
                  Tambah Pelanggan
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
                <TableHead>Nama</TableHead>
                <TableHead>No. HP</TableHead>
                <TableHead>Poin</TableHead>
                <TableHead className="text-right">Aksi</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {state.customers.map((cu) => (
                <TableRow key={cu.id}>
                  <TableCell className="font-medium">{cu.name}</TableCell>
                  <TableCell>{cu.phone || "-"}</TableCell>
                  <TableCell>
                    <Badge variant="secondary">{cu.points} poin</Badge>
                  </TableCell>
                  <TableCell className="text-right">
                    <Button
                      size="icon"
                      variant="ghost"
                      className="h-8 w-8 text-destructive"
                      onClick={() => deleteCustomer(cu.id)}
                    >
                      <Trash2 className="h-3 w-3" />
                    </Button>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
          <p className="mt-4 text-xs text-muted-foreground">
            Poin loyalti: 1 poin per Rp10.000 belanja. Poin didapat otomatis saat
            checkout dengan pelanggan terpilih.
          </p>
        </CardContent>
      </Card>
    </div>
  );
}
