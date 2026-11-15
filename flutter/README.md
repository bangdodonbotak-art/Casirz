# Casirz ERP — POS + Akuntansi F&B (Flutter)

Aplikasi kasir + akuntansi warkop, **offline-first**. Database lokal
(Drift/SQLite) adalah sumber kebenaran; semua penjualan, stok, dan jurnal
ditulis lokal dulu, sinkron ke Supabase belakangan (bila diaktifkan).

- Package id: `com.casirz.app`
- Nama aplikasi: **Casirz**
- Versi: `0.1.0+1` (lihat `pubspec.yaml`)
- Bahasa UI: Indonesia. Uang: integer Rupiah.
- Blueprint beku: `BLUEPRINT-FLUTTER.md` (baca ini dulu sebelum mengubah
  apa pun — termasuk Adendum berisi keputusan koordinator Fase 1–6).

## Yang ada di aplikasi

- **Kasir**: jual tunai/QRIS/ojol/transfer/debit, multi-payment, meja +
  open bill, split/merge bill, shift + rekonsiliasi laci, struk thermal
  ESC/POS (58/80mm), poin pelanggan (1 poin / Rp10.000).
- **Bahan baku**: BOM + HPP moving average (mili-Rupiah), stock-in,
  wastage, opname bersesi. **Stok minus diizinkan** (keputusan Dony) —
  penjualan tetap jalan, stok minus tampil merah + badge "Stok Minus".
- **Akuntansi**: REA ledger (jurnal seimbang, atomik dengan mutasi stok),
  bagan 30 akun, modal, aset + penyusutan, beban OPEX, gaji, Laba Rugi,
  Neraca (selisih harus 0), Arus Kas, export CSV + print PDF.
- **Staf**: absensi PIN (bukan selfie), lockout 3x salah = 1 menit,
  payroll bulanan/harian.
- **Dashboard**: Command Center (omzet 7 hari, jam sibuk, matriks menu,
  alert stok, BEP).
- **Backup & sync**: export/import backup JSON (`casirz-backup-v1`),
  pengingat backup mingguan, outbox sync + Supabase (nonaktif default).

## Cara build lokal

```sh
flutter pub get
flutter analyze        # harus 0 issue
flutter test           # harus semua lolos (198 test, ~45 detik di VM)
```

Build APK **tidak bisa** di VM ini (tidak ada JDK). Build APK/AAB hanya
lewat GitHub Actions — lihat bawah.

## Cara CI (GitHub Actions)

Workflow: `.github/workflows/build-apk.yml` — jalan tiap push ke `main`
+ manual (`workflow_dispatch`).

- Job `build-debug-apk`: setup Java 17 + Flutter 3.35.7, `pub get`,
  `analyze`, `test`, `flutter build apk --debug`, upload artefak
  `casirz-debug-apk` (file `app-debug.apk`).
- Job `build-release-aab`: jalan hanya bila secrets keystore terisi
  (`KEYSTORE_BASE64`, `KEYSTORE_PASSWORD`, `KEY_ALIAS`, `KEY_PASSWORD`).
  Bila secrets kosong, job di-SKIP (bukan gagal).

## Cara aktifkan Supabase (sync)

Sync **nonaktif** secara default. Tanpa konfigurasi, aplikasi 100%
offline dan app bar menampilkan "Sync belum aktif" — bukan error.

1. Aktifkan / buat project Supabase khusus Casirz (project lama Dony
   saat ini nonaktif/paused — perlu diaktifkan atau dibuat baru),
   atur RLS per pemilik (satu pemilik hanya bisa baca data tokonya).
2. Build dengan dart-define (jangan hardcode URL/key di repo):
   ```sh
   flutter build apk --debug \
     --dart-define=SUPABASE_URL=https://<project>.supabase.co \
     --dart-define=SUPABASE_ANON_KEY=<anon key>
   ```
   Pakai **anon (publishable) key** — jangan pernah service_role key.
3. Skema Supabase + aturan outbox/LWW ada di `BLUEPRINT-FLUTTER.md`
   §3, §5.3, §11. Detail implementasi: `lib/core/sync_engine.dart`,
   `lib/core/supabase_config.dart`.

## Cara isi keystore nanti (saat rilis — BUKAN sekarang)

Keputusan Dony: keystore + Play Console ($25) **nanti saat rilis**.
Jangan minta keystore ke Dony sebelum itu.

Saat rilis tiba:

1. Buat keystore sekali: `keytool -genkeypair -v -keystore casirz.jks
   -alias casirz -keyalg RSA -keysize 2048 -validity 10000`
   (simpan file + password di tempat aman, jangan commit ke repo).
2. Isi 4 secrets di repo GitHub (Settings → Secrets → Actions):
   `KEYSTORE_BASE64` (isi `base64 -w0 casirz.jks`),
   `KEYSTORE_PASSWORD`, `KEY_ALIAS`, `KEY_PASSWORD`.
3. Push ke `main` — job `build-release-aab` jalan dan mengunggah
   `app-release.aab` sebagai artefak. AAB itu yang diunggah ke Play
   Console (biaya pendaftaran $25 sekali, di tangan Dony).

## Batasan yang diketahui (jujur, bukan janji)

- `flutter build apk` tidak bisa jalan di VM ini (tidak ada JDK) —
  build APK pertama yang sebenarnya baru terverifikasi setelah push
  dan GitHub Actions jalan.
- Printer thermal tidak bisa dites penuh di VM — klaim "cetak jalan"
  baru sah setelah struk benar-benar keluar dari printer fisik di HP.
- Migrasi skema v1→v2→v3→v4 sudah dites dari **file DB v1 buatan**
  (`test/fase8_e2e_test.dart`), tapi belum dari DB v1/v2/v3 sungguhan
  di HP yang sudah pernah install build lama — cek sekali di HP
  sebelum rilis (lihat `VERIFIKASI-AKHIR.md`).
- Symlink `/usr/lib/x86_64-linux-gnu/libsqlite3.so` hilang tiap VM
  diganti — buat ulang bila `flutter test` gagal load library.
- Versi package dipin ke yang kompatibel dengan Dart 3.9.2
  (Flutter 3.35.7) — lihat alasan tiap pin di `BLUEPRINT-FLUTTER.md`
  §8.1. Jangan `flutter pub upgrade` sembarangan; jalur upgrade ada
  di blueprint (naik saat SDK naik ke Dart ≥3.10).
- Lockout PIN 3x salah disimpan di memori saja (restart aplikasi
  mereset hitungan). Bila satu-satunya owner lupa PIN, satu-satunya
  jalan adalah Reset Data total (Pengaturan → Reset Data).
- Opening float shift **tidak** dijurnal ke ledger (hanya dipakai
  sebagai baseline rekonsiliasi tutup shift) — menyimpang dari tabel
  §7.2 blueprint (D 1000 / K 1010). Rekonsiliasi + Neraca tetap
  seimbang; keputusan lanjut/tidak ada di koordinator.
- Export web v2 (`casirz-export-v1.json`) belum ada — migrasi dari
  data web lama belum bisa dites end-to-end.
