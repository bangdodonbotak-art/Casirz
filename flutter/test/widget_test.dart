// Smoke test Fase 2 — aplikasi bisa di-pump + shell tampil.
import 'package:casirz/app.dart';
import 'package:casirz/core/db.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });
  testWidgets('App shell Fase 2 tampil: Kasir + Meja', (tester) async {
    final db = AppDatabase.memory();
    await tester.pumpWidget(CasirzApp(db: db));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Kasir'), findsWidgets);
    expect(find.text('Transaksi'), findsWidgets);
    // Pindah ke tab Meja.
    await tester.tap(find.text('Meja').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Tambah Meja'), findsOneWidget);
    await db.close();
  });

  testWidgets('Fase 3: Lainnya -> Bahan Baku membuka halaman inventory',
      (tester) async {
    final db = AppDatabase.memory();
    await tester.pumpWidget(CasirzApp(db: db));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(find.text('Lainnya').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Bahan Baku'), findsWidgets);
    await tester.tap(find.text('Bahan Baku').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    // 5 tab modul B tampil.
    expect(find.text('Resep'), findsOneWidget);
    expect(find.text('Belanja'), findsOneWidget);
    expect(find.text('Wastage'), findsOneWidget);
    expect(find.text('Opname'), findsOneWidget);
    await db.close();
  });

  testWidgets('Fase 4: Lainnya -> Akuntansi membuka hub akuntansi',
      (tester) async {
    final db = AppDatabase.memory();
    await tester.pumpWidget(CasirzApp(db: db));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(find.text('Lainnya').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Akuntansi'), findsWidgets);
    await tester.tap(find.text('Akuntansi').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Modal Awal & Saldo Awal'), findsOneWidget);
    expect(find.text('Aset Tetap'), findsOneWidget);
    expect(find.text('Beban OPEX'), findsOneWidget);
    expect(find.text('Jurnal & Buku Besar'), findsOneWidget);
    expect(find.text('Laporan Keuangan'), findsOneWidget);
    await db.close();
  });

  testWidgets('Fase 4: Lainnya -> Laporan membuka laporan keuangan',
      (tester) async {
    final db = AppDatabase.memory();
    await tester.pumpWidget(CasirzApp(db: db));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(find.text('Lainnya').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(find.text('Laporan').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Laba Rugi'), findsOneWidget);
    expect(find.text('Neraca'), findsOneWidget);
    expect(find.text('Arus Kas'), findsOneWidget);
    expect(find.text('Bulan Ini'), findsOneWidget);
    await db.close();
  });
}
