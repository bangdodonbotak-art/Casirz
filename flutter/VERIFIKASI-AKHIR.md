# Verifikasi Akhir — Casirz ERP Flutter (Fase 8)

Tanggal: 15 November 2026.
Status: **LOLOS di VM — siap push ke GitHub** (APK debug pertama baru
terbukti setelah GitHub Actions jalan; lihat §5).

Perintah verifikasi yang dijalankan (di VM, SDK
`~/workspace/flutter-sdk/flutter`, Flutter 3.35.7 / Dart 3.9.2):

- `flutter analyze` → **0 issue**
- `flutter test` → **198/198 lolos** (194 lama + 4 baru Fase 8)
- grep `TODO|FIXME` di `lib/` + `test/` → **0**
- grep `google_fonts` di `lib/` + `test/` + `pubspec.yaml` → **0**
- grep kredensial hardcode (Supabase URL/key, password) di `lib/` +
  `test/` → **0 temuan nyata** (2 hit adalah false positive, lihat §2)
- `flutter pub outdated` → hanya pencatatan, **tidak ada upgrade**
- `flutter build apk` → **tidak dicoba** (tidak ada JDK di VM — bukan
  error kode; jalur build adalah GitHub Actions)

## 1. Ringkasan per fase (apa yang dibangun + bukti test)

| Fase | Yang dibangun | Bukti test |
|---|---|---|
| 0 — Scaffold | `flutter create` package `com.casirz.app`, pubspec sesuai blueprint §8.1, struktur `lib/` | `flutter pub get` OK, analyze 0 issue |
| 1 — Core engine | Drift/SQLite 26 tabel + 2 sync, REA ledger (jurnal seimbang atomik), BOM + HPP moving average mili-Rupiah, seed demo "Warkop Kekinian Preset" Rp60jt, migrasi import web v2, outbox sync | `test/core_engine_test.dart` — 33 test: fmt/round3, bagan 30 akun, jual 2x Kopi Susu (stok −36g/−240ml/−50ml/−2 cup, HPP Rp14.720), HPP snapshot, multi-payment, ojol netto 1020 + komisi 4200, jual saat stok minus tetap berhasil, `postJournal` tidak seimbang → throw + rollback penuh, void + jurnal pembalik, stock-in avg Rp160/g, wastage Rp1.800, opname susut Rp7.500, oracle seed omzet Rp574.000 / HPP Rp210.360 / laba kotor Rp363.640, seed 2x tidak duplikat, import valid + format salah ditolak |
| 2 — Kasir+ | Penjualan (tunai/QRIS/ojol/multi), meja + open bill, split/merge, shift + rekonsiliasi, struk, poin pelanggan | `test/pos_logic_test.dart` — 33 test + `test/widget_test.dart` — 4 widget test (shell, Kasir, Meja, Bahan Baku, Akuntansi, Laporan tampil) |
| 3 — Inventory | Stock-in, wastage, opname bersesi, resep/BOM, hapus bahan (tombstone), badge "Stok Minus" | `test/fase3_inventory_test.dart` — 18 test + `test/fase3_patch_test.dart` — 14 test: poin atomik di dalam transaksi penjualan (void membalik poin), transfer/debit → akun 1010 Bank, E-Wallet tetap 1020 |
| 4 — Akuntansi | Akun 1110 Persediaan Barang Dagangan, modal, aset + penyusutan garis lurus, amortisasi sewa, OPEX, Laba Rugi / Neraca / Arus Kas, export CSV + PDF | `test/fase4_accounting_test.dart` — 20 test: HPP tanpa BOM D 5000 / K 1110, 1100 = Σ totalValue bahan persis, Neraca selisih 0 (dengan seed + OPEX + penyusutan), Arus Kas seed operasi Rp574.000 + pendanaan Rp17.000.000, jadwal susut 10jt/60 bln, CSV + PDF valid |
| 5 — Staf | PIN (hash + salt, 4–6 digit), lockout 3x salah = 1 menit, matriks hak akses, absensi PIN, payroll bulanan/harian, migrasi skema v1→v2 | `test/fase5_staff_test.dart` — 31 test: PIN benar/salah, PIN belum diatur, check-in/out + telat, gaji bulanan vs harian, proses 2x periode sama ditolak, slip gaji, widget lock screen + gate DB kosong |
| 6 — Dashboard | Command Center (omzet, jam sibuk, top-selling, margin, alert stok, BEP), atribusi employeeId dari sesi login, reset data total, teks pemulihan PIN di lock screen | `test/fase6_dashboard_test.dart` — 22 test: penjualan/shift atas employeeId sesi, tanpa sesi → null ("Tanpa login"), jual 300 Kopi Susu → bahan minus muncul di alert, hanya Owner boleh buka Command Center |
| 7 — Sync + CI | Outbox FIFO + pull delta + watermark, LWW + syncConflicts, backup/restore JSON, workflow GitHub Actions build APK/AAB, ikon Android/iOS | `test/fase7_sync_test.dart` — 19 test: push FIFO berhenti di gagal pertama, pull delta, APPEND duplikat UUID tidak ganda, LWW + tombstone, config kosong = sync nonaktif, backup/restore utuh, workflow CI (job debug-apk + release-aab + signing kondisional), ikon semua densitas + adaptive + iOS, nama aplikasi Casirz |
| 8 — Verifikasi akhir | Test E2E alur kritis, test migrasi v1→v4 dari file DB lama, test badge offline, README proyek, laporan ini | `test/fase8_e2e_test.dart` — 4 test (lihat §3) |

## 2. Hasil verifikasi akhir (angka)

### 2.1 Analyze + test

```text
flutter analyze  → No issues found!
flutter test     → 198/198 lolos (00:44 di VM)
  core_engine_test.dart ....... 33
  pos_logic_test.dart ......... 33
  fase5_staff_test.dart ....... 31
  fase6_dashboard_test.dart ... 22
  fase4_accounting_test.dart .. 20
  fase7_sync_test.dart ........ 19
  fase3_inventory_test.dart ... 18
  fase3_patch_test.dart ....... 14
  fase8_e2e_test.dart .........  4  (BARU)
  widget_test.dart ............  4
  TOTAL ....................... 198
```

### 2.2 Grep

- `TODO|FIXME` di `lib/` + `test/`: **0**.
- `google_fonts` di `lib/` + `test/` + `pubspec.yaml`: **0**.
- Kredensial hardcode di `lib/` + `test/`: **0 temuan nyata**.
  Dua hit grep perlu dijelaskan supaya tidak dikira bocor:
  - `lib/core/supabase_config.dart:8` — komentar contoh perintah
    `--dart-define=SUPABASE_URL=https://<project>.supabase.co`
    (placeholder, bukan URL asli).
  - `test/fase7_sync_test.dart:537` — test yang justru MEMASTIKAN
    `KEYSTORE_PASSWORD` tidak tertulis polos di workflow YAML.
  - URL + anon key Supabase hanya dibaca dari `--dart-define`
    (`String.fromEnvironment`); tidak ada nilai kredensial di repo.

### 2.3 `flutter pub outdated` (dicatat saja — TIDAK di-upgrade)

Direct dependencies yang punya versi terbaru di pub.dev (semua
TERKUNCI oleh Dart 3.9.2 — lihat blueprint §8.1, jangan upgrade
setengah-setengah): `csv` 6.0.0 → 8.0.0, `drift` 2.31.0 → 2.35.4,
`drift_flutter` 0.2.8 → 0.3.1, `file_picker` 11.0.3 → 13.3.3,
`flutter_riverpod` 2.6.1 → 3.5.0, `printing` 5.14.3 → 5.15.1,
`share_plus` 12.0.2 → 13.3.1, `pdf` 3.12.0 → 3.13.1,
`cupertino_icons` 1.0.9 → 2.0.0, `path_provider` 2.1.5 → 2.1.6.
Jalur upgrade: saat SDK naik ke Dart ≥3.10 (lihat blueprint §8.1).

Satu perubahan pubspec di Fase 8 (BUKAN upgrade): `sqlite3: ^2.9.4`
ditambahkan sebagai **dev_dependency** — versi yang sama persis dengan
yang sudah ter-resolve transitif via `drift`. Alasan: test migrasi
Fase 8 membangun file DB v1 mentah lewat `package:sqlite3`; tanpa
direct dep, `flutter analyze` memberi info `depend_on_referenced_packages`.
`pubspec.lock` berubah 1 baris saja (tipe dependensi sqlite3:
`transitive` → `direct dev`); tidak ada versi package yang berubah.

## 3. Test E2E Fase 8 — alur kritis (`test/fase8_e2e_test.dart`)

Satu test menjalankan rantai penuh dengan angka ekspektasi tertulis
(dihitung dari oracle seed §10.5 + transaksi test):

1. **Seed demo** → omzet Rp574.000, HPP Rp210.360, laba kotor
   Rp363.640; Neraca selisih 0; kopi tersisa 3.694g, Air Mineral 97 pcs.
2. **Buka shift** float Rp100.000.
3. **Jual A**: 2x Kopi Susu Gula Aren tunai Rp36.000 → HPP/baris
   Rp7.360; kopi 3.658g, susu 12.590ml.
4. **Jual B**: 1x Air Mineral QRIS Rp5.000 → HPP Rp2.500; stok 96 pcs.
5. **Split bill**: order 1x Kopi Susu + 1x Es Teh → pisah Es Teh ke
   order baru (Rp18.000 / Rp8.000) → bayar tunai masing-masing →
   kedua order `paid`.
6. **Tutup shift** kas fisik Rp162.000 → harapan Rp162.000
   (100.000 + 62.000 tunai), **selisih 0**, tanpa jurnal selisih.
7. **Stock-in** kopi 1.000g Rp150.000 tunai → stok 4.640g,
   `avgCostMilli` tetap 150.000 (Rp150/g).
8. **Opname** kopi aktual 4.540g (susut 100g) → jurnal D 5200 /
   K 1100 **Rp15.000**; stok 4.540g.
9. **Beban listrik** Rp1.000.000 via bank (bukan tunai — laci tinggal
   Rp200.000 setelah stock-in).
10. **Gaji** Kasir 1 Rp1.500.000 via bank, periode bulan berjalan.
11. **Laporan** (rentang 30 hari):
    - Laba Rugi: omzet **Rp641.000**, HPP **Rp238.140**, laba kotor
      **Rp402.860**, OPEX **Rp2.500.000**, selisih stok **Rp15.000**,
      laba bersih **−Rp2.112.140**.
    - Neraca: kas **Rp200.000**, bank **Rp14.500.000**, QRIS
      **Rp291.000**, persediaan **Rp3.146.860** (1100: Rp2.906.860 +
      1110: Rp240.000), total aktiva **Rp58.137.860**, modal
      Rp60.000.000, laba ditahan Rp250.000, laba berjalan −Rp2.112.140,
      **selisih 0**.
    - Arus Kas: operasi **−Rp2.009.000**, investasi **0**, pendanaan
      **Rp17.000.000**, perubahan bersih **Rp14.991.000**, saldo awal 0,
      saldo akhir **Rp14.991.000**.
    - Semua jurnal seimbang (total debit == total kredit).
12. **Backup → restore ke DB baru**: export JSON (29 tabel) →
    import → 19 penjualan kembali (15 seed + 4), Laba Rugi +
    Neraca (selisih 0, total aktiva sama) **identik**.
13. **Offline**: outbox terisi (>0 pending), `RealSyncEngine` tanpa
    transport → `syncNow()` = 0/0/0, outbox tetap pending (tidak ada
    yang mencoba koneksi).

Test migrasi (test ke-2 di file yang sama): file SQLite **skema v1
buatan** (employees tanpa `salaryType`/`baseSalary`; sales + shifts
dengan `employeeId NOT NULL`; payrolls tanpa `additions`/`note`;
tanpa tabel `syncConflicts`; `user_version = 1`; berisi 1 karyawan +
1 shift + 1 penjualan + 1 payroll) dibuka dengan `AppDatabase`
(schemaVersion 4) → **onUpgrade v1→v2→v3→v4 jalan**: data lama utuh
("Owner Lama"), kolom v2 terisi default (`bulanan` / 0),
`sales.employee_id` jadi nullable (insert penjualan tanpa employeeId
berhasil), tabel `syncConflicts` dibuat, kolom `additions`/`note` ada
di payrolls.

Test offline (test ke-3 + ke-4): config kosong → `isConfigured`
false, `SupabaseTransport` throw `StateError` pesan jelas; widget
test membuktikan badge **"Sync belum aktif"** tampil di app bar bila
config kosong.

## 4. Verifikasi offline (code review + test)

- `grep package:http | HttpClient | Supabase.initialize` di `lib/`:
  hanya 2 komentar + 1 pemakaian nyata di
  `lib/core/sync_engine.dart:118` — di dalam
  `SupabaseTransport._client()`, yang dipanggil **malas (lazy)** saat
  push/pull pertama.
- `SupabaseTransport` konstruktor **throw** bila config kosong
  (`supabase_config.dart: requireConfigured()`); transport hanya
  dibuat bila `config.isConfigured` (`pos_providers.dart:34-36`).
  Tanpa `--dart-define`, tidak ada objek transport, tidak ada
  `Supabase.initialize()`, tidak ada koneksi.
- `RealSyncEngine` tanpa transport: `pushPending()` / `pullDelta()` /
  `syncNow()` mengembalikan `SyncResult(0,0,0)` tanpa menyentuh
  jaringan (dites Fase 7 + Fase 8).
- Badge: `lib/features/shell/app_shell.dart:395-416` — bila config
  kosong label = **"Sync belum aktif"** + tooltip "Sinkronisasi belum
  diaktifkan — aktifkan proyek Supabase dulu (Fase 7). Data tetap aman
  di HP ini." (dites widget Fase 8).

## 5. Verifikasi migrasi skema (code review)

`lib/core/db.dart`, `schemaVersion = 4`, `onUpgrade`:

- **v1→v2** (Fase 5): `addColumn` employees.`salaryType`
  (default `'bulanan'`), employees.`baseSalary` (default 0),
  payrolls.`additions` (default 0), payrolls.`note` (nullable).
  Dinilai **benar**: semua kolom baru punya default/nullabel, data
  lama tetap valid.
- **v2→v3** (Fase 6): `TableMigration` sales + shifts,
  `columnTransformer: {employeeId: employeeId}` — mengubah
  `employeeId` jadi nullable sambil mempertahankan nilai lama.
  Dinilai **benar secara pola Drift** (cara standar mengubah
  nullability); **sudah dites dari file v1** di Fase 8 (lihat §3).
- **v3→v4** (Fase 7): `createTable(syncConflicts)`. Dinilai
  **benar**; sudah dites dari file v1 di Fase 8.
- Catatan jujur: rantai onUpgrade dari **DB lama sungguhan di HP**
  (v1/v2/v3 yang pernah dipakai jualan) **belum teruji** — file v1
  di test ini dibuat tangan mengikuti DDL Fase 1, bukan hasil
  `onCreate` versi lama yang sebenarnya. Masuk checklist HP (§7).

## 6. Verifikasi file pendukung

- **CI** `.github/workflows/build-apk.yml`: YAML parse OK (Python
  `yaml.safe_load`). Job `build-debug-apk` (checkout, Java 17,
  Flutter 3.35.7, `pub get`, `analyze`, `test`, `build apk --debug`,
  upload artefak `casirz-debug-apk`) + job `build-release-aab`
  (`needs: build-debug-apk`, `if:` 4 secrets keystore non-kosong →
  skip bila kosong, bukan gagal). Dites juga oleh
  `test/fase7_sync_test.dart` (job + signing kondisional).
- **Ikon Android**: `mipmap-mdpi/hdpi/xhdpi/xxhdpi/xxxhdpi`
  (`ic_launcher.png` + foreground + background) + `mipmap-anydpi-v26/
  ic_launcher.xml` (adaptive icon) — ada semua (dites Fase 7 dengan
  cek ukuran).
- **Ikon iOS**: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
  berisi `Icon-App-1024x1024@1x.png` + ukuran kecil (dites Fase 7).
- **Nama aplikasi**: AndroidManifest `android:label="Casirz"`,
  iOS `CFBundleDisplayName = Casirz` (dites Fase 7).
- **pubspec**: `version: 0.1.0+1`, package `casirz`
  (`com.casirz.app` di AndroidManifest — dicek Fase 0).
- **README.md**: ditulis ulang di Fase 8 (sebelumnya template
  bawaan `flutter create`): cara build lokal, cara CI, cara aktifkan
  Supabase, cara isi keystore nanti, batasan yang diketahui. Tidak ada
  janji yang belum teruji di dalamnya.

## 7. Verifikasi web v2 tidak berubah

`~/workspace/casirz-next` **bukan repo git** (`git status` gagal:
"not a git repository"), jadi verifikasi memakai daftar file + mtime:

- `find casirz-next -type f -newer BLUEPRINT-FLUTTER.md` →
  **tidak ada file** yang lebih baru dari blueprint Flutter
  (15 Nov 2026). Semua file sumber web v2 bermtime 7–8 Nov 2026
  (`app/`, `components/`, `lib/`, `package.json`, `next.config.ts`);
  `.next/` dan `out/` 8 Nov 2026; `BLUEPRINT.md` web 15 Nov 01:11
  (ditulis saat Fase 0, sebelum build Flutter dimulai).
- **Kesimpulan: web v2 tidak berubah selama build Flutter Fase 0–8.**

## 8. Temuan — bukan blocker (keputusan di koordinator)

1. **Opening float shift tidak dijurnal.** Blueprint §7.2 menulis
   opening float (bank → laci) = D 1000 / K 1010. Implementasi
   (`ShiftService.openShift`, `lib/features/pos/shift_service.dart`)
   hanya menyimpan `openingFloat` sebagai baseline rekonsiliasi —
   tidak ada `Ledger.postJournal` di sana (jurnal shift yang ada
   hanya selisih tutup shift + belanja petty). Rekonsiliasi tutup
   shift + Neraca tetap seimbang (dibuktikan test E2E §3), dan dalam
   praktik warkop satu laci, float biasanya uang tunai sisa kemarin
   yang sudah tercatat di akun 1000. Tapi ini **menyimpang dari tabel
   §7.2** — koordinator yang memutuskan: biarkan (dan catat di
   blueprint), atau tambahkan jurnal saat buka shift. Bukan blocker
   push.
2. **Test E2E sempat gagal 2x sebelum hijau — keduanya salah test,
   bukan salah kode** (dicatat supaya tidak diulang): (a) Neraca
   dibaca per tanggal `now` awal test, padahal jurnal stock-in/gaji
   memakai `DateTime.now()` sesudahnya → pakai `reportAsOf` setelah
   semua transaksi; (b) file DB v1 buatan kekurangan tabel induk FK
   (`customers`, `orders`) sehingga insert ke `sales` gagal
   "no such table" saat `foreign_keys=ON` → tabel minimal ditambahkan.
   Keduanya diperbaiki di test, kode produksi tidak diubah.

## 9. Yang JUJUR tidak bisa dites di VM

- **`flutter build apk` / `flutter build appbundle`**: tidak ada JDK
  di VM (`JAVA_HOME` tidak diset). Build APK/AAB pertama yang
  sebenarnya baru terverifikasi setelah push + GitHub Actions jalan.
- **Printer thermal**: tidak ada printer di VM. Kode ESC/POS
  (`lib/core/printer/esc_pos_printer.dart`) hanya terverifikasi
  compile + unit test model struk — struk fisik belum pernah keluar.
- **Migrasi dari DB HP sungguhan**: rantai onUpgrade dites dari file
  v1 buatan (§3), bukan dari HP yang pernah install build v1/v2/v3.
- **Sync Supabase end-to-end**: tidak ada project aktif + tidak ada
  kredensial; transport hanya dites dengan fake transport (Fase 7)
  dan config kosong (Fase 8). Push/pull sungguhan ke Supabase belum
  pernah terjadi.
- **Tampilan di HP fisik**: semua widget test jalan di test harness
  (ukuran default 800x600); tampilan 360–400px, sentuhan jari,
  keyboard, dan dark mode di HP belum dicek.
- **Migrasi dari web v2**: format `casirz-export-v1.json` sudah
  dites (import valid + format salah ditolak), tapi tombol export di
  web v2 **belum ada** (blueprint §9.2) — migrasi end-to-end dari
  data web lama belum bisa jalan.
- **Performa**: tidak ada uji beban (ratusan transaksi/hari, DB
  membesar) di VM.

## 10. Checklist HP untuk Dony

Lakukan setelah parent push ke GitHub dan CI selesai (APK debug ada
di artefak Actions `casirz-debug-apk`). Urutan penting — jangan
loncat.

### A. Install + setup awal

1. [ ] Download `app-debug.apk` dari GitHub Actions (artefak
      `casirz-debug-apk`), install di HP (izinkan "install dari
      sumber tidak dikenal" sekali ini).
2. [ ] Buka aplikasi — harus langsung masuk (DB kosong, tanpa kunci).
3. [ ] Pengaturan → **Isi Data Demo Warkop** → cek 10 menu + 11 bahan
      muncul; Kasir → jual 1 Kopi Susu Gula Aren tunai → struk tampil.
4. [ ] Staf → atur PIN owner (4–6 digit, ingat baik-baik!) → kunci
      aplikasi → buka dengan PIN → harus masuk. **Catat PIN di tempat
      aman.** Bila satu-satunya owner lupa PIN, satu-satunya jalan
      adalah Reset Data total (semua data hilang).
5. [ ] Staf → atur PIN 2 kasir (@Rp1.500.000/bulan sudah terisi dari
      seed) → login sebagai kasir → menu Staf + Akuntansi harus
      terkunci.

### B. Jualan offline seharian (mode pesawat)

6. [ ] Nyalakan **mode pesawat** (simulasi offline total).
7. [ ] Buka shift (float Rp100.000) → jualan seharian seperti biasa:
      tunai + QRIS, minimal 1x split bill di meja, 1x stock-in,
      1x wastage. Perhatikan badge di app bar harus **"Sync belum
      aktif"** (bukan error, bukan angka palsu).
8. [ ] Tutup shift → hitung kas fisik → rekonsiliasi harus cocok
      (selisih 0 bila hitungan benar); bila selisih, jurnal selisih
      kas (5220) harus muncul di Jurnal & Buku Besar.
9. [ ] Laporan → Laba Rugi + Neraca hari itu → **selisih Neraca
      harus 0**. Bila bukan 0, STOP — screenshot + kirim ke Muse.
10. [ ] Matikan mode pesawat → aplikasi tetap jalan normal (sync
      tetap nonaktif sampai Supabase diaktifkan — itu normal).

### C. Cetak struk thermal

11. [ ] Sambungkan printer thermal (Bluetooth/USB) → Pengaturan →
      Printer → cari + sambungkan.
12. [ ] Jual 1 transaksi → **Cetak Struk** → struk fisik harus keluar
      lengkap (nama toko, item, total, pembayaran, kembalian).
      Bila struk tidak keluar / terpotong / karakter aneh → foto
      struk + kirim ke Muse (jangan klaim "cetak jalan" sebelum ini).

### D. Backup / restore

13. [ ] Pengaturan → Backup → Export → simpan file
      `casirz-backup-*.json` (kirim ke Drive/WA sendiri).
14. [ ] Pengaturan → Reset Data (atau install ulang) → Backup →
      Restore → pilih file tadi → semua data (penjualan, stok,
      jurnal, karyawan) harus kembali; cek Laba Rugi + Neraca
      angkanya sama seperti sebelum reset.

### E. Upgrade DB (hanya bila HP ini pernah install build lama)

15. [ ] Bila HP ini **pernah** install Casirz build v1/v2/v3 (dari
      CI sebelumnya) dan sudah ada data jualan di dalamnya: install
      APK baru **menimpa** yang lama (jangan uninstall dulu!) →
      buka aplikasi → data lama harus tetap ada, aplikasi tidak crash.
16. [ ] Cek: karyawan lama masih ada (gaji pokok terisi default),
      penjualan lama masih ada, Neraca selisih 0. Bila crash / data
      hilang → JANGAN reset dulu — hubungi Muse (file `casirz.db`
      masih bisa diselamatkan sebelum reset).

### F. Aktivasi Supabase + sync (nanti, setelah lokal stabil)

17. [ ] Aktifkan / buat project Supabase khusus Casirz + atur RLS per
      pemilik (butuh Dony — project lama saat ini paused).
18. [ ] Beri URL + anon key ke Muse (jangan pernah service_role key)
      → Muse build ulang dengan `--dart-define` → install APK baru.
19. [ ] Jual 1 transaksi → badge berubah dari "Sync belum aktif"
      jadi "N perubahan belum tersinkron" lalu "Tersinkron" setelah
      sync berhasil; cek data muncul di Supabase.

### G. Play Store (nanti, saat rilis)

20. [ ] Buat keystore + isi 4 secrets GitHub + daftar Play Console
      ($25, di tangan Dony) → CI build AAB release → upload AAB ke
      Play Console. **Jangan** lakukan ini sebelum A–F beres.
