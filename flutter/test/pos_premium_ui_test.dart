// Rework premium netral (15 Nov 2026) — regression test UI Kasir.
// - Grid produk seed pada HP 360x780 TIDAK BOLEH overflow (bug lama:
//   pita kuning "BOTTOM OVERFLOWED BY 9.1 PIXELS" di 3 kartu).
// - Pita DEBUG (Banner) TIDAK BOLEH ada (debugShowCheckedModeBanner).
// - Golden: tampilan grid premium baru (foto + nama + harga).
//
// CATATAN:
// - Layar Kasir di-pump lewat AppShell langsung (bukan CasirzApp
//   penuh) — DB seed punya karyawan tanpa PIN sehingga SessionGate
//   menampilkan OwnerSetupScreen, bukan Kasir. AppShell sendiri tidak
//   mengunci layar, jadi pump langsung menguji grid yang sama seperti
//   di HP. Test Banner memakai CasirzApp penuh (DB kosong -> shell
//   langsung tampil) supaya flag debug di app.dart yang diuji, bukan
//   flag di test ini.
// - Finder produk di-scope ke grid PosPage: IndexedStack membangun
//   SEMUA tab (termasuk Transaksi yang menampilkan nama produk dari
//   penjualan seed) — find.text polos menemukan >1 widget.
// - Setiap test diakhiri _flushDisposalTimers: Drift membuat timer
//   nol-detik saat provider Riverpod di-dispose (markAsClosed);
//   kalau tree dibuang setelah test berakhir, test gagal dengan
//   "A Timer is still pending even after the widget tree was disposed".
import 'package:casirz/app.dart';
import 'package:casirz/core/db.dart';
import 'package:casirz/core/seed.dart';
import 'package:casirz/features/pos/pos_page.dart';
import 'package:casirz/features/pos/pos_providers.dart';
import 'package:casirz/features/pos/product_photos.dart';
import 'package:casirz/features/shell/app_shell.dart';
import 'package:casirz/shared/theme/app_theme.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

/// Font nyata (bukan Ahem) supaya metrik teks di test = di HP.
Future<void> _loadPremiumFonts() async {
  final grotesk = FontLoader('Space Grotesk')
    ..addFont(rootBundle.load('assets/fonts/SpaceGrotesk[wght].ttf'));
  await grotesk.load();
  final fraunces = FontLoader('Fraunces')
    ..addFont(
      rootBundle.load('assets/fonts/Fraunces[SOFT,WONK,opsz,wght].ttf'),
    );
  await fraunces.load();
}

/// DB seed demo + satu produk buatan user: tanpa foto (placeholder) +
/// stok menipis (chip amber) + nama panjang 2 baris — kasus terberat.
Future<AppDatabase> _seededDb() async {
  final db = AppDatabase.memory();
  await SeedDemo.run(db);
  await db.into(db.products).insert(
    ProductsCompanion.insert(
      id: 'test-produk-uji',
      name: 'Produk Uji Stok Menipis Panjang',
      category: 'Makanan',
      price: 9999,
      cost: 1111,
      stock: const Value(5),
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      deviceId: 'test',
    ),
  );
  return db;
}

/// Grid produk Kasir (bukan grid Meja) — satu-satunya GridView di
/// dalam PosPage.
Finder get _productsGrid => find.descendant(
  of: find.byType(PosPage),
  matching: find.byType(GridView),
);

/// Scrollable di dalam grid produk Kasir (scrollUntilVisible butuh
/// finder Scrollable yang unik — find.byType(Scrollable) polos
/// menemukan banyak Scrollable dari tab lain di IndexedStack).
Finder get _productsScrollable => find.descendant(
  of: _productsGrid,
  matching: find.byType(Scrollable),
);

/// Buang tree aplikasi lebih awal + pompa supaya timer nol-detik
/// Drift sempat jalan (lihat catatan di atas).
Future<void> _flushDisposalTimers(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(seconds: 1));
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
    await _loadPremiumFonts();
  });

  Future<void> pumpShell(WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final db = await _seededDb();
    addTearDown(db.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          debugShowCheckedModeBanner: false,
          home: const AppShell(),
        ),
      ),
    );
    // Tunggu grid produk muncul (productsProvider async) — maks ~5 detik.
    for (var i = 0; i < 50; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      if (_productsGrid.evaluate().isNotEmpty) break;
    }
    expect(_productsGrid, findsOneWidget);
  }

  testWidgets('Grid POS 360x780: tanpa overflow', (tester) async {
    await pumpShell(tester);
    expect(tester.takeException(), isNull);
    // GridView hanya membangun item yang terlihat, dan scrollUntilVisible
    // hanya menggulir ke BAWAH — cek produk dari ATAS ke bawah sesuai
    // urutan grid (kategori lalu nama): Makanan dulu, lalu Minuman.
    for (final name in [
      'Indomie Goreng Spesial',
      'Produk Uji Stok Menipis Panjang',
      'Kopi Susu Gula Aren',
    ]) {
      final cardName = find.descendant(
        of: _productsGrid,
        matching: find.text(name),
      );
      await tester.scrollUntilVisible(
        cardName,
        200,
        scrollable: _productsScrollable,
      );
      await tester.pump();
      expect(cardName, findsOneWidget);
      expect(tester.takeException(), isNull);
      if (name == 'Produk Uji Stok Menipis Panjang') {
        // Chip amber stok menipis (stok 5) ada di kartu produk uji.
        expect(find.text('Stok menipis'), findsOneWidget);
      }
    }
    // Gulir sampai bawah supaya baris terakhir ikut ter-build.
    await tester.fling(_productsGrid, const Offset(0, -600), 800);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(tester.takeException(), isNull);
    // HPP dan "Stok: N pcs" TIDAK tampil di kartu kasir.
    expect(
      find.descendant(
        of: _productsGrid,
        matching: find.textContaining('HPP '),
      ),
      findsNothing,
    );
    expect(
      find.descendant(
        of: _productsGrid,
        matching: find.textContaining('Stok: '),
      ),
      findsNothing,
    );
    // Foto produk seed tampil (Image.asset ter-build).
    expect(find.byType(Image), findsWidgets);
    // Chip sync ringkas + judul toko.
    expect(find.text('Offline'), findsOneWidget);
    expect(find.textContaining('Warkop Kekinian'), findsOneWidget);
    await _flushDisposalTimers(tester);
  });

  testWidgets('Tanpa pita DEBUG (Banner) di CasirzApp', (tester) async {
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final db = AppDatabase.memory();
    addTearDown(db.close);
    await tester.pumpWidget(CasirzApp(db: db));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(Banner), findsNothing);
    await _flushDisposalTimers(tester);
  });

  testWidgets('Golden grid POS premium 360x780', (tester) async {
    await pumpShell(tester);
    // Beri waktu gambar aset termuat. Tanpa pumpAndSettle: di VM ini
    // pumpAndSettle tidak pernah settle dan test menggantung.
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    // Foto aset di-decode secara asinkron — precache dulu supaya
    // golden deterministik: tanpa ini, capture kadang dapat kartu
    // dengan foto masih kosong (16% piksel berbeda antar run).
    await tester.runAsync(() async {
      final context = tester.element(find.byType(Scaffold).first);
      for (final path in productPhotos.values) {
        await precacheImage(AssetImage(path), context);
      }
    });
    await tester.pump();
    await expectLater(
      find.byType(Scaffold).first,
      matchesGoldenFile('goldens/pos_grid_premium.png'),
    );
    await _flushDisposalTimers(tester);
  });
}
