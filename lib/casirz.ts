// Model data Casirz — dipertahankan dari Casirz v1 (single-file HTML)
// agar data localStorage key "casirz" tetap kompatibel.

export interface Product {
  id: string;
  name: string;
  price: number;
  cost: number;
  stock: number;
  category: string;
}

export interface Customer {
  id: string;
  name: string;
  phone: string;
  points: number;
}

export interface Promo {
  id: string;
  code: string;
  type: "percent" | "fixed";
  value: number;
  minSpend: number;
  active: boolean;
}

export interface SaleItem {
  productId: string;
  name: string;
  price: number;
  qty: number;
}

export interface Sale {
  id: string;
  code: string;
  date: string; // ISO string
  items: SaleItem[];
  subtotal: number;
  discount: number;
  tax: number;
  total: number;
  method: string;
  cash: number;
  change: number;
  customerId: string | null;
  voided: boolean;
}

export interface Employee {
  id: string;
  name: string;
  role: string;
  commission: number;
  present: boolean;
}

export interface CasirzState {
  store: { name: string };
  products: Product[];
  customers: Customer[];
  promos: Promo[];
  sales: Sale[];
  employees: Employee[];
}

export const STORAGE_KEY = "casirz";

export const PAY_METHODS = ["Tunai", "QRIS", "Kartu", "E-Wallet"] as const;
export type PayMethod = (typeof PAY_METHODS)[number];

export function uid(): string {
  return "id" + Date.now().toString(36) + Math.floor(Math.random() * 1000);
}

export function fmt(n: number): string {
  return "Rp" + Number(n || 0).toLocaleString("id-ID");
}

export function todayStr(d?: string | Date): string {
  const x = d ? new Date(d) : new Date();
  return x.toISOString().slice(0, 10);
}

export function orderCode(n: number): string {
  return "CZ-" + String(n).padStart(5, "0");
}

export function seedState(): CasirzState {
  return {
    store: { name: "Casirz Cafe" },
    products: [
      { id: uid() + "1", name: "Kopi Susu Gula Aren", price: 18000, cost: 9000, stock: 50, category: "Minuman" },
      { id: uid() + "2", name: "Es Kopi Hitam", price: 12000, cost: 5000, stock: 40, category: "Minuman" },
      { id: uid() + "3", name: "Matcha Latte", price: 20000, cost: 10000, stock: 30, category: "Minuman" },
      { id: uid() + "4", name: "Roti Bakar", price: 15000, cost: 7000, stock: 25, category: "Makanan" },
      { id: uid() + "5", name: "Kentang Goreng", price: 13000, cost: 6000, stock: 35, category: "Makanan" },
      { id: uid() + "6", name: "Air Mineral", price: 5000, cost: 2500, stock: 100, category: "Minuman" },
    ],
    customers: [
      { id: uid() + "c1", name: "Budi", phone: "081234567890", points: 12 },
      { id: uid() + "c2", name: "Sari", phone: "081987654321", points: 5 },
    ],
    promos: [
      { id: uid() + "p1", code: "HEMAT10", type: "percent", value: 10, minSpend: 50000, active: true },
      { id: uid() + "p2", code: "POTONG5000", type: "fixed", value: 5000, minSpend: 30000, active: true },
    ],
    sales: [],
    employees: [
      { id: uid() + "e1", name: "Andi", role: "Kasir", commission: 2, present: false },
      { id: uid() + "e2", name: "Dewi", role: "Barista", commission: 1, present: false },
    ],
  };
}

/** Muat state dari localStorage; kembalikan null kalau belum ada / rusak. */
export function loadState(): CasirzState | null {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (!raw) return null;
    const parsed = JSON.parse(raw) as CasirzState;
    if (!parsed || !Array.isArray(parsed.products)) return null;
    return parsed;
  } catch {
    return null;
  }
}
