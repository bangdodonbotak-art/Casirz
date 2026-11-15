// Casirz ERP — Fase 2.
// Riverpod providers: database, settings, produk, shift, keranjang,
// printer, sync. UI hanya bicara ke provider ini — tidak ke Drift
// langsung untuk tulis (tulis lewat service).
import 'package:drift/drift.dart' hide isNull;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/bom.dart';
import '../../core/db.dart';
import '../../core/printer/esc_pos_printer.dart';
import '../../core/printer/printer_port.dart';
import '../../core/supabase_config.dart';
import '../../core/sync.dart';
import '../../core/sync_engine.dart';
import 'cart.dart';

// ---------------------------------------------------------------------------
// Database + sync + printer (di-override di main / test)
// ---------------------------------------------------------------------------

final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError(
    'databaseProvider harus di-override di main.dart (AppDatabase.open()).',
  );
});

/// Engine sync Fase 7: aktif bila config Supabase terisi (via
/// --dart-define SUPABASE_URL + SUPABASE_ANON_KEY); bila kosong, engine
/// NONAKTIF (tidak mencoba koneksi apa pun) dan UI menampilkan
/// "Sinkronisasi belum diaktifkan". Data tetap aman di HP.
final syncEngineProvider = Provider<SyncEngine>((ref) {
  final db = ref.watch(databaseProvider);
  final config = SupabaseConfig.fromEnvironment();
  if (!config.isConfigured) return RealSyncEngine(db);
  return RealSyncEngine(db, transport: SupabaseTransport(config));
});

final syncStatusProvider = StreamProvider<SyncStatus>((ref) {
  return ref.watch(syncEngineProvider).statusStream;
});

final printerPortProvider = Provider<PrinterPort>((ref) {
  return EscPosPrinterPort();
});

// ---------------------------------------------------------------------------
// Settings (key-value). Di-refresh dengan menaikkan settingsVersion.
// ---------------------------------------------------------------------------

final settingsVersionProvider = StateProvider<int>((ref) => 0);

final settingsMapProvider = FutureProvider<Map<String, String>>((ref) async {
  ref.watch(settingsVersionProvider);
  final db = ref.watch(databaseProvider);
  final rows = await db.select(db.settings).get();
  return {for (final r in rows) r.id: r.value};
});

/// Semua setting kasir dalam satu objek (default = aturan beku).
class PosSettings {
  PosSettings.fromMap(Map<String, String> m)
      : storeName = m['storeName'] ?? 'Casirz',
        ppnEnabled = m['ppnEnabled'] == '1',
        ppnRate = int.tryParse(m['ppnRate'] ?? '11') ?? 11,
        serviceRate = int.tryParse(m['serviceChargeRate'] ?? '0') ?? 0,
        pb1Rate = int.tryParse(m['pb1Rate'] ?? '0') ?? 0,
        ojolFeeGoFood = int.tryParse(m['ojolFeeGoFood'] ?? '0') ?? 0,
        ojolFeeGrabFood = int.tryParse(m['ojolFeeGrabFood'] ?? '0') ?? 0,
        ojolFeeShopeeFood =
            int.tryParse(m['ojolFeeShopeeFood'] ?? '0') ?? 0,
        ojolMarkupGoFood =
            int.tryParse(m['ojolMarkupGoFood'] ?? '0') ?? 0,
        ojolMarkupGrabFood =
            int.tryParse(m['ojolMarkupGrabFood'] ?? '0') ?? 0,
        ojolMarkupShopeeFood =
            int.tryParse(m['ojolMarkupShopeeFood'] ?? '0') ?? 0,
        paperWidth = m['receiptPaperWidth'] == '58' ? '58' : '80',
        opexListrik = int.tryParse(m['opexListrik'] ?? '0') ?? 0,
        opexAir = int.tryParse(m['opexAir'] ?? '0') ?? 0,
        opexInternet = int.tryParse(m['opexInternet'] ?? '0') ?? 0,
        workStartTime = m['workStartTime'] ?? '08:00',
        themeMode = m['themeMode'] == 'dark' ? ThemeMode.dark : ThemeMode.light;

  final String storeName;
  final bool ppnEnabled;
  final int ppnRate;
  final int serviceRate;
  final int pb1Rate;
  final int ojolFeeGoFood;
  final int ojolFeeGrabFood;
  final int ojolFeeShopeeFood;
  final int ojolMarkupGoFood;
  final int ojolMarkupGrabFood;
  final int ojolMarkupShopeeFood;
  final String paperWidth; // '58' | '80'
  /// Beban bulanan tetap (Rp/bulan, BLUEPRINT §10.2) — dipakai
  /// Command Center untuk OPEX prorata harian (÷ 30). Gaji TIDAK di
  /// sini: gaji dihitung dari karyawan aktif (lihat DashboardService).
  /// Seed mengisi 1.000.000 / 200.000 / 500.000; 0 = belum diatur.
  final int opexListrik;
  final int opexAir;
  final int opexInternet;
  /// Jam masuk untuk definisi telat absensi ('HH:mm', default '08:00').
  final String workStartTime;
  final ThemeMode themeMode;

  int ojolFeeFor(String? platform) {
    switch (platform) {
      case 'GoFood':
        return ojolFeeGoFood;
      case 'GrabFood':
        return ojolFeeGrabFood;
      case 'ShopeeFood':
        return ojolFeeShopeeFood;
      default:
        return 0;
    }
  }

  int ojolMarkupFor(String? platform) {
    switch (platform) {
      case 'GoFood':
        return ojolMarkupGoFood;
      case 'GrabFood':
        return ojolMarkupGrabFood;
      case 'ShopeeFood':
        return ojolMarkupShopeeFood;
      default:
        return 0;
    }
  }
}

final posSettingsProvider = FutureProvider<PosSettings>((ref) async {
  final map = await ref.watch(settingsMapProvider.future);
  return PosSettings.fromMap(map);
});

// ---------------------------------------------------------------------------
// Tema (StateProvider — diinisialisasi dari settings di main)
// ---------------------------------------------------------------------------

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

// ---------------------------------------------------------------------------
// Master data (stream langsung dari Drift)
// ---------------------------------------------------------------------------

final productsProvider = StreamProvider<List<Product>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.products)
        ..where((p) => p.isActive.equals(1) & p.isDeleted.equals(0))
        ..orderBy([(p) => OrderingTerm.asc(p.category), (p) => OrderingTerm.asc(p.name)]))
      .watch();
});

final employeesProvider = StreamProvider<List<Employee>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.employees)
        ..where((e) => e.isActive.equals(1) & e.isDeleted.equals(0))
        ..orderBy([(e) => OrderingTerm.asc(e.name)]))
      .watch();
});

final customersProvider = StreamProvider<List<Customer>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.customers)
        ..where((c) => c.isDeleted.equals(0))
        ..orderBy([(c) => OrderingTerm.asc(c.name)]))
      .watch();
});

final promosProvider = StreamProvider<List<Promo>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.promos)
        ..where((p) => p.isActive.equals(1) & p.isDeleted.equals(0)))
      .watch();
});

final tablesProvider = StreamProvider<List<ShopTable>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.shopTables)
        ..where((t) => t.isDeleted.equals(0))
        ..orderBy([(t) => OrderingTerm.asc(t.name)]))
      .watch();
});

final openOrdersProvider = StreamProvider<List<Order>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.orders)
        ..where((o) => o.status.equals('open') & o.isDeleted.equals(0))
        ..orderBy([(o) => OrderingTerm.desc(o.updatedAt)]))
      .watch();
});

/// HPP estimasi per produk (tampil di kartu menu — BUKAN angka final;
/// final dihitung engine di dalam transaksi, BLUEPRINT §4.3).
final hppProvider = FutureProvider.family<int, String>((ref, productId) async {
  final db = ref.watch(databaseProvider);
  return Bom.computeHPP(db, productId, 1);
});

/// True bila produk memakai bahan yang stoknya minus, atau (produk
/// tanpa BOM) stok pcs-nya minus. Badge "Stok Minus" di kartu menu.
final productStockMinusProvider =
    FutureProvider.family<bool, String>((ref, productId) async {
  final db = ref.watch(databaseProvider);
  final product = await (db.select(db.products)
        ..where((p) => p.id.equals(productId)))
      .getSingleOrNull();
  if (product == null) return false;
  final recipe = await (db.select(db.recipes)
        ..where(
          (r) => r.productId.equals(productId) & r.isDeleted.equals(0),
        ))
      .getSingleOrNull();
  if (recipe == null) return product.stock < 0;
  final lines = await (db.select(db.recipeLines)
        ..where(
          (l) => l.recipeId.equals(recipe.id) & l.isDeleted.equals(0),
        ))
      .get();
  for (final line in lines) {
    final ing = await (db.select(db.ingredients)
          ..where((i) => i.id.equals(line.ingredientId)))
        .getSingleOrNull();
    if (ing != null && ing.stockQty < 0) return true;
  }
  return false;
});

/// 3 produk dengan qty terjual terbanyak (tidak void) = HERO.
final heroProductIdsProvider = FutureProvider<Set<String>>((ref) async {
  final db = ref.watch(databaseProvider);
  final sales = await (db.select(db.sales)
        ..where((s) => s.voided.equals(0)))
      .get();
  if (sales.isEmpty) return <String>{};
  final saleIds = sales.map((s) => s.id).toSet();
  final lines = await (db.select(db.saleLines)
        ..where((l) => l.saleId.isIn(saleIds)))
      .get();
  final qtyByProduct = <String, int>{};
  for (final l in lines) {
    qtyByProduct[l.productId] = (qtyByProduct[l.productId] ?? 0) + l.qty;
  }
  final sorted = qtyByProduct.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  return sorted.take(3).map((e) => e.key).toSet();
});

// ---------------------------------------------------------------------------
// Shift aktif (di-refresh via shiftVersion)
// ---------------------------------------------------------------------------

final shiftVersionProvider = StateProvider<int>((ref) => 0);

final activeShiftProvider = FutureProvider<Shift?>((ref) async {
  ref.watch(shiftVersionProvider);
  final db = ref.watch(databaseProvider);
  final rows = await (db.select(db.shifts)
        ..where((s) => s.status.equals('open'))
        ..orderBy([(s) => OrderingTerm.desc(s.openedAt)]))
      .get();
  return rows.isEmpty ? null : rows.first;
});

// ---------------------------------------------------------------------------
// Keranjang kasir
// ---------------------------------------------------------------------------

class PosCartState {
  const PosCartState({
    this.lines = const [],
    this.discountRp = 0,
    this.promoCode,
    this.promoPercent = 0,
    this.promoFixedRp = 0,
    this.ppnEnabled = false,
    this.serviceRate = 0,
    this.pb1Rate = 0,
    this.channel = 'dine-in',
    this.ojolPlatform,
    this.customerId,
    this.orderId,
    this.tableName,
  });

  final List<CartLine> lines;
  final int discountRp;
  final String? promoCode;
  final int promoPercent;
  final int promoFixedRp;
  final bool ppnEnabled;
  final int serviceRate;
  final int pb1Rate;
  final String channel; // 'dine-in' | 'takeaway' | 'ojol'
  final String? ojolPlatform; // 'GoFood' | 'GrabFood' | 'ShopeeFood'
  final String? customerId;
  final String? orderId; // open bill yang sedang dibayar (null = langsung)
  final String? tableName;

  PosCartState copyWith({
    List<CartLine>? lines,
    int? discountRp,
    String? promoCode,
    int? promoPercent,
    int? promoFixedRp,
    bool? ppnEnabled,
    int? serviceRate,
    int? pb1Rate,
    String? channel,
    String? ojolPlatform,
    String? customerId,
    String? orderId,
    String? tableName,
    bool clearPromo = false,
    bool clearCustomer = false,
    bool clearOrder = false,
    bool clearPlatform = false,
  }) {
    return PosCartState(
      lines: lines ?? this.lines,
      discountRp: discountRp ?? this.discountRp,
      promoCode: clearPromo ? null : (promoCode ?? this.promoCode),
      promoPercent: clearPromo ? 0 : (promoPercent ?? this.promoPercent),
      promoFixedRp: clearPromo ? 0 : (promoFixedRp ?? this.promoFixedRp),
      ppnEnabled: ppnEnabled ?? this.ppnEnabled,
      serviceRate: serviceRate ?? this.serviceRate,
      pb1Rate: pb1Rate ?? this.pb1Rate,
      channel: channel ?? this.channel,
      ojolPlatform: clearPlatform ? null : (ojolPlatform ?? this.ojolPlatform),
      customerId: clearCustomer ? null : (customerId ?? this.customerId),
      orderId: clearOrder ? null : (orderId ?? this.orderId),
      tableName: tableName ?? this.tableName,
    );
  }

  CartTotals totals(PosSettings settings) {
    final markup = channel == 'ojol'
        ? settings.ojolMarkupFor(ojolPlatform)
        : 0;
    final fee = channel == 'ojol' ? settings.ojolFeeFor(ojolPlatform) : 0;
    return computeTotals(
      lines: lines,
      discountRp: discountRp,
      promoPercent: promoPercent,
      promoFixedRp: promoFixedRp,
      ppnEnabled: ppnEnabled,
      ppnRate: settings.ppnRate,
      serviceRate: serviceRate,
      pb1Rate: pb1Rate,
      markupPercent: markup,
      ojolFeePercent: fee,
    );
  }
}

class CartNotifier extends StateNotifier<PosCartState> {
  CartNotifier() : super(const PosCartState());

  void addProduct({
    required Product product,
    required int hppPerUnit,
    List<CartModifier> modifiers = const [],
    String note = '',
  }) {
    final lines = List<CartLine>.of(state.lines);
    // Baris yang sama (produk + modifier + catatan sama) digabung qty.
    final idx = lines.indexWhere(
      (l) =>
          l.productId == product.id &&
          l.modifierLabel ==
              modifiers.map((m) => m.name).join(', ') &&
          l.note == note,
    );
    if (idx >= 0) {
      lines[idx] = lines[idx].copy()..qty = lines[idx].qty + 1;
    } else {
      lines.add(
        CartLine(
          productId: product.id,
          name: product.name,
          basePrice: product.price,
          qty: 1,
          modifiers: List.of(modifiers),
          note: note,
          hppPerUnit: hppPerUnit,
        ),
      );
    }
    state = state.copyWith(lines: lines);
  }

  void setQty(int index, int qty) {
    final lines = List<CartLine>.of(state.lines);
    if (qty <= 0) {
      lines.removeAt(index);
    } else {
      lines[index] = lines[index].copy()..qty = qty;
    }
    state = state.copyWith(lines: lines);
  }

  void removeLine(int index) {
    final lines = List<CartLine>.of(state.lines)..removeAt(index);
    state = state.copyWith(lines: lines);
  }

  void setLineNote(int index, String note) {
    final lines = List<CartLine>.of(state.lines);
    lines[index] = lines[index].copy()..note = note;
    state = state.copyWith(lines: lines);
  }

  void setLineModifiers(int index, List<CartModifier> modifiers) {
    final lines = List<CartLine>.of(state.lines);
    lines[index] = lines[index].copy()..modifiers = List.of(modifiers);
    state = state.copyWith(lines: lines);
  }

  void setDiscount(int v) => state = state.copyWith(discountRp: v < 0 ? 0 : v);

  void applyPromo(Promo promo) {
    state = state.copyWith(
      promoCode: promo.code,
      promoPercent: promo.type == 'persen' ? promo.value : 0,
      promoFixedRp: promo.type == 'potongan' ? promo.value : 0,
    );
  }

  void clearPromo() => state = state.copyWith(clearPromo: true);

  void setPpn(bool v) => state = state.copyWith(ppnEnabled: v);
  void setServiceRate(int v) => state = state.copyWith(serviceRate: v);
  void setPb1Rate(int v) => state = state.copyWith(pb1Rate: v);

  void setChannel(String channel, {String? platform}) {
    state = state.copyWith(
      channel: channel,
      ojolPlatform: platform,
      clearPlatform: platform == null && channel != 'ojol',
    );
  }

  void setCustomer(String? customerId) {
    state = state.copyWith(
      customerId: customerId,
      clearCustomer: customerId == null,
    );
  }

  /// Muat open bill ke keranjang (untuk dibayar).
  void loadFromOrder({
    required String orderId,
    required String? tableName,
    required String channel,
    String? ojolPlatform,
    required List<CartLine> lines,
  }) {
    state = PosCartState(
      lines: lines,
      orderId: orderId,
      tableName: tableName,
      channel: channel,
      ojolPlatform: ojolPlatform,
    );
  }

  void clear() => state = const PosCartState();
}

final cartProvider =
    StateNotifierProvider<CartNotifier, PosCartState>((ref) {
  return CartNotifier();
});

// ---------------------------------------------------------------------------
// Transaksi (filter tanggal + metode) — dipakai halaman Transaksi
// ---------------------------------------------------------------------------

class SalesFilter {
  const SalesFilter({this.method = 'semua', this.days = 30});
  final String method; // 'semua' | 'tunai' | 'qris' | 'ojol' | 'multi'
  final int days; // 0 = semua waktu
}

final salesFilterProvider = StateProvider<SalesFilter>((ref) {
  return const SalesFilter();
});

final salesListProvider = FutureProvider<List<Sale>>((ref) async {
  final db = ref.watch(databaseProvider);
  final filter = ref.watch(salesFilterProvider);
  final query = db.select(db.sales)
    ..orderBy([(s) => OrderingTerm.desc(s.date)]);
  if (filter.method != 'semua') {
    query.where((s) => s.paymentMethod.equals(filter.method));
  }
  if (filter.days > 0) {
    final from = DateTime.now()
        .subtract(Duration(days: filter.days))
        .millisecondsSinceEpoch;
    query.where((s) => s.date.isBiggerOrEqualValue(from));
  }
  return query.get();
});
