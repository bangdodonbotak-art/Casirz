"use client";

import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useState,
  type ReactNode,
} from "react";
import {
  STORAGE_KEY,
  fmt,
  loadState,
  seedState,
  uid,
  type CasirzState,
  type Customer,
  type Employee,
  type Product,
  type Promo,
  type Sale,
  type SaleItem,
} from "./casirz";

export { fmt };

interface CheckoutInput {
  code: string;
  items: SaleItem[];
  subtotal: number;
  discount: number;
  tax: number;
  total: number;
  method: string;
  cash: number;
  customerId: string | null;
}

interface CasirzContextValue {
  state: CasirzState;
  loaded: boolean;
  // Produk
  addProduct: (p: Omit<Product, "id">) => void;
  updateProduct: (id: string, p: Omit<Product, "id">) => void;
  adjustStock: (id: string, delta: number) => void;
  deleteProduct: (id: string) => void;
  // Pelanggan
  addCustomer: (c: Omit<Customer, "id" | "points">) => void;
  deleteCustomer: (id: string) => void;
  // Promo
  addPromo: (p: Omit<Promo, "id" | "active">) => void;
  togglePromo: (id: string) => void;
  deletePromo: (id: string) => void;
  // Transaksi
  recordSale: (input: CheckoutInput) => Sale;
  voidSale: (id: string) => void;
  // Karyawan
  addEmployee: (e: Omit<Employee, "id" | "present">) => void;
  togglePresent: (id: string) => void;
  deleteEmployee: (id: string) => void;
  // Toko
  saveStoreName: (name: string) => void;
  resetData: () => void;
}

const CasirzContext = createContext<CasirzContextValue | null>(null);

export function CasirzProvider({ children }: { children: ReactNode }) {
  const [state, setState] = useState<CasirzState>(() => seedState());
  const [loaded, setLoaded] = useState(false);

  // Muat dari localStorage sekali saat mount (hindari hydration mismatch).
  useEffect(() => {
    const saved = loadState();
    if (saved) setState(saved);
    setLoaded(true);
  }, []);

  // Simpan setiap perubahan.
  useEffect(() => {
    if (!loaded) return;
    try {
      localStorage.setItem(STORAGE_KEY, JSON.stringify(state));
    } catch {
      // storage penuh / tidak tersedia — abaikan
    }
  }, [state, loaded]);

  const addProduct = useCallback((p: Omit<Product, "id">) => {
    setState((s) => ({ ...s, products: [...s.products, { ...p, id: uid() }] }));
  }, []);

  const updateProduct = useCallback((id: string, p: Omit<Product, "id">) => {
    setState((s) => ({
      ...s,
      products: s.products.map((x) => (x.id === id ? { ...p, id } : x)),
    }));
  }, []);

  const adjustStock = useCallback((id: string, delta: number) => {
    setState((s) => ({
      ...s,
      products: s.products.map((x) =>
        x.id === id ? { ...x, stock: Math.max(0, x.stock + delta) } : x,
      ),
    }));
  }, []);

  const deleteProduct = useCallback((id: string) => {
    setState((s) => ({ ...s, products: s.products.filter((x) => x.id !== id) }));
  }, []);

  const addCustomer = useCallback((c: Omit<Customer, "id" | "points">) => {
    setState((s) => ({
      ...s,
      customers: [...s.customers, { ...c, id: uid(), points: 0 }],
    }));
  }, []);

  const deleteCustomer = useCallback((id: string) => {
    setState((s) => ({ ...s, customers: s.customers.filter((x) => x.id !== id) }));
  }, []);

  const addPromo = useCallback((p: Omit<Promo, "id" | "active">) => {
    setState((s) => ({
      ...s,
      promos: [...s.promos, { ...p, id: uid(), active: true }],
    }));
  }, []);

  const togglePromo = useCallback((id: string) => {
    setState((s) => ({
      ...s,
      promos: s.promos.map((x) => (x.id === id ? { ...x, active: !x.active } : x)),
    }));
  }, []);

  const deletePromo = useCallback((id: string) => {
    setState((s) => ({ ...s, promos: s.promos.filter((x) => x.id !== id) }));
  }, []);

  const recordSale = useCallback(
    (input: CheckoutInput): Sale => {
      const sale: Sale = {
        id: uid(),
        code: input.code,
        date: new Date().toISOString(),
        items: input.items,
        subtotal: input.subtotal,
        discount: input.discount,
        tax: input.tax,
        total: input.total,
        method: input.method,
        cash: input.cash,
        change: Math.max(input.cash - input.total, 0),
        customerId: input.customerId,
        voided: false,
      };
      setState((s) => {
        const products = s.products.map((p) => {
          const item = input.items.find((it) => it.productId === p.id);
          return item ? { ...p, stock: Math.max(0, p.stock - item.qty) } : p;
        });
        const customers = input.customerId
          ? s.customers.map((c) =>
              c.id === input.customerId
                ? { ...c, points: c.points + Math.floor(input.total / 10000) }
                : c,
            )
          : s.customers;
        return {
          ...s,
          products,
          customers,
          sales: [...s.sales, sale],
        };
      });
      return sale;
    },
    [],
  );

  const voidSale = useCallback((id: string) => {
    setState((s) => {
      const target = s.sales.find((x) => x.id === id);
      if (!target || target.voided) return s;
      const products = s.products.map((p) => {
        const item = target.items.find((it) => it.productId === p.id);
        return item ? { ...p, stock: p.stock + item.qty } : p;
      });
      return {
        ...s,
        products,
        sales: s.sales.map((x) => (x.id === id ? { ...x, voided: true } : x)),
      };
    });
  }, []);

  const addEmployee = useCallback((e: Omit<Employee, "id" | "present">) => {
    setState((s) => ({
      ...s,
      employees: [...s.employees, { ...e, id: uid(), present: false }],
    }));
  }, []);

  const togglePresent = useCallback((id: string) => {
    setState((s) => ({
      ...s,
      employees: s.employees.map((x) =>
        x.id === id ? { ...x, present: !x.present } : x,
      ),
    }));
  }, []);

  const deleteEmployee = useCallback((id: string) => {
    setState((s) => ({ ...s, employees: s.employees.filter((x) => x.id !== id) }));
  }, []);

  const saveStoreName = useCallback((name: string) => {
    setState((s) => ({ ...s, store: { name } }));
  }, []);

  const resetData = useCallback(() => {
    setState(seedState());
  }, []);

  const value = useMemo<CasirzContextValue>(
    () => ({
      state,
      loaded,
      addProduct,
      updateProduct,
      adjustStock,
      deleteProduct,
      addCustomer,
      deleteCustomer,
      addPromo,
      togglePromo,
      deletePromo,
      recordSale,
      voidSale,
      addEmployee,
      togglePresent,
      deleteEmployee,
      saveStoreName,
      resetData,
    }),
    [
      state,
      loaded,
      addProduct,
      updateProduct,
      adjustStock,
      deleteProduct,
      addCustomer,
      deleteCustomer,
      addPromo,
      togglePromo,
      deletePromo,
      recordSale,
      voidSale,
      addEmployee,
      togglePresent,
      deleteEmployee,
      saveStoreName,
      resetData,
    ],
  );

  return <CasirzContext.Provider value={value}>{children}</CasirzContext.Provider>;
}

export function useCasirz(): CasirzContextValue {
  const ctx = useContext(CasirzContext);
  if (!ctx) throw new Error("useCasirz harus dipakai di dalam <CasirzProvider>");
  return ctx;
}
