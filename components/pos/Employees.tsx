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

export default function Employees() {
  const { state, addEmployee, togglePresent, deleteEmployee } = useCasirz();
  const [name, setName] = useState("");
  const [role, setRole] = useState("");
  const [commission, setCommission] = useState("0");

  function submit() {
    if (!name.trim()) return;
    addEmployee({
      name: name.trim(),
      role: role.trim() || "Staff",
      commission: Number(commission || 0),
    });
    setName("");
    setRole("");
    setCommission("0");
  }

  return (
    <div className="space-y-6">
      <motion.div initial={{ opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }}>
        <Card>
          <CardHeader>
            <CardTitle>Tambah Karyawan</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="grid gap-4 sm:grid-cols-4">
              <div className="space-y-1.5">
                <Label>Nama</Label>
                <Input
                  placeholder="cth: Andi"
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                />
              </div>
              <div className="space-y-1.5">
                <Label>Peran</Label>
                <Input
                  placeholder="Kasir"
                  value={role}
                  onChange={(e) => setRole(e.target.value)}
                />
              </div>
              <div className="space-y-1.5">
                <Label>Komisi (%)</Label>
                <Input
                  type="number"
                  min={0}
                  value={commission}
                  onChange={(e) => setCommission(e.target.value)}
                />
              </div>
              <div className="flex items-end">
                <Button onClick={submit} className="bg-emerald-600 hover:bg-emerald-700">
                  Tambah Karyawan
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
                <TableHead>Peran</TableHead>
                <TableHead>Komisi</TableHead>
                <TableHead>Absensi Hari Ini</TableHead>
                <TableHead className="text-right">Aksi</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {state.employees.map((e) => (
                <TableRow key={e.id}>
                  <TableCell className="font-medium">{e.name}</TableCell>
                  <TableCell>{e.role}</TableCell>
                  <TableCell>{e.commission}%</TableCell>
                  <TableCell>
                    <Badge variant={e.present ? "default" : "secondary"}>
                      {e.present ? "Hadir" : "Belum hadir"}
                    </Badge>
                  </TableCell>
                  <TableCell>
                    <div className="flex justify-end gap-1">
                      <Button size="sm" variant="outline" onClick={() => togglePresent(e.id)}>
                        {e.present ? "Pulang" : "Absen Masuk"}
                      </Button>
                      <Button
                        size="icon"
                        variant="ghost"
                        className="h-8 w-8 text-destructive"
                        onClick={() => deleteEmployee(e.id)}
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
