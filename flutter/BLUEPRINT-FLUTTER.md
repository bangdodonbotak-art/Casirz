# BLUEPRINT — Casirz ERP (Flutter)

> **Status:** FASE 0 — blueprint beku. Belum ada kode fitur.
> **Tanggal:** 15 November 2026
> **Dokumen induk:** `~/workspace/goals/casirz-pos-app/files/analisa-casirz-erp.md`
> (laporan analisa 557 baris — SPEC utama; semua angka §3.3/§3.5 di bawah disalin
> dari laporan itu, bukan dikarang)
> **Blueprint web yang diselaraskan:** `~/workspace/casirz-next/BLUEPRINT.md`
> (jalur Dexie/web — proyek web v2 di `~/workspace/casirz-next` TETAP UTUH,
> tidak diubah, tetap hidup sebagai back-office)
> **Proyek Flutter:** `~/workspace/casirz-flutter` — package `com.casirz.app`

## 0. Keputusan Dony (final — jangan diubah tanpa perintah Dony)

| No | Keputusan | Status |
|---|---|---|
| 1 | Framework: **Flutter** (Dart). Web Next.js v2 tetap hidup sebagai back-office. | Beku |
| 2 | Absensi: **PIN saja** (BUKAN selfie). | Beku |
| 3 | **Stok minus: TIDAK DIBLOKIR — cukup DIMUNCULIN.** Penjualan TETAP BOLEH jalan walau stok bahan jadi minus; kasir tidak boleh kehalang jualan gara-gara stok. Stok minus ditampilkan jelas (angka minus warna merah + badge "Stok Minus" di daftar bahan dan di menu yang memakai bahan itu + masuk alert stok Command Center). Interface Inventory: TIDAK ADA penolakan transaksi karena stok — hanya penanda visual + alert. (Keputusan Dony 15 Nov 2026 — **mengubah** default "blokir" di laporan analisa §7 no. 7 dan brief awal Fase 0.) | Beku |
| 4 | Keystore + Play Console $25: **NGGAK USAH dulu** — nanti saat rilis. Bukan blocker build. Jangan minta keystore. | Beku |
| 5 | Komisi ojol: **configurable di settings, default 0/kosong. JANGAN dikarang angkanya.** Dony yang isi tarif GoFood/GrabFood/ShopeeFood. | Beku |
| 6 | Supabase: **rancang dari awal** (skema + outbox), aktifkan setelah lokal stabil (Fase 7). | Beku |
| 7 | Seed demo: **"Warkop Kekinian Preset" Rp60jt** (bukan rencana investor Warkop Hits Rp50jt — sengaja dibedakan). | Beku |
| 8 | PPN 11% manual (toggle) + service charge / PB1 bisa diedit. | Beku |
| 9 | Uang = **integer Rupiah** di semua perhitungan. Bahasa UI **Indonesia**. | Beku |
| 10 | Nama APK + package id: `com.casirz.app`. Repo tetap open-source publik. | Beku |

## 1. Prinsip beku (tidak bisa ditawar — dari laporan §3.1)

1. **Database lokal (Drift/SQLite) = sumber kebenaran.** UI tidak pernah bicara
   ke internet langsung. Semua tulis lokal dulu, sinkron belakangan (Fase 7).
2. **Uang = integer Rupiah.** Tidak ada float untuk uang. Kuantitas bahan
   dibulatkan 3 desimal (gram/ml/pcs).
3. **REA ledger = satu-satunya jalan ke laporan.** Setiap event bisnis WAJIB
   mem-posting jurnal seimbang (Debit = Kredit) dalam SATU transaksi Drift
   yang sama dengan mutasi stok/penjualannya. Jurnal tidak seimbang = ditolak
   (throw). Tidak ada jalan pintas.
4. **HPP dari BOM, bukan dari angka ketik.** HPP tiap penjualan dibekukan
   (snapshot per baris penjualan) saat penjualan terjadi — laporan tidak pernah
   menghitung ulang HPP lama dari harga bahan yang baru.
5. **Zero placeholder.** Tidak ada tombol palsu, tidak ada `TODO`, tidak ada
   `google_fonts` (font sistem — build VM gagal fetch Google Fonts).
6. **Bahasa UI Indonesia**, format Rp via `NumberFormat.currency(locale:
   'id_ID', symbol: 'Rp', decimalDigits: 0)`.
7. **Stok minus diizinkan** (keputusan no. 3 di atas). Aturan lengkapnya di §6.

## 2. Penyelarasan dari blueprint web (Dexie → Drift)

Blueprint web (`~/workspace/casirz-next/BLUEPRINT.md`) ditulis untuk
Dexie/IndexedDB + Zustand. Yang berubah di jalur Flutter — dan hanya itu:

| Aspek | Web (Dexie) | Flutter (Drift) |
|---|---|---|
| Database lokal | Dexie (IndexedDB), database `casirz-db` v1 | Drift (SQLite), database `casirz.db`, `schemaVersion = 1` |
| State | Zustand store + `liveQuery` | Riverpod (`flutter_riverpod`) + Drift `Stream` (`watch`) |
| Uang | `number` integer Rp | `int` (Dart `int` 64-bit) |
| Kuantitas bahan | `number` 3 desimal | `double`, dibulatkan 3 desimal saat tulis (`round3`) |
| `avgCost` | 2 desimal + `totalValue` integer | **`avgCostMilli` integer (mili-Rupiah, Rp × 1000)** + `totalValue` integer — lihat §4.2 (temuan ensemble yang diterapkan) |
| Transaksi atomik | `db.transaction()` Dexie | `db.transaction(() async {...})` Drift; `Ledger`/`Bom` TIDAK PERNAH membuka transaksi sendiri — lihat §5 |
| Migrasi localStorage | Langsung baca `localStorage["casirz"]` di browser | **Import file JSON** (`casirz-export-v1.json`, diekspor dari web v2) via `file_picker` — lihat §9 |
| Laporan | `window.print()` + CSS print | Export CSV (`csv` + `share_plus`) + print PDF (`printing`) |
| Struk thermal | Dialog teks + `@media print` | `PrinterPort` (abstraksi ESC/POS, §5.5) via `unified_esc_pos_printer` |
| Chart | Recharts | `fl_chart` |
| Font | Font sistem (tanpa `next/font/google`) | Font sistem (tanpa `google_fonts`) |
| Navigasi | Sidebar md+ / bottom nav mobile | Sidebar tablet landscape / bottom nav mobile portrait ≤5 + "Lainnya" (§8) |

Yang **TIDAK berubah** (disalin 1:1 sebagai spesifikasi): bagan akun (§3),
aturan posting per event (§3), rumus HPP + moving average (§4), seed demo
(§10), rencana sinkronisasi (§11), dan rencana fase (§12).

## 3. Skema Drift (SQLite) — cermin 1:1 dari laporan §3.2

### 3.1 Aturan kolom umum

- Semua tabel punya `id TEXT PRIMARY KEY` berisi **UUID v4 yang dibuat di
  device** (`uuid` package) — push bisa diulang dengan aman tanpa duplikat.
- Semua tabel punya kolom sync (kecuali `syncOutbox`, `syncState`, `settings`):
  `updatedAt INTEGER` (epoch milidetik UTC), `deviceId TEXT` (id device pembuat
  baris), `isDeleted` di Dart → kolom SQLite **`_deleted` INTEGER (0/1)**
  (nama Dart tidak boleh diawali underscore karena itu private di Dart — pakai
  `.named('_deleted')` di definisi Drift; nama kolom SQLite tetap `_deleted`
  agar cocok dengan skema Supabase nanti).
- `date` / `openedAt` / `closedAt` / `clockIn` / `clockOut` / `paidAt` /
  `purchaseDate` = `INTEGER` epoch milidetik UTC. `period` payroll =
  `TEXT 'yyyy-MM'`. `type`/`status`/`method`/`channel` = `TEXT` dengan nilai
  enum yang ditulis di §3.2 (jangan string bebas).
- Foreign key dideklarasikan di Drift (`.references(...)`) dan ditegakkan
  (`PRAGMA foreign_keys = ON` — default Drift di `drift_flutter`).
- **Kelas sync per tabel** (menentukan aturan sinkronisasi §11 — temuan
  ensemble yang diterapkan):
  - `APPEND` — event yang tidak bisa diubah: `sales`, `saleLines`,
    `salePayments`, `stockMoves`, `journals`, `journalLines`, `expenses`,
    `attendance`, `payrolls`. Aturan: **INSERT OR IGNORE berdasar UUID**,
    tidak pernah UPDATE/DELETE; salah catat → buat entri koreksi baru
    (jurnal pembalik / void). Outbox **melarang** operasi `delete` untuk
    tabel-tabel ini.
  - `MASTER` — data yang bisa diedit: `products`, `customers`, `promos`,
    `ingredients`, `recipes`, `recipeLines`, `accounts`, `shifts`,
    `pettyCash`, `orders`, `orderLines`, `tables`, `assets`,
    `stockOpnames`, `stockOpnameLines`, `employees`, `settings`.
    Aturan: last-write-wins berdasar `updatedAt`, seri → `deviceId`
    penentu; hapus = tombstone `_deleted = 1`, baris tidak pernah dihapus
    fisik sebelum semua device sempat menariknya.

### 3.2 Tabel (26 tabel + 2 tabel sync)

```dart
// Kolom umum di tiap tabel (kecuali syncOutbox, syncState, settings):
//   id TEXT PK (UUID v4), updatedAt INTEGER, deviceId TEXT,
//   isDeleted Dart -> kolom '_deleted' INTEGER 0/1 (hanya tabel MASTER;
//   tabel APPEND tidak memakai _deleted — lihat §3.1)

products       // MASTER
  id, name TEXT, category TEXT, price INT (Rp jual),
  cost INT (Rp, fallback tampilan bila produk tanpa BOM),
  stock INT (pcs barang jadi di rak — BUKAN stok bahan),
  barcode TEXT NULL, isActive INT 0/1
  // Indeks: category, name

customers      // MASTER
  id, name TEXT, phone TEXT NULL, points INT
  // Indeks: name

promos         // MASTER
  id, code TEXT UNIQUE, type TEXT ('persen' | 'potongan'),
  value INT (persen 0-100 | Rp potongan), isActive INT 0/1

sales          // APPEND
  id, code TEXT UNIQUE ('CSZ-YYYYMMDD-0001', dibuat dari counter harian),
  date INT, channel TEXT ('dine-in' | 'takeaway' | 'ojol'),
  paymentMethod TEXT ('tunai' | 'qris' | 'ojol' | 'multi'),
  subtotal INT, discount INT, tax INT, serviceCharge INT, ojolFee INT,
  total INT, paid INT, change INT,
  voided INT 0/1, voidedAt INT NULL,
  shiftId TEXT NULL -> shifts.id, employeeId TEXT -> employees.id,
  customerId TEXT NULL -> customers.id,
  orderId TEXT NULL -> orders.id, splitGroupId TEXT NULL
  // TIDAK ADA kolom hppSnapshot di sales: total HPP = SUM(saleLines.hppPerUnit * qty)
  // (temuan ensemble: satu sumber kebenaran, jangan duplikasi yang bisa inkonsisten)
  // Indeks: date, code, voided, shiftId

saleLines      // APPEND
  id, saleId TEXT -> sales.id, productId TEXT -> products.id,
  qty INT, price INT (snapshot harga jual saat transaksi),
  hppPerUnit INT (snapshot HPP Rp per unit — dibekukan saat penjualan),
  discount INT (Rp diskon baris ini)
  // Indeks: saleId

salePayments   // APPEND — rincian tiap pembayaran dalam satu struk (temuan ensemble)
  id, saleId TEXT -> sales.id, method TEXT ('tunai' | 'qris' | 'ojol'),
  amount INT (Rp), processedAt INT
  // Indeks: saleId. Aturan: SUM(amount) == sales.paid; satu struk boleh
  // punya >1 baris (multi-payment tunai + QRIS). sales.paid/change tetap
  // disimpan sebagai agregat untuk dibaca cepat, sumber kebenaran = baris ini.

ingredients    // MASTER
  id, name TEXT, unit TEXT ('gram' | 'ml' | 'pcs'),
  stockQty REAL (3 desimal; BOLEH NEGATIF — lihat §6),
  avgCostMilli INT (mili-Rupiah per satuan dasar, §4.2),
  totalValue INT (Rp nilai persediaan bahan ini),
  lowStockAt REAL (ambang alert stok menipis)
  // Indeks: name, unit

recipes        // MASTER
  id, productId TEXT UNIQUE -> products.id

recipeLines    // MASTER
  id, recipeId TEXT -> recipes.id, ingredientId TEXT -> ingredients.id,
  qty REAL (3 desimal, kebutuhan per 1 unit produk)
  // Indeks: recipeId. UNIQUE(recipeId, ingredientId).

stockMoves     // APPEND — jejak audit SEMUA mutasi bahan
  id, ingredientId TEXT -> ingredients.id, date INT,
  type TEXT ('stock-in' | 'konsumsi' | 'wastage' | 'opname' | 'void-kembali'),
  qty REAL (bertanda: + masuk, − keluar, 3 desimal),
  unitCostMilli INT (mili-Rp per satuan saat mutasi — snapshot),
  refType TEXT ('sale' | 'stock-in' | 'wastage' | 'opname' | 'void'),
  refId TEXT (id sale / opname / dsb)
  // Indeks: ingredientId, date, refType+refId.
  // Void TIDAK menghapus baris konsumsi lama: void menulis baris baru
  // type 'void-kembali' dengan qty berlawanan, dibaca dari stockMoves
  // sale aslinya (jadi pengembalian memakai qty bahan SAAT penjualan,
  // bukan resep saat ini — temuan ensemble).

accounts       // MASTER — bagan akun §7.1 (PERSIS laporan §3.3), di-seed saat onCreate (bukan seed demo)
  id, code TEXT UNIQUE, name TEXT,
  type TEXT ('Aset' | 'Kewajiban' | 'Ekuitas' | 'Pendapatan' | 'Beban'),
  normal TEXT ('D' | 'K')

journals       // APPEND
  id, date INT, memo TEXT, refType TEXT, refId TEXT,
  reversesJournalId TEXT NULL, isReversal INT 0/1
  // UNIQUE(refType, refId) — idempotensi: satu event = satu jurnal.
  // Jurnal TIDAK PERNAH diedit/dihapus. Salah catat -> jurnal pembalik baru
  // (isReversal=1, reversesJournalId menunjuk jurnal asal).
  // Indeks: date, refType+refId

journalLines   // APPEND
  id, journalId TEXT -> journals.id, accountCode TEXT -> accounts.code,
  debit INT (Rp, >= 0), credit INT (Rp, >= 0)
  // Indeks: journalId, accountCode. Aturan: satu baris tidak boleh
  // debit > 0 DAN credit > 0 sekaligus.

shifts         // MASTER
  id, openedAt INT, closedAt INT NULL, status TEXT ('open' | 'closed'),
  openingFloat INT, expectedCash INT, actualCash INT, cashDiff INT,
  employeeId TEXT -> employees.id
  // Indeks: status, openedAt

pettyCash      // MASTER — kas kecil model imprest (akun 1030, §7.1)
  id, shiftId TEXT NULL -> shifts.id, date INT, amount INT,
  note TEXT, employeeId TEXT -> employees.id

orders         // MASTER — open bill (belum bayar). BEDA dari sales (sudah bayar).
  id, tableId TEXT NULL -> tables.id,
  status TEXT ('open' | 'paid' | 'void'),
  channel TEXT ('dine-in' | 'takeaway' | 'ojol')
  // Indeks: status, tableId

orderLines     // MASTER
  id, orderId TEXT -> orders.id, productId TEXT -> products.id,
  qty INT, price INT (snapshot harga saat dipesan)
  // Split bill = pindahkan orderLines ke order baru; merge = sebaliknya.
  // Indeks: orderId

tables         // MASTER
  id, name TEXT, status TEXT ('kosong' | 'terisi' | 'reserved')

assets         // MASTER — aset tetap
  id, name TEXT, purchaseDate INT, cost INT,
  residualValue INT, usefulLifeMonths INT,
  accumulatedDepreciation INT, lastDepreciationMonth TEXT NULL ('yyyy-MM')
  // Penyusutan garis lurus: (cost - residualValue) / usefulLifeMonths per bulan,
  // bulan terakhir = sisa pembulatan. Idempotensi: jurnal penyusutan memakai
  // refId 'asset:<id>:<yyyy-MM>' (UNIQUE di journals) — tombol "Proses
  // Penyusutan Bulan Ini" (Fase 4) aman ditekan 2x.

expenses       // APPEND — beban / OPEX
  id, date INT, category TEXT, amount INT, accountCode TEXT -> accounts.code,
  note TEXT, employeeId TEXT NULL -> employees.id
  // Indeks: date, accountCode

employees      // MASTER
  id, name TEXT, role TEXT ('owner' | 'manager' | 'kasir'),
  pinHash TEXT (PIN 4-6 digit, di-hash; JANGAN simpan PIN mentah),
  isActive INT 0/1
  // Indeks: role

attendance     // APPEND — absensi PIN (bukan selfie, keputusan no. 2)
  id, employeeId TEXT -> employees.id, date INT,
  clockIn INT NULL, clockOut INT NULL, pinVerified INT 0/1
  // Indeks: employeeId, date. Satu baris per karyawan per hari
  // (UNIQUE(employeeId, date) — clockOut meng-update baris yang sama;
  // ini satu-satunya tabel APPEND yang mengizinkan update barisnya sendiri
  // di hari yang sama, karena clock-in/out adalah satu event harian).

payrolls       // APPEND
  id, employeeId TEXT -> employees.id, period TEXT ('yyyy-MM'),
  baseSalary INT, deductions INT, netPay INT, paidAt INT NULL
  // UNIQUE(employeeId, period). Gaji dibayar -> jurnal D 5130 / K 1000|1010.

stockOpnames   // MASTER — sesi opname (temuan ensemble: tanpa sesi, selisih tak teraudit)
  id, date INT, employeeId TEXT -> employees.id,
  status TEXT ('draft' | 'posted'), note TEXT NULL
  // Hanya status 'posted' yang mem-posting jurnal + stockMoves.
  // Draft boleh diedit; posted final, tidak bisa diubah.

stockOpnameLines // MASTER
  id, opnameId TEXT -> stockOpnames.id, ingredientId TEXT -> ingredients.id,
  systemQty REAL, actualQty REAL, diffQty REAL (actualQty - systemQty, BOLEH NEGATIF)
  // Indeks: opnameId. diffQty negatif (susut) -> D 5200 / K 1100;
  // diffQty positif (surplus) -> D 1100 / K 5200. Angka minus tampil apa adanya.

settings       // key-value (TANPA kolom sync — hanya lokal per device)
  id TEXT PRIMARY KEY (key), value TEXT
  // Key yang dipakai: storeName, capital, demoSeeded ('0'|'1'), migrated ('0'|'1'),
  // ojolFeeGoFood, ojolFeeGrabFood, ojolFeeShopeeFood (persen, default '0' — JANGAN diisi karangan),
  // ppnRate ('11'), ppnEnabled ('0'|'1'), serviceChargeRate ('0'), pb1Rate ('0'),
  // deviceId (id device ini), rentTotal, rentMonths, rentStartMonth ('yyyy-MM')

syncOutbox     // antrean sync (Fase 7; skema disiapkan dari awal, engine belum aktif)
  id TEXT PK (UUID), tableName TEXT, rowId TEXT,
  operation TEXT ('insert' | 'update' | 'delete'),
  payload TEXT (JSON baris lengkap),
  status TEXT ('pending' | 'done' | 'failed'),
  attempts INT, createdAt INT
  // Indeks: status, createdAt (FIFO = ORDER BY createdAt ASC).
  // Operasi 'delete' DILARANG untuk tabel kelas APPEND.

syncState      // watermark pull per tabel (Fase 7)
  id TEXT PK (nama tabel), lastPulledAt INT (epoch ms)
```

### 3.3 Catatan skema yang wajib dipegang Fase 1

1. `products.stock` (pcs barang jadi) dan `ingredients.stockQty` (bahan)
   adalah dua hal berbeda. Penjualan mengurangi `ingredients.stockQty` via
   BOM; `products.stock` hanya berkurang untuk produk TANPA BOM (misal Air
   Mineral) — dan boleh minus juga (keputusan no. 3 berlaku untuk semua stok).
2. `sales.code` dibuat dari counter harian di dalam transaksi penjualan yang
   sama (baca `MAX(code)` hari itu + 1 di dalam `Transaction` — jangan di luar,
   supaya dua kasir tidak dapat nomor sama).
3. `journals` + `journalLines` tidak punya kolom `_deleted`: jurnal tidak
   pernah dihapus. `voided` hanya ada di `sales`; pembatalan akuntansi selalu
   lewat jurnal pembalik.
4. `attendance` adalah pengecualian APPEND yang tercatat di atas — jangan
   jadikan preseden untuk meng-update baris APPEND lain.

## 4. Uang, BOM, dan HPP

### 4.1 Money — integer Rupiah, tanpa float

```dart
// lib/core/money.dart — BEKU
int toIntRp(num n);            // round() — uang selalu integer Rp
double round3(double n);       // kuantitas bahan, 3 desimal
String fmt(int n);             // 'Rp1.500.000' (id_ID, 0 desimal)
String fmtQty(double n);       // '1.500' gram / '250' ml — 3 desimal, trim nol akhir
```

- Semua harga, total, diskon, pajak, HPP, saldo akun: `int` Rupiah.
- Pembulatan: `round()` Dart (half away from zero). Pembulatan HPP dilakukan
  **per baris penjualan** (per `saleLine`), bukan per bahan — supaya total HPP
  struk = jumlah baris yang terlihat, tanpa selisih sen tersembunyi.
- Kuantitas bahan (`stockQty`, `recipeLines.qty`, `stockMoves.qty`): `double`,
  selalu lewat `round3()` saat tulis. Jangan pernah menyimpan `0.30000000000000004`.

### 4.2 Moving average cost — disimpan dalam mili-Rupiah

Temuan ensemble yang **diterapkan**: menyimpan `avgCost` sebagai integer
Rupiah utuh menimbulkan selisih kumulatif (contoh Qwen: avgCost Rp10.500/kg
yang dibulatkan ke Rp10.000/Rp11.000 membuat HPP meleset tiap penjualan dan
laba rugi jadi palsu setelah puluhan transaksi). Aturan beku:

- `ingredients.avgCostMilli` = **integer mili-Rupiah per satuan dasar**
  (1 Rp = 1000 mili). `avgCostMilli = 150000` artinya Rp150/gram.
- `ingredients.totalValue` = integer Rp nilai persediaan bahan itu.
- **Hanya `stockIn` yang mengubah `avgCostMilli`** (dan `totalValue`):
  `avgCostMilliBaru = round((totalValueLama + hargaBeli) * 1000 / (stokLama + qtyBeli))`.
  Konsumsi / wastage / opname **tidak pernah** mengubah `avgCostMilli` —
  mereka hanya mengurangi `stockQty` dan `totalValue` sebesar
  `qty × avgCostMilli / 1000` (dibulatkan ke integer Rp per mutasi).
- HPP satu unit produk (dalam mili-Rp) = `Σ (qtyBahan × avgCostMilliBahan)`.
  `saleLines.hppPerUnit` (integer Rp) = `round(hppMilli / 1000)`.
- Contoh nyata dari laporan (harus cocok): Kopi Susu Gula Aren = 18g kopi
  (Rp150/g) + 120ml susu (Rp18/ml) + 25ml gula aren (Rp60/ml) + 1 cup
  (Rp1.000/pcs) → HPP = 2.700 + 2.160 + 1.500 + 1.000 = **Rp7.360** —
  sama persis dengan laporan §3.3. `avgCostMilli` kopi = 150000, susu = 18000,
  gula aren = 60000, cup = 1000000.
- `avgCost` turunan (untuk tampilan) = `avgCostMilli / 1000`; tampilkan
  maksimal 3 desimal, trim nol akhir (misal "Rp150" atau "Rp18,5").
- **Stok negatif tidak merusak `avgCostMilli`**: karena konsumsi tidak
  menyentuh `avgCostMilli`, HPP tetap valid walau `stockQty` minus (lihat §6).
  `totalValue` boleh ikut negatif apa adanya — jangan di-clamp ke 0.

### 4.3 HPP snapshot

- HPP dihitung **di dalam transaksi penjualan** dari `avgCostMilli` saat itu
  (`Bom.computeHPPInTx`), lalu dibekukan ke `saleLines.hppPerUnit`.
- `Bom.computeHPP` (versi baca-saja, untuk preview di UI) hanya estimasi —
  angka final selalu dihitung ulang di dalam transaksi. Jangan percaya state
  UI untuk angka final (temuan ensemble).
- Produk tanpa BOM (misal Air Mineral) memakai `products.cost` sebagai HPP
  dan mengurangi `products.stock`, bukan bahan.

## 5. Kontrak interface BEKU (Dart signatures)

**Aturan perubahan:** signature di bawah ini TIDAK BOLEH diubah fase berikut
tanpa lapor koordinator. Yang boleh berubah: isi implementasi di dalam fungsi.
Alasan beku: tanpa ini, kerja paralel fase berikut menghasilkan modul yang
tidak nyambung (vonis 2 reviewer ensemble di laporan).

### 5.1 Aturan transaksi (temuan ensemble — diterapkan)

- **Service bisnis memiliki transaksi.** `SaleService`, `StockService`,
  `ExpenseService`, dsb. membuka `db.transaction(() async { ... })` dan
  mengoper objek `Transaction` ke `Ledger`/`Bom` di dalamnya.
- **`Ledger` dan `Bom` TIDAK PERNAH memanggil `db.transaction()` sendiri**
  (kecuali varian `...Standalone` di bawah). SQLite/Drift tidak mentolerir
  transaksi bersarang yang dibuat dari dua tempat berbeda — pola ini yang
  mencegah race condition tulis jurnal + stok (risiko no. 1 Groq Qwen di
  laporan) dan menjamin jurnal + mutasi stok atomik: gagal di satu titik =
  rollback semua.
- `computeHPP` (baca-saja) boleh dipanggil di luar transaksi; semua tulis
  (`deductBOM`, `stockIn`, `logWastage`, `postJournal`) hanya di dalam
  `Transaction`.

```dart
// lib/core/money.dart — lihat §4.1
int toIntRp(num n);
double round3(double n);
String fmt(int n);
String fmtQty(double n);

// lib/core/accounts.dart — BEKU
// Bagan akun standar warkop, PERSIS laporan §3.3 (lihat §7.1).
// Di-seed ke tabel accounts saat onCreate database (bukan lewat seed demo).
class ChartOfAccounts {
  static const List<AccountDef> all = [ /* 29 akun, kode 1000-5220 */ ];
  static AccountDef byCode(String code); // throw jika kode tidak ada
}
class AccountDef {
  const AccountDef(this.code, this.name, this.type, this.normal);
  final String code; final String name;
  final AccountType type; // aset | kewajiban | ekuitas | pendapatan | beban
  final Normal normal;    // debit | kredit
}

// lib/core/ledger.dart — BEKU
class JournalLineInput {
  const JournalLineInput({
    required this.accountCode,
    required this.debit,   // int Rp, >= 0
    required this.credit,  // int Rp, >= 0
  });
  final String accountCode;
  final int debit;
  final int credit;
  // Aturan: satu baris tidak boleh debit > 0 DAN credit > 0 sekaligus.
}

class Ledger {
  // Menulis jurnal ke dalam transaksi yang SUDAH DIBUKA pemanggil.
  // Throw StateError jika total debit != total credit.
  // Throw StateError jika refType+refId sudah punya jurnal (idempotensi).
  // Mengembalikan id jurnal (UUID).
  static Future<String> postJournal(
    Transaction tx, {
    required DateTime date,
    required String memo,
    required String refType,
    required String refId,
    required List<JournalLineInput> lines,
    String? reversesJournalId,
  });

  // Varian untuk event yang HANYA jurnal (OPEX, penyusutan, amortisasi):
  // membuka transaksi sendiri. DILARANG dipakai dari dalam transaksi lain.
  static Future<String> postJournalStandalone(
    AppDatabase db, {
    required DateTime date,
    required String memo,
    required String refType,
    required String refId,
    required List<JournalLineInput> lines,
    String? reversesJournalId,
  });

  // Saldo akun s.d. tanggal upTo (null = semua). Signed int: positif =
  // saldo sesuai posisi normal akun (aset/beban positif = debit;
  // kewajiban/ekuitas/pendapatan positif = kredit).
  static Future<int> getAccountBalance(
    AppDatabase db,
    String accountCode, {
    DateTime? upTo,
  });

  static Future<Map<String, int>> getBalances(
    AppDatabase db, {
    DateTime? upTo,
  });
}

// lib/core/bom.dart — BEKU
class Bom {
  // Estimasi baca-saja untuk UI. BUKAN angka final.
  static Future<int> computeHPP(AppDatabase db, String productId, int qty);

  // HPP final — WAJIB dipanggil di dalam Transaction penjualan.
  static Future<int> computeHPPInTx(Transaction tx, String productId, int qty);

  // Potong bahan per BOM + tulis stockMoves type 'konsumsi'.
  // TIDAK PERNAH throw/reject karena stok kurang — stok BOLEH MINUS (§6).
  // Menulis stockMoves dengan unitCostMilli = avgCostMilli saat itu.
  static Future<void> deductBOM(
    Transaction tx, {
    required String productId,
    required int qty,
    required String saleId,
  });

  // Beli bahan: tambah stokQty, hitung ulang avgCostMilli + totalValue (§4.2),
  // tulis stockMoves type 'stock-in'. Jurnal D 1100 / K 1000 (tunai) atau
  // K 2000 (utang) ditulis PEMANGGIL dalam transaksi yang sama (bukan di sini —
  // satu fungsi satu tanggung jawab; jurnal tetap atomik karena satu Transaction).
  static Future<void> stockIn(
    Transaction tx, {
    required String ingredientId,
    required double qty,
    required int totalCost,
    String? supplier,
    String? refId,
  });

  // Susu tumpah dsb: kurangi stokQty, tulis stockMoves type 'wastage'.
  // Jurnal D 5210 / K 1100 ditulis PEMANGGIL dalam transaksi yang sama.
  static Future<void> logWastage(
    Transaction tx, {
    required String ingredientId,
    required double qty,
    required String reason,
  });
}
```

### 5.2 Kontrak penjualan (service — dibekukan polanya, signature detail milik Fase 1)

Satu penjualan = SATU `db.transaction()` yang berisi, berurutan:
1. Buat `sales` + `saleLines` (HPP per baris via `computeHPPInTx`).
2. Buat `salePayments` (satu baris per metode; `SUM(amount) == paid`).
3. `deductBOM` per produk ber-BOM (atau kurangi `products.stock` bila tanpa BOM).
4. `Ledger.postJournal` (penjualan + HPP — dua jurnal, masing-masing seimbang;
   `refId` = id sale, `refType` = `'sale'` dan `'sale-hpp'`).
5. Tulis `syncOutbox` (satu baris per tabel yang berubah) — di transaksi yang
   sama, supaya outbox tidak pernah ketinggalan dari data.
6. Update poin pelanggan bila ada `customerId`.

Void = transaksi baru yang berisi: flag `sales.voided = 1`, `voidedAt`;
jurnal pembalik (semua baris dibalik, `isReversal = 1`,
`reversesJournalId` = jurnal asal, `refId` = id sale); pengembalian stok
dengan membaca `stockMoves` sale aslinya dan menulis baris
`'void-kembali'` berlawanan (bukan dari resep saat ini). Jurnal asal
TIDAK PERNAH dihapus atau diedit.

### 5.3 Sync engine (kontrak — engine aktif Fase 7, skema + outbox dari awal)

```dart
// lib/core/sync/sync_engine.dart — BEKU (kontraknya; implementasi Fase 7)
class SyncStatus {
  const SyncStatus({required this.pendingCount, required this.lastSyncAt});
  final int pendingCount;      // baris outbox status 'pending' + 'failed'
  final DateTime? lastSyncAt;  // jam sync sukses terakhir (null = belum pernah)
}

abstract class SyncEngine {
  // Kuras outbox FIFO (paling lama dulu). BERHENTI di gagal pertama —
  // urutan itu penting: penjualan tidak boleh sampai ke server sebelum produknya.
  Future<SyncResult> pushPending();

  // Tarik delta per tabel memakai watermark syncState.lastPulledAt.
  // Hanya yang berubah yang diunduh.
  Future<SyncResult> pullDelta();

  // pushPending() lalu pullDelta(). Dipanggil saat: internet kembali,
  // aplikasi dibuka, tiap selesai tulis (debounce ~500 mdtk).
  Future<SyncResult> syncNow();

  Stream<SyncStatus> get statusStream; // untuk badge "N perubahan belum tersinkron"
}

class SyncResult {
  const SyncResult({required this.pushed, required this.pulled, required this.failed});
  final int pushed; final int pulled; final int failed;
}
```

Aturan konflik (laporan §5.2 — beku, detail di §11):
- Event (APPEND): union berdasar UUID, `INSERT OR IGNORE`, tidak ada konflik.
- Stok: turunan dari event, bukan angka yang ditimpa. Dua kasir menjual unit
  terakhir bersamaan → stok jadi minus, pemilik melihat peringatan (§6).
- Master: last-write-wins berdasar `updatedAt`, seri → `deviceId` penentu;
  yang kalah dicatat di log konflik (tabel `syncConflicts` — ditambahkan
  Fase 7, pemilik bisa lihat di back-office).
- Hapus: tombstone `_deleted`, tidak pernah hapus fisik sebelum semua device
  sempat menariknya.

### 5.4 Supabase — dependency ditambah, TIDAK diinisialisasi

- `supabase_flutter` ADA di `pubspec.yaml` (§8.1) supaya skema + outbox
  yang dirancang dari awal memang bisa tersambung di Fase 7 tanpa retrofit.
- **Tidak ada `Supabase.initialize()` di mana pun.** Tidak ada import
  `supabase_flutter` di luar satu file penanda di bawah. Tidak ada koneksi,
  tidak ada auth, tidak ada RLS yang disentuh di Fase 0–6.
- Satu file penanda (bukan placeholder kosong — ini keputusan yang ditulis
  eksplisit, sesuai brief Fase 0):

```dart
// lib/core/sync/supabase_client.dart
// KEPUTUSAN BEKU (laporan §7 no. 3): Supabase dirancang dari awal (skema +
// outbox di §3 dan §11), tetapi TIDAK diaktifkan sebelum versi lokal stabil
// (Fase 7). File ini HANYA penanda — jangan panggil dari mana pun sebelum
// Fase 7. Kalau ada yang memanggilnya, ia throw dengan pesan ini.
class SupabaseClient {
  static Never notYetEnabled() {
    throw StateError(
      'Supabase belum diaktifkan. Aktifasi direncanakan Fase 7 setelah '
      'versi lokal stabil (lihat BLUEPRINT-FLUTTER.md §5.4).',
    );
  }
}
```

### 5.5 Printer — abstraksi ESC/POS (UI dilarang import plugin langsung)

```dart
// lib/core/printer/printer_port.dart — BEKU
class DiscoveredPrinter {
  const DiscoveredPrinter({required this.id, required this.name, required this.kind});
  final String id; final String name;
  final PrinterKind kind; // usb | bluetooth | ble | network
}

enum PrinterStatus { disconnected, connecting, connected, error }

abstract class PrinterPort {
  Future<List<DiscoveredPrinter>> discover();
  Future<void> connect(DiscoveredPrinter printer);
  Future<void> printReceipt(ReceiptModel receipt);       // struk 58/80mm
  Future<void> printKitchenTicket(KitchenTicket ticket); // KDS / printer dapur (Fase 2)
  Future<void> disconnect();
  Stream<PrinterStatus> get statusStream;
}

// lib/core/printer/receipt_model.dart — BEKU (bentuk datanya)
class ReceiptModel {
  const ReceiptModel({
    required this.storeName,
    required this.saleCode,
    required this.date,
    required this.lines,      // (nama, qty, harga, subtotal)
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.serviceCharge,
    required this.total,
    required this.payments,   // (metode, jumlah) — multi-payment tampil semua
    required this.change,
    required this.paperWidth, // PaperWidth.mm58 | PaperWidth.mm80
  });
  // ... field final
}
```

- Implementasi satu-satunya (`EscPosPrinterPort`) memakai
  `unified_esc_pos_printer` dan tinggal di `lib/core/printer/esc_pos_printer.dart`.
- **UI, service kasir, dan fitur lain DILARANG import
  `unified_esc_pos_printer` langsung** — hanya boleh bicara ke `PrinterPort`
  (di-inject via Riverpod). Alasan: ganti printer/plugin tidak merembet ke UI.
- Peringatan jujur (laporan §8 no. 4): printer thermal TIDAK BISA dites penuh
  di VM — klaim "jalan" baru sah setelah struk beneran keluar dari printer
  fisik di HP Dony (Fase 8).

### 5.6 Reports — dihitung dari jurnal + sales, BUKAN angka ketik

```dart
// lib/core/reports.dart — BEKU (signature; rumus di §7.4)
class Reports {
  static Future<ProfitLoss> profitLoss(AppDatabase db, DateTime from, DateTime to);
  static Future<BalanceSheet> balanceSheet(AppDatabase db, DateTime asOf);
  static Future<CashFlow> cashFlow(AppDatabase db, DateTime from, DateTime to);
}
```

## 6. Aturan stok minus — keputusan Dony 15 Nov 2026 (MENGUBAH laporan)

Laporan analisa §7 no. 7 merekomendasikan "blokir penjualan kalau bahan
tidak cukup". **Dony menolak rekomendasi itu.** Aturan yang berlaku mulai
Fase 0 ini:

1. **Penjualan TETAP BOLEH jalan walau stok bahan jadi minus.** Kasir tidak
   boleh kehalang jualan gara-gara stok. Tidak ada dialog blokir, tidak ada
   penolakan transaksi karena stok — di kasir, di stock-in, di opname, di
   mana pun.
2. **`deductBOM` TIDAK BOLEH throw/reject saat stok tidak cukup**
   (lihat §5.1). Tidak ada `InsufficientStockException`, tidak ada guard
   `if (stock < butuh) throw`. Fungsi ini hanya mencatat mutasi dan
   mengurangi stok — hasilnya boleh negatif.
3. **`avgCostMilli` TIDAK berubah saat konsumsi** (hanya `stockIn` yang
   mengubahnya — §4.2). Akibatnya HPP tetap valid walau stok negatif: HPP
   penjualan ke-100 yang membuat stok minus memakai `avgCostMilli` yang sama
   dengan penjualan ke-99. `totalValue` boleh negatif apa adanya.
4. **`stockMoves` tetap mencatat mutasi negatif sebagai jejak audit**
   (qty bertanda minus, type `'konsumsi'`). Void tetap mengembalikan stok
   lewat baris `'void-kembali'` (lihat §5.2) — stok bisa kembali dari minus
   ke positif lewat jalur yang sama.
5. **Stok minus HARUS DITAMPILKAN JELAS di UI** (bukan disembunyikan):
   - Daftar bahan: angka minus **warna merah** + badge **"Stok Minus"**.
   - Menu yang memakai bahan minus: badge "Stok Minus" di kartu menu kasir
     (kasir tetap bisa jual — badge hanya informasi).
   - Command Center: alert stok masuk daftar alert — bahan minus tampil di
     urutan atas, di atas ambang `lowStockAt` biasa.
   - Laporan stok / opname: angka minus tampil **apa adanya**, jangan
     dibulatkan ke 0, jangan disembunyikan, jangan diganti tanda strip.
   - Widget bersama: `StockQtyText(qty, unit)` di `lib/shared/widgets/` —
     satu tempat untuk aturan tampil ini (merah + badge bila `< 0`,
     oranye bila `<= lowStockAt`), dipakai semua layar.
6. **Stok = turunan dari event.** Dua kasir menjual unit terakhir bersamaan
   → stok jadi minus, pemilik melihat peringatan dan menyelesaikan lewat
   stock-in / opname. Tidak pernah ada "timpa diam-diam" yang menghilangkan
   penjualan (aturan sync §11).
7. **Konsekuensi yang diterima Dony (dicatat jujur):** stok minus berarti
   persediaan tercatat negatif di Neraca (akun 1100 bisa minus) sampai
   stock-in/opname dilakukan; HPP tetap dihitung dari `avgCostMilli` terakhir
   (bukan dari harga beli yang belum ada). Ini trade-off yang Dony pilih
   demi kasir tidak pernah kehalang.

## 7. REA Ledger — bagan akun + aturan posting (PERSIS laporan §3.3)

### 7.1 Bagan akun standar warkop (kode — nama — tipe — posisi normal)

Di-seed ke tabel `accounts` saat `onCreate` database. 29 akun, tidak boleh
dikurangi di v1; penambahan akun baru hanya lewat migrasi Drift + persetujuan
koordinator.

| Kode | Nama | Tipe | Normal |
|---|---|---|---|
| 1000 | Kas Tunai / Laci | Aset | D |
| 1010 | Bank | Aset | D |
| 1020 | QRIS / E-Wallet | Aset | D |
| 1030 | Kas Petty | Aset | D |
| 1100 | Persediaan Bahan Baku | Aset | D |
| 1200 | Sewa Dibayar di Muka | Aset | D |
| 1300 | Aset Tetap | Aset | D |
| 1310 | Akum. Penyusutan | Aset | K |
| 2000 | Utang Usaha | Kewajiban | K |
| 2100 | Utang Pajak | Kewajiban | K |
| 3000 | Modal Disetor | Ekuitas | K |
| 3100 | Laba Ditahan | Ekuitas | K |
| 4000 | Pendapatan Penjualan | Pendapatan | K |
| 4100 | Diskon Penjualan | Pendapatan | D |
| 4200 | Komisi Ojol | Beban | D |
| 5000 | HPP | Beban | D |
| 5100 | Beban Listrik | Beban | D |
| 5110 | Beban Air | Beban | D |
| 5120 | Beban Internet | Beban | D |
| 5130 | Beban Gaji | Beban | D |
| 5140 | Beban Sewa | Beban | D |
| 5150 | Beban Kebersihan | Beban | D |
| 5160 | Beban Marketing | Beban | D |
| 5170 | Beban Lain-lain | Beban | D |
| 5180 | Beban Penyusutan | Beban | D |
| 5190 | Beban Sewa Diamortisasi | Beban | D |
| 5200 | Selisih Stok | Beban | D |
| 5210 | Beban Wastage | Beban | D |
| 5220 | Selisih Kas | Beban | D |

Catatan atas dua akun yang ditanyakan reviewer ensemble (keputusan: **tetap
pakai bagan laporan** — lihat §12.2 alasan penolakan):
- **1030 Kas Petty tetap ada.** Modelnya imprest: isi petty dari laci
  (D 1030 / K 1000), belanja kecil dari petty (D 51xx / K 1030). Saldo 1030
  = sisa uang petty di tangan. Petty cash bukan beban saat diambil — baru
  jadi beban saat dibelanjakan. Tabel `pettyCash` mencatat tiap pengambilan
  dan pemakaian.
- **1020 QRIS / E-Wallet adalah akun kliring untuk ojol + QRIS.** Penjualan
  ojol dicatat netto ke 1020 (lihat §7.3); saat settlement masuk bank:
  D 1010 / K 1020 sebesar dana yang diterima. Saldo 1020 harus 0 setelah
  settlement — sisa saldo 1020 yang menumpuk adalah sinyal settlement
  belum dicatat, dan tampil di laporan rekonsiliasi (Fase 4).

### 7.2 Aturan posting per event (semua via `Ledger.postJournal`, seimbang)

| Event | Jurnal |
|---|---|
| Penjualan tunai | D 1000 Kas / K 4000 Pendapatan (total kotor); D 4100 Diskon / K 1000 (jika ada); D 5000 HPP / K 1100 Persediaan (HPP BOM); pajak 11% jika aktif: D 1000 / K 2100 Utang Pajak |
| Penjualan QRIS / E-Wallet | D 1020 / K 4000 (dst sama) |
| Penjualan ojol (GoFood/dll) | D 1020 (netto diterima) + D 4200 Komisi Ojol / K 4000 (kotor) |
| Settlement ojol masuk bank | D 1010 Bank / K 1020 QRIS-E-Wallet (sebesar dana diterima) |
| Multi-payment (tunai + QRIS satu struk) | D 1000 (porsi tunai) + D 1020 (porsi QRIS) / K 4000 (kotor); diskon & HPP seperti biasa; rincian per metode tersimpan di `salePayments` |
| Stock-in (belanja, tunai) | D 1100 Persediaan / K 1000 Kas |
| Stock-in (utang supplier) | D 1100 / K 2000 Utang Usaha |
| Bayar utang supplier | D 2000 / K 1000 (tunai) atau K 1010 (bank) |
| Wastage | D 5210 Beban Wastage / K 1100 |
| Opname selisih (susut) | D 5200 Selisih Stok / K 1100 |
| Opname selisih (surplus) | D 1100 / K 5200 |
| Beban OPEX | D 51xx / K 1000 (tunai) atau K 1010 (bank) |
| Gaji / payroll | D 5130 Beban Gaji / K 1000 atau 1010 |
| Penyusutan bulanan | D 5180 / K 1310 Akum. Penyusutan (garis lurus: (biaya − residu) / masa manfaat bln; bulan terakhir sisa pembulatan) |
| Amortisasi sewa bulanan | D 5190 / K 1200 Sewa Dibayar di Muka (sewa total / 12) |
| Modal awal disetor | D 1000/1010/1100/1200/1300 (sesuai bentuk) / K 3000 Modal Disetor |
| Saldo awal migrasi (produk & stok lama) | D 1100 Persediaan (nilai Σ cost × stok) / K 3100 Laba Ditahan |
| Opening float shift (bank → laci) | D 1000 / K 1010 |
| Isi petty cash (laci → petty) | D 1030 / K 1000 |
| Belanja dari petty cash | D 51xx / K 1030 |
| Tutup shift, selisih kas kurang | D 5220 / K 1000 |
| Tutup shift, selisih kas lebih | D 1000 / K 5220 |
| Void penjualan | Jurnal pembalik (semua baris dibalik) + kembalikan stok BOM via `stockMoves` `'void-kembali'` |

### 7.3 Contoh jurnal nyata (angka dari seed demo §10 — sama dengan laporan §3.3)

- **Modal awal Rp60jt** (Bank 17jt, sewa 1 thn 30jt, aset 10jt, bahan 3jt):
  D 1010 Bank 17.000.000 · D 1200 Sewa Muka 30.000.000 · D 1300 Aset 10.000.000 ·
  D 1100 Persediaan 3.000.000 / K 3000 Modal Disetor 60.000.000
- **Jual 2× Kopi Susu Gula Aren @Rp18.000 tunai** (HPP @Rp7.360 dari BOM):
  D 1000 Kas 36.000 / K 4000 Pendapatan 36.000 ·
  D 5000 HPP 14.720 / K 1100 Persediaan 14.720 ·
  (Stok ikut terpotong: kopi −36g, susu −240ml, gula aren −50ml, cup −2pcs)
- **Belanja 1.000g kopi Rp150.000 tunai:**
  D 1100 Persediaan 150.000 / K 1000 Kas 150.000
- **Wastage — susu tumpah 100ml** (@Rp18/ml = Rp1.800):
  D 5210 Beban Wastage 1.800 / K 1100 Persediaan 1.800
- **Opname — susut 50g kopi** (@Rp150/g = Rp7.500):
  D 5200 Selisih Stok 7.500 / K 1100 Persediaan 7.500
- **Penyusutan aset Rp10jt / 60 bulan = Rp166.667/bulan** (bulan terakhir sisa pembulatan):
  D 5180 Beban Penyusutan 166.667 / K 1310 Akum. Penyusutan 166.667
- **Amortisasi sewa Rp30jt / 12 bulan = Rp2.500.000/bulan:**
  D 5190 Beban Sewa Diamortisasi 2.500.000 / K 1200 Sewa Muka 2.500.000
- **Penjualan ojol** (kotor 20.000, komisi 4.000, diterima 16.000):
  D 1020 QRIS/E-Wallet 16.000 · D 4200 Komisi Ojol 4.000 / K 4000 Pendapatan 20.000
- **Void penjualan:** jurnal pembalik (semua baris dibalik) + stok BOM dikembalikan.

### 7.4 Laporan — dihitung dari jurnal (bukan angka ketik)

- **Laba Rugi:** Pendapatan Kotor − Diskon − Komisi Ojol = Pendapatan Bersih
  − HPP = Laba Kotor − (OPEX + Penyusutan + Amortisasi Sewa + Selisih Stok +
  Wastage) = Laba Bersih (+ margin %).
- **Neraca:** Aktiva (Kas + Bank + QRIS + Petty + Persediaan + Sewa Muka +
  Nilai Buku Aset 1300−1310) HARUS = Kewajiban (2000+2100) + Ekuitas
  (3000 + 3100 + Laba Tahun Berjalan). Selisih harus **0** — ditampilkan di
  layar. (Pengecualian yang dicatat jujur: stok minus yang belum diselesaikan
  bisa membuat akun 1100 negatif — itu data benar, bukan bug; lihat §6.7.
  Neraca tetap harus balance: selisih 0 adalah syarat lolos, berapa pun
  nilai 1100-nya.)
- **Arus Kas:** Operasi / Investasi (beli aset) / Pendanaan (modal, prive)
  dari mutasi akun kas (1000+1010+1020+1030).
- Filter: Hari Ini / Bulan Ini / Tahun Ini / Custom. Export CSV + print PDF.

## 8. Package, struktur folder, navigasi, desain

### 8.1 Package (versi ter-resolve di `pubspec.lock`, 15 Nov 2026 — JANGAN karang versi)

**PENTING — kenapa bukan versi terbaru pub.dev:** SDK yang dipakai adalah
Flutter 3.35.7 / Dart 3.9.2. Versi terbaru beberapa package butuh Dart
≥3.10/3.11/3.12 dan GAGAL `pub get` di SDK ini (diverifikasi 15 Nov 2026,
tiga kali gagal sebelum resolve): `drift` 2.35.4, `drift_flutter` 0.3.x
(dependensi `sqlite3_flutter_libs ^0.6.0+eol` butuh Dart ≥3.10; `drift`
2.32.1 juga bentrok `sqlite3 ^3` dengan `drift_flutter` 0.2.8 yang butuh
`sqlite3 ^2`), `flutter_riverpod` 3.5.0 (butuh Dart ^3.12), `printing`
5.15.1 (butuh Dart ≥3.12), `share_plus` 13.3.1 / `file_picker` 13.3.3 /
`path_provider` 2.1.6 / `csv` 8.0.0 (butuh Dart ≥3.10). Yang dipakai di
bawah adalah **versi terbaru yang kompatibel dengan Dart 3.9.2 dan berhasil
`pub get`**. Catatan khusus: `flutter_riverpod` dipin ke **2.6.1**, bukan
3.x — `riverpod` 3.x bergantung pada package `test`, dan di Dart 3.9.2
terjadi deadlock resolver: `test` yang cocok dengan `flutter_test`
(`test_api` 0.7.6, hanya di `test` ≤1.26.2) mensyaratkan `analyzer` <8,
sementara `drift_dev` ≥2.31 mensyaratkan `analyzer` ≥8.1; `test` ≥1.27 yang
mendukung `analyzer` ≥8 butuh `test_api` ≥0.7.8 yang ditolak `flutter_test`.
`riverpod` 2.6.1 tidak bergantung pada `test`, sehingga resolver lolos.
**Jalur upgrade:** saat SDK naik ke Flutter ≥3.50 (Dart ≥3.10), naikkan
kembali ke versi terbaru (`drift` 2.35.x, `flutter_riverpod` 3.x, dst.) dan
jalankan `flutter pub upgrade` + `flutter analyze` — jangan upgrade
setengah-setengah.

| Package | Versi | Alasan |
|---|---|---|
| `drift` | `^2.31.0` (resolve 2.31.0) | Database lokal type-safe (SQLite). Sumber kebenaran offline-first. |
| `drift_flutter` | `^0.2.8` (resolve 0.2.8) | Setup Drift di Flutter (membuka DB, `path_provider`, sqlite3). Dipakai sebagai pengganti dependensi langsung ke `sqlite3_flutter_libs` — paket itu rilis terakhirnya `0.6.0+eol` (penanda end-of-life) dan ditarik transitif oleh `drift_flutter`, jadi jangan depend langsung. (Versi 0.3.x tidak bisa dipakai di Dart 3.9.2 — lihat catatan di atas.) |
| `drift_dev` (dev) | `^2.31.0` (resolve 2.31.0) | Codegen Drift (`build_runner`). |
| `build_runner` (dev) | `^2.14.1` (resolve 2.15.1) | Menjalankan codegen Drift. |
| `flutter_riverpod` | `^2.6.1` (resolve 2.6.1) | State management. Provider untuk DB, repository, `PrinterPort`, `SyncEngine`, tema, dan state kasir. Dipilih atas `provider`/`bloc` karena API-nya paling kecil untuk tim ini dan `StreamProvider` nyambung langsung ke Drift `watch()`. Dipin ke 2.6.1 karena deadlock resolver `riverpod` 3.x di Dart 3.9.2 — lihat catatan di atas. |
| `fl_chart` | `^1.3.1` (resolve 1.3.1) | Chart Command Center (omzet 7 hari, jam sibuk, matriks menu). |
| `intl` | `^0.20.3` (resolve 0.20.3) | Format Rp + tanggal `id_ID`. |
| `uuid` | `^4.6.0` (resolve 4.6.0) | UUID v4 untuk semua `id` (dibuat di device — syarat sync §11). |
| `path_provider` | `^2.1.5` (resolve 2.1.5) | Lokasi file DB + file backup (dipakai `drift_flutter` dan export). |
| `share_plus` | `^12.0.2` (resolve 12.0.2) | Share struk / file backup / CSV ke WA / Drive. |
| `file_picker` | `^11.0.3` (resolve 11.0.3) | Pilih file `casirz-export-v1.json` saat migrasi (§9) + pilih file backup saat restore. |
| `csv` | `^6.0.0` (resolve 6.0.0) | Export laporan ke CSV. |
| `printing` | `^5.14.3` (resolve 5.14.3) | Print PDF laporan (dan struk bila perlu). |
| `unified_esc_pos_printer` | `^3.4.0` | Printer thermal ESC/POS: USB, Bluetooth Classic, BLE, network — satu API `PrinterManager`. Dipakai HANYA di `lib/core/printer/esc_pos_printer.dart` (§5.5). |
| `supabase_flutter` | `^2.18.3` | **Ditambah sebagai dependency, TIDAK diinisialisasi/diaktifkan** (§5.4). Target sync Fase 7. |
| `flutter_lints` (dev) | `^6.0.0` | Lint bawaan template Flutter. |

Yang **sengaja TIDAK dipakai**: `google_fonts` (dilarang — build VM gagal
fetch; font sistem saja), `sqflite` mentah (Drift di atasnya), paket printer
lain yang terfragmentasi, dan paket state management kedua (satu saja:
Riverpod).

### 8.2 Struktur folder `lib/`

```text
lib/
  main.dart                  // wiring: DB, Riverpod scope, tema, router awal
  core/
    money.dart               // fmt, toIntRp, round3, fmtQty (§4.1) — BEKU
    accounts.dart            // ChartOfAccounts, 29 akun (§7.1) — BEKU
    ledger.dart              // Ledger.postJournal dkk (§5.1) — BEKU
    bom.dart                 // Bom.computeHPP/deductBOM/stockIn/logWastage (§5.1) — BEKU
    reports.dart             // Reports.profitLoss/balanceSheet/cashFlow (§5.6)
    errors.dart              // exception domain (mis. JurnalTidakSeimbang)
    db/
      database.dart          // AppDatabase (Drift), schemaVersion = 1, onCreate seed akun
      tables.dart            // definisi 26 tabel (§3.2)
      daos.dart              // DAO per agregat (boleh dipecah per file di Fase 1)
    seed/
      seed_demo.dart         // SeedDemoWarkop: reset & isi ulang (§10)
      seed_data.dart         // angka seed: bahan, menu, BOM, aset, transaksi (§10)
    sync/
      sync_engine.dart       // kontrak SyncEngine + SyncStatus (§5.3) — BEKU kontraknya
      outbox.dart            // tulis/baca syncOutbox (dipakai semua service)
      supabase_client.dart   // PENANDA belum aktif (§5.4) — JANGAN dipakai s.d. Fase 7
    printer/
      printer_port.dart      // abstraksi PrinterPort + ReceiptModel (§5.5) — BEKU
      receipt_model.dart     // model struk
      esc_pos_printer.dart   // satu-satunya file yang import unified_esc_pos_printer
    migration/
      casirz_export_v1.dart  // parser + validator format export web v2 (§9)
      migrate.dart           // import sekali jalan + saldo awal (§9)
  features/
    pos/                     // Fase 2: kasir, meja, open bill, split/merge, shift, struk
    inventory/               // Fase 3: bahan, BOM, stock-in, wastage, opname
    accounting/              // Fase 4: modal, aset, OPEX, laporan, jurnal view
    staff/                   // Fase 5: RBAC + PIN, absensi PIN, payroll
    dashboard/               // Fase 6: Command Center + BEP tracker
  shared/
    theme/
      app_theme.dart         // ThemeData terang/gelap, aksen emerald (§8.4)
    widgets/
      money_text.dart        // MoneyText (tabular-nums, format Rp)
      stock_qty_text.dart    // StockQtyText: merah + badge "Stok Minus" bila < 0 (§6.5)
      empty_state.dart
      confirm_dialog.dart
```

Aturan: `features/` tidak boleh import `drift` langsung untuk tulis —
tulis lewat service di `core/` + DAO; `features/` tidak boleh import plugin
printer langsung (§5.5). `core/` tidak boleh import `features/`.

### 8.3 Navigasi

- **Mobile portrait:** bottom nav ≤5 item + **"Lainnya"**:
  `Kasir` · `Bahan` · `Laporan` · `Staf` · `Lainnya`
  (Lainnya membuka sheet: Dashboard/Command Center, Akuntansi, Meja,
  Pengaturan, Demo/Seed, Backup & Sync).
- **Tablet landscape / layar lebar:** sidebar kiri (seperti web v2) dengan
  semua menu: Dashboard, Kasir, Meja, Bahan Baku, Akuntansi, Laporan
  Keuangan, Staf, Pengaturan.
- Navigasi berbasis `StatefulWidget` + `IndexedStack` di Fase 0–2 (tanpa
  paket router tambahan — rute dalam aplikasi kasir tidak butuh deep link);
  bila Fase 6 butuh deep link, keputusan router diambil saat itu, bukan
  sekarang.
- Status sync terlihat jelas di semua layar (app bar): badge
  "N perubahan belum tersinkron" + jam sync terakhir (dari
  `SyncEngine.statusStream`; sebelum Fase 7 nilainya selalu "Belum pernah
  tersinkron — sync aktif Fase 7", tampil jujur, bukan angka palsu).

### 8.4 Desain visual (selaras web v2 — emerald, font sistem)

- **Satu aksen: emerald** (seperti web v2: `emerald-600`, sidebar gelap).
  Latar terang default; **dark/light toggle** di Pengaturan (disimpan di
  `settings`, diterapkan lewat Riverpod `themeProvider`).
- **Font sistem** (`Typography` bawaan Flutter — `defaultFontFamily` tidak
  diisi; JANGAN `google_fonts`). Angka uang memakai `tabular-nums` — di
  Flutter: `TextStyle(fontFeatures: [FontFeature.tabularFigures()])`
  (wajib di `MoneyText` dan semua tabel angka).
- **Touch target POS ≥ 44px** (kartu menu besar, tombol kasir
  `minHeight 48`). Kontras tinggi; NO gradient ungu/biru, NO emoji sebagai
  ikon, NO 3 kartu identik berderet tanpa variasi.
- **Stok minus: merah + badge** (aturan §6.5 — satu widget `StockQtyText`,
  satu sumber kebenaran visual).
- Struk thermal: lebar 58mm/80mm, font mono (`FontFeature` monospace
  sistem), model `ReceiptModel.paperWidth` (§5.5).

## 9. Migrasi localStorage `"casirz"` (web) → Drift

Laporan §3.6 mensyaratkan migrasi sekali jalan. Karena Flutter tidak bisa
membaca `localStorage` browser, migrasinya lewat **file export JSON dari
web v2** — formatnya dirancang di sini supaya kedua sisi cocok.

### 9.1 Format export — `casirz-export-v1.json` (dirancang di sini, dibuat di web v2)

```json
{
  "format": "casirz-export-v1",
  "exportedAt": "2026-11-15T08:00:00Z",
  "storeName": "Casirz",
  "products": [
    {"id": "uuid-atau-id-lama", "name": "Kopi Susu Gula Aren",
     "category": "Minuman", "price": 18000, "cost": 9000, "stock": 50}
  ],
  "customers": [{"id": "...", "name": "...", "phone": "...", "points": 0}],
  "promos": [{"id": "...", "code": "HEMAT10", "type": "persen", "value": 10}],
  "sales": [
    {"id": "...", "code": "CSZ-20261114-0001", "date": 1763078400000,
     "total": 36000, "paymentMethod": "tunai",
     "items": [{"productId": "...", "qty": 2, "price": 18000}]}
  ],
  "employees": [{"id": "...", "name": "...", "role": "kasir"}]
}
```

Aturan import (di `lib/core/migration/`):
1. **Validasi dulu, tulis belakangan.** Format harus `casirz-export-v1`;
   angka uang dibulatkan ke integer Rp; stok kosong → 0; struktur rusak /
   tipe salah → **migrasi dibatalkan + pesan error, bukan data setengah**.
2. **Sekali jalan, dalam satu transaksi Drift.** Kalau database baru kosong
   DAN file dipilih → import. Flag `settings.migrated = '1'` ditulis
   **setelah** import berhasil commit — bukan sebelumnya (kalau HP mati di
   tengah import, migrasi bisa diulang).
3. **Produk & stok lama masuk sebagai saldo awal:** D 1100 Persediaan
   (nilai Σ cost × stok) / K 3100 Laba Ditahan — satu jurnal `refType:
   'migrasi-saldo-awal'`.
4. **Penjualan historis lama TIDAK dijurnal ulang** (dianggap data mentah,
   tidak masuk Laba Rugi baru). Disimpan ke `sales` + `saleLines` dengan
   `hppPerUnit = products.cost` saat itu dan flag tersendiri? Tidak — tanpa
   jurnal, penjualan tanpa jurnal melanggar prinsip §1.3. Keputusan beku:
   penjualan historis disimpan ke tabel `sales`/`saleLines` **tanpa jurnal
   dan tanpa pengurangan stok bahan** (produk lama belum punya BOM), dan
   **tidak dihitung** di Laba Rugi / Neraca (laporan memfilter jurnal, bukan
   sales mentah — kecuali daftar "Transaksi" yang menampilkannya dengan label
   "Data lama (migrasi)"). Ini satu-satunya pengecualian prinsip §1.3, dan
   dicatat di sini supaya tidak jadi preseden.
5. **Karyawan lama diimport tanpa PIN** (`pinHash` kosong) — pemilik wajib
   atur PIN tiap karyawan di layar Staf sebelum karyawan itu bisa absen.
   Jangan pernah mengarang PIN default.
6. Pilih file lewat `file_picker` (`.json` saja). Setelah import sukses,
   tampilkan ringkasan: jumlah produk / pelanggan / transaksi yang masuk +
   nilai saldo awal.

### 9.2 Catatan jujur (bukan placeholder — batas yang diketahui)

- **Fungsi export di web v2 BELUM ADA.** Format di §9.1 adalah spesifikasi
  yang harus dibuat di repo web (tombol export di Pengaturan web v2) sebelum
  migrasi bisa jalan penuh end-to-end. Sisi Flutter (parser + validator +
  UI import) disiapkan di Fase 1 sesuai format ini. Jangan klaim migrasi
  "sudah bisa dites" sebelum export web-nya ada.
- Kalau pengguna baru (tidak ada data web lama), migrasi dilewati dan
  aplikasi langsung menawarkan seed demo (§10) atau mulai kosong.

## 10. Seed demo "Warkop Kekinian Preset" Rp60jt (PERSIS laporan §3.5)

Tombol **"Isi Data Demo Warkop"** di Pengaturan. Model **reset & isi ulang**
(idempotent — ditekan 2× tidak duplikat; kalau data sudah ada, minta
konfirmasi dulu, lalu hapus semua data transaksi + master demo dan isi ulang
dari nol). Seed **bukan** rencana bisnis Warkop Hits Dony (investor: modal
Rp50jt, sewa Rp24jt) — sengaja dibedakan, dan layar seed menulis itu.

Seed WAJIB lewat jalur transaksi yang sama dengan transaksi asli
(`SaleService` + `postJournal` + `deductBOM` dalam satu `Transaction`) —
bukan insert mentah ke tabel — supaya jurnal seimbang dan stok konsisten
sejak detik pertama.

### 10.1 Modal Rp60.000.000 (jurnal modal awal — sama dengan laporan §3.3)

D 1010 Bank 17.000.000 · D 1200 Sewa Muka 30.000.000 ·
D 1300 Aset 10.000.000 · D 1100 Persediaan 3.000.000 /
K 3000 Modal Disetor 60.000.000

- Sewa: Rp30.000.000 / 12 bulan → amortisasi Rp2.500.000/bulan
  (`settings.rentTotal = 30000000`, `rentMonths = 12`).
- Aset Rp10.000.000 (semua masa manfaat 60 bulan, residu 0):

| Aset | Biaya | Penyusutan/bulan |
|---|---|---|
| Mesin Kopi | Rp5.000.000 | Rp83.333 |
| Kulkas Showcase | Rp2.500.000 | Rp41.667 |
| Kompor & Peralatan Dapur | Rp1.500.000 | Rp25.000 |
| Meja Kursi | Rp1.000.000 | Rp16.667 |
| **Total** | **Rp10.000.000** | **Rp166.667** |

### 10.2 OPEX bulanan (parameter, bukan transaksi — dicatat saat benar dibayar)

Listrik Rp1.000.000 · Air Rp200.000 · Internet Rp500.000 ·
Gaji 2 staf @Rp1.500.000. Disimpan sebagai `expenses` berulang? Tidak —
disimpan sebagai nilai default di layar Beban + `employees.baseSalary`.
Karyawan seed: 1 Owner (PIN diatur saat seed? Tidak — PIN tidak boleh
dikarang; owner mengatur PIN-nya di layar Staf setelah seed) + 2 Kasir
(@Rp1.500.000/bulan).

### 10.3 Bahan baku — 11 bahan (nilai total TEPAT Rp3.000.000)

`avgCostMilli` = harga per satuan × 1000. Jumlah = stok awal × harga:

| Bahan | Satuan | Stok awal | Harga/satuan | Nilai |
|---|---|---|---|---|
| Biji Kopi House Blend | gram | 4.000 | Rp150 | Rp600.000 |
| Susu UHT Full Cream | ml | 15.000 | Rp18 | Rp270.000 |
| Gula Aren Cair | ml | 5.000 | Rp60 | Rp300.000 |
| Teh Tubruk | gram | 2.000 | Rp120 | Rp240.000 |
| Susu Kental Manis | ml | 5.000 | Rp30 | Rp150.000 |
| Indomie Goreng | pcs | 120 | Rp3.000 | Rp360.000 |
| Telur Ayam | pcs | 200 | Rp2.000 | Rp400.000 |
| Roti Tawar | pcs | 150 | Rp1.000 | Rp150.000 |
| Cokelat Meses | gram | 1.500 | Rp100 | Rp150.000 |
| Cup 16oz | pcs | 300 | Rp1.000 | Rp300.000 |
| Sedotan | pcs | 800 | Rp100 | Rp80.000 |
| **Total** | | | | **Rp3.000.000** |

### 10.4 Menu — 10 menu + BOM (HPP dihitung dari §10.3, bukan angka ketik)

| Menu | Harga | BOM (per 1 porsi) | HPP |
|---|---|---|---|
| Kopi Susu Gula Aren | Rp18.000 | 18g kopi + 120ml susu + 25ml gula aren + 1 cup | Rp7.360 |
| Es Kopi Hitam | Rp12.000 | 18g kopi + 1 cup + 1 sedotan | Rp3.800 |
| Es Teh Tubruk | Rp8.000 | 10g teh + 15ml gula aren + 1 cup + 1 sedotan | Rp3.200 |
| Susu Cokelat Meses | Rp15.000 | 150ml susu + 20g meses + 1 cup + 1 sedotan | Rp5.800 |
| Roti Bakar Meses | Rp15.000 | 2 roti + 15g meses + 10ml SKM | Rp3.800 |
| Indomie Goreng Telur | Rp18.000 | 1 Indomie + 1 telur | Rp5.000 |
| Indomie Goreng Spesial | Rp22.000 | 1 Indomie + 2 telur | Rp7.000 |
| Es Kopi Susu SKM | Rp15.000 | 18g kopi + 100ml susu + 20ml SKM + 1 cup + 1 sedotan | Rp6.200 |
| Teh Susu Gula Aren | Rp12.000 | 10g teh + 100ml susu + 20ml gula aren + 1 cup + 1 sedotan | Rp5.300 |
| Air Mineral | Rp5.000 | Tanpa BOM — pakai `products.cost` Rp2.500, kurangi `products.stock` | Rp2.500 |

Catatan: Matcha Latte dan Kentang Goreng dari web v2 **tidak masuk seed**
karena bubuk matcha dan kentang tidak ada di daftar 11 bahan laporan —
menambahkan menu tanpa bahannya akan merusak HPP BOM. Menu itu bisa
ditambah nanti bersama bahannya.

### 10.5 Transaksi historis — 15 transaksi, 7 hari terakhir

Dibuat lewat jalur penjualan normal (jurnal + BOM + `salePayments`
lengkap). Tarif komisi ojol seed = **0** (Dony belum mengisi angka —
jangan dikarang; jurnal ojol seed berarti D 1020 / K 4000 sebesar kotor).
Distribusi tetap (bukan acak — hasil seed harus sama setiap kali):

| Hari | Transaksi | Isi | Total |
|---|---|---|---|
| −7 | T1 | 2× Kopi Susu Gula Aren — tunai, dine-in | Rp36.000 |
| −7 | T2 | 1× Indomie Telur + 1× Es Teh — QRIS, takeaway | Rp26.000 |
| −6 | T3 | 3× Es Kopi Hitam — tunai, dine-in | Rp36.000 |
| −6 | T4 | 1× Roti Bakar Meses + 2× Kopi Susu — tunai, dine-in | Rp51.000 |
| −5 | T5 | 2× Indomie Spesial — ojol | Rp44.000 |
| −5 | T6 | 1× Susu Cokelat + 1× Es Teh — QRIS, dine-in | Rp23.000 |
| −4 | T7 | 1× Kopi Susu + 1× Air Mineral — tunai, takeaway | Rp23.000 |
| −4 | T8 | 2× Teh Susu Gula Aren — tunai, dine-in | Rp24.000 |
| −4 | T9 | 1× Indomie Telur + 1× Es Kopi Susu SKM — ojol | Rp33.000 |
| −3 | T10 | 4× Kopi Susu — QRIS, dine-in | Rp72.000 |
| −3 | T11 | 1× Roti Bakar + 1× Es Kopi Hitam — tunai, takeaway | Rp27.000 |
| −2 | T12 | 2× Susu Cokelat + 1× Indomie Spesial — tunai, dine-in | Rp52.000 |
| −2 | T13 | 3× Es Teh + 2× Air Mineral — ojol | Rp34.000 |
| −1 | T14 | 2× Kopi Susu + 1× Indomie Telur — QRIS, dine-in | Rp54.000 |
| −1 | T15 | 1× Teh Susu + 1× Roti Bakar + 1× Es Kopi Hitam — tunai, dine-in | Rp39.000 |

**Total omzet seed: Rp574.000. Total HPP seed: Rp210.360. Laba kotor
seed: Rp363.640** (sebelum OPEX/penyusutan/amortisasi — yang dicatat saat
benar dibayar/diproses bulanan, Fase 4). Angka ini adalah oracle untuk tes
Fase 1: setelah seed, Laba Rugi 7 hari terakhir HARUS menunjukkan angka
ini, dan Neraca HARUS selisih 0.

## 11. Sinkronisasi offline-first (rancang dari awal — aktif Fase 7)

Pola laporan §5 — diulang di sini sebagai spesifikasi beku untuk Fase 7:

1. **UI tidak pernah bicara ke jaringan.** UI hanya baca/tulis Drift.
   Yang bicara ke Supabase cuma `SyncEngine`.
2. **Tulis lokal dulu, selalu.** Setiap transaksi tulis lokal + dalam SATU
   transaksi Drift yang sama, tulis satu baris ke `syncOutbox` (operasi,
   tabel, id baris, payload JSON, status, percobaan).
3. **Kirim saat online.** Jalan saat: internet kembali, aplikasi dibuka,
   tiap selesai tulis (debounce ~500 mdtk). Outbox dikuras **FIFO**,
   berhenti di gagal pertama.
4. **Tarik perubahan.** Setelah outbox kosong, tarik delta per tabel memakai
   watermark `syncState.lastPulledAt` — hanya yang berubah yang diunduh
   (hemat kuota; Supabase free tier 500 MB DB, 5 GB egress/bulan — cukup
   untuk satu warkop kalau pakai delta + batch).
5. **ID dari device.** Semua baris baru pakai UUID v4 dari HP — push bisa
   diulang dengan aman tanpa duplikat.
6. **Konflik** — lihat §5.3: APPEND = union UUID (`INSERT OR IGNORE`,
   tidak pernah UPDATE/DELETE, outbox melarang operasi `delete` untuk
   tabel APPEND); stok = turunan event (boleh minus, pemilik menyelesaikan
   — §6.6); MASTER = last-write-wins (`updatedAt`, seri → `deviceId`),
   yang kalah dicatat di log konflik yang bisa dilihat pemilik di
   back-office; hapus = tombstone `_deleted`.
7. **Yang WAJIB jalan offline:** jual penuh, potong stok via BOM, hitung
   HPP, laci kas & shift, cetak struk, opname, wastage, stock-in, beban,
   absensi + payroll, semua laporan dari data lokal.
   **Boleh butuh online:** sinkronisasi & backup otomatis, dashboard
   pemilik jarak jauh, integrasi ojol/marketplace, kirim laporan via email,
   restore di HP baru, update aplikasi.
8. **Keamanan data (anti-hilang):** status sync terlihat jelas di UI;
   backup manual (export SQLite/JSON terenkripsi ke penyimpanan HP, bisa
   di-share ke Drive/WA) + pengingat mingguan; restore di HP baru dari
   Supabase (atau file backup bila belum pernah sync); aplikasi
   memperingatkan sebelum hapus data lokal bila status belum "tersinkron
   semua".
9. **Akun Supabase:** project Dony yang ada saat ini nonaktif/paused — perlu
   diaktifkan / dibuat project baru khusus Casirz + RLS per pemilik (satu
   pemilik hanya bisa baca data tokonya sendiri). Itu urusan Fase 7, bukan
   Fase 0.

## 12. Ensemble review (Groq Qwen 3.8-27b — 15 Nov 2026)

Review dilakukan SEBELUM finalisasi blueprint, sesuai brief Fase 0.
Reviewer: Groq `qwen/qwen3.8-27b` (2 panggilan; panggilan ke-2 sempat 429
output-token-per-minute, retry setelah 25 detik berhasil). Panggilan pertama
terpotong di limit 2048 token output (ekor poin 6 tidak lengkap) — bagian
yang terpotong ditanyakan ulang di panggilan ke-2 (akun 1020/1030 + vonis).
Minimal 1 model lain terpenuhi (Groq Qwen). Temuan diterapkan ke blueprint
ini; yang ditolak dicatat dengan alasannya.

### 12.1 Diterapkan

| # | Temuan Qwen | Diterapkan di |
|---|---|---|
| E1 | Skema tidak cukup untuk multi-payment & split bill — butuh tabel pembayaran terpisah per metode | `salePayments` (§3.2) + `orderLines` + `orders` sebagai open bill, beda dari `sales` (§3.2, §5.2) |
| E2 | `avgCost` integer Rp = risiko HPP meleset kumulatif — simpan mili-Rupiah atau jadikan derived dari `totalValue/stockQty` | `avgCostMilli` INT + `totalValue` INT (§4.2); contoh HPP Rp7.360 tetap cocok |
| E3 | `postJournal` dilarang buka transaksi sendiri — service pemilik transaksi, `Ledger`/`Bom` terima `Transaction` | §5.1 + signature `postJournal(Transaction tx, ...)` + varian `postJournalStandalone` |
| E4 | Mencampur jurnal append-only dengan LWW = fatal — jurnal/stockMoves harus `INSERT OR IGNORE` by UUID, jangan pernah UPDATE/DELETE; outbox blokir `delete` untuk append-only | Kelas sync APPEND vs MASTER (§3.1), §11 butir 6 |
| E5 | Opname tanpa sesi tak teraudit — butuh session ID + selisih sistem vs aktual | `stockOpnames` + `stockOpnameLines` (§3.2); hanya `posted` yang menjurnal |
| E6 | Penyusutan/amortisasi tanpa jadwal/idempotensi — job gagal = `accumulatedDepreciation` tak sinkron dengan jurnal | `assets.lastDepreciationMonth` + idempotensi `refId 'asset:<id>:<yyyy-MM>'` dan `'rent:<yyyy-MM>'` (§3.2) |
| E7 | HPP snapshot ganda (`sales.hppSnapshot` + `saleLines.hppPerUnit`) bisa inkonsisten | `sales.hppSnapshot` DIHAPUS; sumber kebenaran = `saleLines.hppPerUnit` (§3.2) |
| E8 | `computeHPP` di luar transaksi untuk preview lalu stok berubah saat simpan = angka final salah | `computeHPP` = estimasi UI; final wajib `computeHPPInTx` di dalam transaksi penjualan (§4.3, §5.1) |
| E9 | Void harus mengembalikan stok BOM persis (qty bahan saat penjualan, bukan resep saat ini) | Void membaca `stockMoves` sale aslinya → baris `'void-kembali'` (§3.2, §5.2) |

### 12.2 Ditolak (dengan alasan)

| # | Usulan Qwen | Alasan penolakan |
|---|---|---|
| R1 | Tolak penjualan kalau stok tidak cukup (`InsufficientStockException` di dalam transaksi) | **Ditolak oleh keputusan Dony 15 Nov 2026** (§6): stok minus TIDAK diblokir — kasir tetap boleh jualan. `deductBOM` tidak boleh throw karena stok. |
| R2 | Hapus akun 1030 Kas Petty, gabung ke 1000 Kas Laci | **Ditolak — bagan akun beku laporan §3.3.** Model imprest 1030 sudah benar secara akuntansi (petty baru jadi beban saat dibelanjakan, bukan saat diambil); penggabungan menghilangkan jejak uang petty di tangan saat rekonsiliasi shift. |
| R3 | Ubah 1020 jadi akun piutang ojol + model dua jurnal (jual: D Piutang/K Pendapatan; settlement: D Kas + D Komisi/K Piutang) | **Ditolak untuk v1 — bagan akun beku laporan §3.3.** Model satu jurnal laporan (D 1020 netto + D 4200 / K 4000 kotor) lebih sederhana untuk warkop satu device dan sudah beku. Kebutuhan rekonsiliasinya dipenuhi dengan cara lain: event settlement terpisah D 1010/K 1020 (§7.2) + saldo 1020 harus 0 setelah settlement (§7.1). Alternatif Qwen valid secara akuntansi, tapi mengganti bagan beku di tengah Fase 0 bukan tempatnya — bisa dievaluasi lagi di Fase 4 bila settlement ojol terbukti bermasalah. |

### 12.3 Vonis Qwen (diterima dengan catatan)

Qwen memvonis desain "aman diparalelkan setelah 3 perbaikan prioritas":
(1) klasifikasi akun 1020, (2) standardisasi jurnal penjualan & settlement,
(3) sederhanakan kas laci. Butir (1)–(2) dijawab dengan event settlement +
catatan kliring di §7.1–§7.2 (tanpa mengubah bagan beku); butir (3) ditolak
(R2 di atas). Dengan E1–E9 diterapkan, blueprint ini dinyatakan **siap
untuk Fase 1**.

## 13. Kesiapan Fase 1 (core engine) + verifikasi Fase 0

Fase 1 boleh mulai setelah blueprint ini beku. Urutan Fase 1 (dari laporan §6):
database lokal + migrasi (§9) → REA ledger (§5.1, §7) → BOM + moving
average + HPP snapshot (§4) → seed demo (§10).

### 13.1 Tes alur kritis Fase 1 (oracle — harus lolos semua)

1. Jual 2× Kopi Susu Gula Aren → kopi −36g, susu −240ml, gula aren −50ml,
   cup −2pcs; HPP tercatat 2 × Rp7.360 = Rp14.720; jurnal seimbang (D=K);
   Laba Rugi berubah; Neraca selisih 0.
2. Jual saat stok bahan minus → penjualan TETAP BERHASIL; stok tampil minus
   merah + badge "Stok Minus"; HPP tetap memakai `avgCostMilli` terakhir.
3. Seed demo → modal Rp60jt, 11 bahan total Rp3.000.000, 10 menu, 15
   transaksi; omzet 7 hari Rp574.000, HPP Rp210.360, laba kotor Rp363.640;
   Neraca selisih 0.
4. Migrasi (setelah export web tersedia): file `casirz-export-v1.json` lama
   → data muncul di Drift; saldo awal D 1100/K 3100; penjualan historis
   TIDAK masuk Laba Rugi baru.
5. `postJournal` dengan Debit ≠ Credit → throw; tidak ada baris jurnal
   maupun mutasi stok yang tersisa (rollback penuh).
6. Tekan "Isi Data Demo Warkop" 2× → tidak duplikat (reset & isi ulang).

### 13.2 Verifikasi Fase 0 (scaffold — hasil aktual di laporan Fase 0, bukan di sini)

- `flutter create --org com.casirz --project-name casirz ~/workspace/casirz-flutter`
  (package `com.casirz.app`), `pubspec.yaml` sesuai §8.1, struktur folder
  `lib/` sesuai §8.2 (file barrel/`.gitkeep` saja — tanpa kode fitur).
- `flutter pub get` exit 0, `flutter analyze` 0 issue.
- Grep: nol `TODO`, nol `google_fonts`.
- Proyek web v2 (`~/workspace/casirz-next`) tidak diubah.
- Tidak ada push GitHub, tidak ada deploy, tidak ada PDF.

---

*Dokumen ini beku per 15 Nov 2026. Perubahan apa pun setelah ini wajib
dicatat di bawah sebagai adendum dengan tanggal + alasan + siapa yang
memutuskan — jangan edit diam-diam bagian beku.*

## Adendum

- 15 Nov 2026 — Keputusan Dony: stok minus TIDAK diblokir (mengubah
  rekomendasi laporan §7 no. 7). Diterapkan di §0 no. 3, §1.7, §3.1–§3.2,
  §4.2, §5.1, §6, §12.2 R1, §13.1 no. 2. Absensi PIN dan keystore-nanti
  dikonfirmasi tanpa perubahan.
- 15 Nov 2026 — Scaffold selesai: `flutter create` (Flutter 3.35.7 /
  Dart 3.9.2), package id `com.casirz.app`, `flutter pub get` OK,
  `flutter analyze` 0 issue, `flutter test` 1/1 lolos. Versi package di
  §8.1 adalah versi ter-resolve (bukan terbaru pub.dev) karena SDK Dart
  3.9.2 — lihat catatan §8.1 untuk alasan tiap pin + jalur upgrade saat
  SDK naik.
- 15 Nov 2026 — Keputusan koordinator pasca-Fase 1 (engine selesai,
  34/34 test lolos):
  1. Adaptasi `postJournal(Transaction tx, …)` DITERIMA: `Ledger`/`Bom`
     terima `AppDatabase db`, dipanggil di dalam `db.transaction(…)`
     milik service. Alasan: kelas `Transaction` Drift 2.31 adalah
     `@internal` (tidak diekspor publik). Aturan beku tetap: Ledger/Bom
     tidak pernah buka transaksi sendiri; atomicity terbukti test rollback.
  2. Akun baru **1110 Persediaan Barang Dagangan** (Aset, normal D):
     untuk produk TANPA BOM (barang jadi, contoh Air Mineral). Penjualan
     produk tanpa BOM dijurnal D5000 HPP / K1110 (bukan K1100) memakai
     snapshot `product.cost`. Alasan: saldo 1100 harus = Σ totalValue
     bahan persis; selisih Rp7.500 di seed Fase 1 membuktikan klasifikasi
     lama salah. Bagan 29 akun lama tidak berubah kodenya. Implementasi:
     Fase 4 (akuntansi) + penyesuaian seed.
  3. Poin pelanggan: akrual mengikuti perilaku web v2 — 1 poin per
     Rp10.000 belanja (floor(total/10000)) per penjualan, disimpan di
     customer. Penukaran poin (redemption) TIDAK ada di v1. Implementasi:
     Fase 2 (kasir).
  4. Stok awal Air Mineral di seed: 100 pcs @Rp2.500 (nilai Rp250.000,
     akun 1110) — mengikuti seed web v2 (stok 100). Sebelumnya 0 → stok
     seed −3. Diperbaiki di Fase 4 bersama akun 1110.
  5. Penjualan total Rp0 ditolak di v1 (jurnal nol tidak bermakna).
     Fase 2: diskon 100% tidak diizinkan di UI kasir sampai ada aturan.
  6. Lingkungan test VM: symlink
     `/usr/lib/x86_64-linux-gnu/libsqlite3.so → libsqlite3.so.0` dibuat
     manual agar `flutter test` jalan (di luar `~/workspace`, hilang bila
     VM diganti; buat ulang atau install `libsqlite3-dev`).
- 15 Nov 2026 — Keputusan koordinator pasca-Fase 2 (Kasir+, 67/67 test
  lolos, analyze 0 issue):
  1. Pubspec: `dependency_overrides: image: 4.10.2` (Fase 2). Alasan:
     `printing` → `pdf 3.12.0` mengunci `archive <4.1.0`, sementara
     `unified_esc_pos_printer` → `image 4.11.0` butuh `decodeLazy`
     (baru di archive 4.1.0). Override ini versi terakhir image tanpa
     `decodeLazy`. Hapus saat SDK naik (Dart ≥3.10) + `printing` naik.
  2. Akrual poin pelanggan TIDAK atomik di v1 Fase 2 (accrual di transaksi
     terpisah setelah `recordSale`). Perbaikan DISETUJUI: `recordSale`
     mengakrual poin DI DALAM transaksi yang sama (1 poin / Rp10.000,
     floor(total/10000)). Dikerjakan sebagai prasyarat Fase 3 (patch
     engine kecil + test; API `recordSale` boleh bertambah parameter
     opsional, perilaku lama tidak berubah).
  3. Metode bayar: `SaleService` hanya kenal tunai/qris/ojol; Fase 2
     memetakan Debit/Transfer & E-Wallet ke 'qris' (akun 1020). Perbaikan
     DISETUJUI: engine terima `'transfer'` dan `'debit'` → akun 1010 Bank;
     E-Wallet tetap 1020 (sesuai bagan: 1020 QRIS/E-Wallet). Dikerjakan
     bersama butir 2 sebagai prasyarat Fase 3.
  4. Belanja petty: konvensi `pettyCash.amount` positif = isi, negatif =
     belanja (diimplementasi `shift_service.dart` via `Ledger.postJournal`
     D 51xx/K 1030 + baris `expenses`). Diterima, tidak diubah.
  5. `flutter build apk` TIDAK BISA jalan di VM (tidak ada JDK,
     `JAVA_HOME` tidak diset) — bukan error kode. Build APK/AAB lewat
     GitHub Actions (Fase 7). `flutter build web` bukan target (web v2 =
     Next.js).
  6. Symlink sqlite hilang lagi saat service restart di tengah Fase 2
     (40 test sempat gagal) — dibuat ulang, 67/67 hijau kembali. Perlu
     dibuat ulang tiap VM diganti (lihat butir 6 adendum sebelumnya).
- 15 Nov 2026 — Keputusan koordinator pasca-Fase 5 (Staf, 153/153 test
  lolos, analyze 0 issue):
  1. Migrasi skema v1 → v2 (employees.salaryType/baseSalary,
     payrolls.additions/note; onUpgrade tambah kolom + default).
     DITERIMA. Yang belum teruji: jalur onUpgrade dari DB v1 sungguhan
     (hanya onCreate yang dites) — wajib dicek sekali di HP yang sudah
     punya data v1 sebelum rilis (Fase 8).
  2. Gate DB kosong: bila NOL karyawan, shell terbuka tanpa kunci
     (supaya widget test Fase 2–4 tetap hijau). Gate owner-setup aktif
     begitu ada karyawan. DITERIMA + didokumentasikan.
  3. Lockout PIN 3× salah → 1 menit disimpan di MEMORI saja (restart
     aplikasi mereset hitungan). DITERIMA untuk v1.
  4. Pemulihan PIN lupa: owner yang sedang login bisa atur ulang PIN
     karyawan mana pun (termasuk owner lain) dari halaman Staf. Bila
     satu-satunya owner lupa PIN, satu-satunya jalan adalah reset data
     total (Pengaturan → Reset Data). Teks ini wajib ada di lock screen.
     Dikerjakan Fase 6 (Bagian A).
  5. Atribusi penjualan & shift: WAJIB memakai employeeId dari SESI
     login (bukan dropdown activeEmployeeId di settings — dropdown
     dihapus). Tanpa sesi → employeeId null + "Tanpa login".
     Dikerjakan Fase 6 (Bagian A).
- 15 Nov 2026 — Keputusan koordinator pasca-Fase 8 (verifikasi akhir):
  1. Opening float shift TIDAK dijurnal (menyimpang dari blueprint
     §7.2 yang menulis D1000/K1010). Alasan: sumber float ambigu —
     bisa dari bank (D1000/K1010 benar), bisa dari sisa kas shift
     sebelumnya yang sudah tercatat di 1000 (menjurnal D1000/K1010
     justru salah karena mengurangi bank yang tidak berkurang).
     `openShift` hanya menyimpan baseline rekonsiliasi; rekonsiliasi
     + Neraca terbukti tetap seimbang (E2E Fase 8). Bila nanti Dony
     minta float tercatat di buku, tambahkan pilihan sumber float
     (Bank / Laci sebelumnya) di UI buka shift.
  2. `StubSyncEngine` di lib/core/sync.dart DIBIARKAN (kontrak beku,
     tidak dipakai provider lagi) — dokumentasi kontrak, bukan kode
     mati yang harus dihapus.
  3. Backup TIDAK terenkripsi (keputusan Fase 7): "enkripsi sederhana"
     (XOR/base64) tidak dipalsukan sebagai enkripsi. Enkripsi kata
     sandi = open item bila Dony minta.
