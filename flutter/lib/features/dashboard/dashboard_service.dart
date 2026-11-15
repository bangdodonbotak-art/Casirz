// Casirz ERP — Fase 6 (Modul E Owner Command Center).
// Logika dashboard pemilik — SEMUA angka dari data nyata (jurnal via
// Reports.*, sales, BOM, karyawan, aset, settings). Tidak ada angka ketik.
//
// - Ringkasan hari ini: omzet = Σ total penjualan hari ini (tidak void);
//   laba bersih real = Pendapatan Bersih − HPP − OPEX prorata harian −
//   penyusutan prorata harian − amortisasi sewa prorata harian.
//   OPEX prorata = OPEX bulanan ÷ 30. OPEX bulanan = beban tetap dari
//   settings (opexListrik/opexAir/opexInternet, seed §10.2) + gaji
//   karyawan aktif bulan berjalan (bulanan = pokok; harian = tarif x
//   hari hadir bulan ini, dari StaffService.recap).
//   CATATAN JUJUR: angka ini memakai PRORATA, bukan OPEX/penyusutan/
//   amortisasi yang sudah dijurnal hari itu — itu estimasi harian yang
//   jujur dari beban bulanan, dan komponennya ditampilkan supaya pemilik
//   bisa memeriksa. OPEX yang benar-benar dibayar tetap tercatat di
//   Laba Rugi (Reports.profitLoss).
// - BEP: laba bersih KUMULATIF sejak awal (Reports.profitLoss dari
//   epoch 0) vs modal awal disetor (akun 3000, Reports.balanceSheet).
//   Estimasi tanggal BEP hanya bila ada >= 30 hari data ("dengan laju
//   laba 30 hari terakhir"); bila belum, hasEnoughData = false dan UI
//   menulis "belum cukup data" — jangan karang estimasi.
// - Jam sibuk: jumlah transaksi per jam (00–23) hari ini, dari
//   sales.date. Puncak = jam terbanyak (seri -> jam paling awal).
// - Matriks menu: Top-Selling = qty terjual terbanyak (saleLines dari
//   penjualan tidak void); Margin Tertinggi = harga − HPP per unit
//   (Bom.hppPerUnit). Masing-masing top 5; seri diurutkan nama A-Z
//   supaya urutan deterministik.
// - Alert stok: bahan minus (stockQty < 0) di urutan atas, lalu bahan
//   menipis (lowStockAt > 0 dan stockQty <= lowStockAt).
// - Staf hari ini: check-in + total jam hari ini, dari
//   StaffService.recap periode berjalan (baris hari ini saja).
//   Tanpa detail gaji di dashboard (gaji tetap di Payroll).
import 'package:drift/drift.dart';

import '../../core/accounting_service.dart';
import '../../core/bom.dart';
import '../../core/db.dart';
import '../../core/money.dart';
import '../../core/reports.dart';
import '../staff/staff_service.dart';

/// Ringkasan hari ini.
class TodaySummary {
  const TodaySummary({
    required this.revenue,
    required this.netRevenue,
    required this.hpp,
    required this.grossProfit,
    required this.opexDaily,
    required this.depreciationDaily,
    required this.rentDaily,
    required this.netProfitReal,
    required this.transactions,
    required this.avgPerTransaction,
  });
  final int revenue; // Σ sale.total hari ini (omzet, tidak void)
  final int netRevenue; // Pendapatan Bersih (Reports)
  final int hpp;
  final int grossProfit;
  final int opexDaily; // OPEX prorata harian
  final int depreciationDaily; // penyusutan prorata harian
  final int rentDaily; // amortisasi sewa prorata harian
  final int netProfitReal; // laba bersih real hari ini
  final int transactions;
  final int avgPerTransaction; // omzet / transaksi (0 bila 0 transaksi)
}

/// Progress BEP vs modal awal.
class BepProgress {
  const BepProgress({
    required this.capital,
    required this.cumulativeProfit,
    required this.percent,
    required this.hasEnoughData,
    required this.daysOfData,
    this.estimatedDate,
  });
  final int capital; // modal awal disetor (akun 3000)
  final int cumulativeProfit; // laba bersih kumulatif sejak awal
  final double percent; // cumulative / capital * 100 (0 bila modal 0)
  final bool hasEnoughData; // >= 30 hari data
  final int daysOfData; // rentang hari data penjualan (0 bila belum ada)
  /// Perkiraan tanggal BEP (null bila belum cukup data / laju <= 0 /
  /// sudah tercapai).
  final DateTime? estimatedDate;
}

/// Penjualan per jam hari ini.
class HourlySales {
  const HourlySales({
    required this.counts,
    required this.revenue,
    required this.peakHour,
    required this.total,
  });
  final List<int> counts; // 24 angka: transaksi jam 00..23
  final List<int> revenue; // 24 angka: omzet jam 00..23
  final int? peakHour; // null bila belum ada penjualan hari ini
  final int total;
}

/// Satu baris matriks menu.
class MenuMatrixItem {
  const MenuMatrixItem({
    required this.productId,
    required this.name,
    required this.qtySold,
    required this.revenue,
    required this.price,
    required this.hppPerUnit,
  });
  final String productId;
  final String name;
  final int qtySold; // 0 bila belum pernah terjual (matriks margin)
  final int revenue;
  final int price;
  final int hppPerUnit;
  int get marginPerUnit => price - hppPerUnit;
}

/// Satu alert stok bahan.
class StockAlertItem {
  const StockAlertItem({required this.ingredient, required this.isMinus});
  final Ingredient ingredient;
  final bool isMinus; // true = stok minus (di atas), false = menipis
}

/// Absensi satu karyawan hari ini.
class StaffTodayItem {
  const StaffTodayItem({
    required this.employee,
    required this.checkedIn,
    required this.clockIn,
    required this.clockOut,
    required this.workMinutes,
  });
  final Employee employee;
  final bool checkedIn;
  final int? clockIn; // epoch ms
  final int? clockOut; // epoch ms
  final int workMinutes; // 0 bila belum check-out (jangan dikarang)
}

/// Semua data Command Center dalam satu muatan (untuk UI).
class DashboardData {
  const DashboardData({
    required this.today,
    required this.bep,
    required this.hourly,
    required this.topSelling,
    required this.topMargin,
    required this.stockAlerts,
    required this.staffToday,
  });
  final TodaySummary today;
  final BepProgress bep;
  final HourlySales hourly;
  final List<MenuMatrixItem> topSelling;
  final List<MenuMatrixItem> topMargin;
  final List<StockAlertItem> stockAlerts;
  final List<StaffTodayItem> staffToday;
}

class DashboardService {
  /// Awal hari lokal [day] (00:00) sebagai DateTime.
  static DateTime dayStart(DateTime day) =>
      DateTime(day.year, day.month, day.day);

  /// Akhir hari lokal [day] (23:59:59.999) sebagai DateTime.
  static DateTime dayEnd(DateTime day) =>
      DateTime(day.year, day.month, day.day, 23, 59, 59, 999);

  /// OPEX bulanan (Rp): beban tetap settings + gaji karyawan aktif
  /// bulan berjalan. Harian = tarif x hari hadir bulan ini.
  static Future<int> monthlyOpexEstimate(
    AppDatabase db, {
    DateTime? now,
  }) async {
    final settings = await db.select(db.settings).get();
    final map = {for (final s in settings) s.id: s.value};
    final utilities = (int.tryParse(map['opexListrik'] ?? '0') ?? 0) +
        (int.tryParse(map['opexAir'] ?? '0') ?? 0) +
        (int.tryParse(map['opexInternet'] ?? '0') ?? 0);
    final day = now ?? DateTime.now();
    final period = currentPeriod(day);
    final employees = await (db.select(db.employees)
          ..where((e) => e.isActive.equals(1) & e.isDeleted.equals(0)))
        .get();
    var salaries = 0;
    for (final e in employees) {
      if (e.salaryType == 'harian') {
        final recap = await StaffService.recap(db, e.id, period);
        salaries += e.baseSalary * recap.daysPresent;
      } else {
        salaries += e.baseSalary;
      }
    }
    return utilities + salaries;
  }

  /// Komponen prorata harian (Rp): OPEX ÷ 30, penyusutan ÷ 30,
  /// amortisasi sewa ÷ 30.
  static Future<({int opex, int depreciation, int rent})> dailyProrata(
    AppDatabase db, {
    DateTime? now,
  }) async {
    final monthlyOpex = await monthlyOpexEstimate(db, now: now);
    final opex = toIntRp(monthlyOpex / 30);
    // Penyusutan: jumlah penyusutan bulanan semua aset yang masih
    // punya sisa nilai untuk disusutkan, ÷ 30.
    final assets = await (db.select(db.assets)
          ..where((a) => a.isDeleted.equals(0)))
        .get();
    var monthlyDep = 0;
    for (final a in assets) {
      final remaining =
          a.cost - a.residualValue - a.accumulatedDepreciation;
      if (remaining <= 0) continue;
      final monthly = AccountingService.monthlyDepreciationAmount(
        cost: a.cost,
        residualValue: a.residualValue,
        usefulLifeMonths: a.usefulLifeMonths,
      );
      monthlyDep += monthly >= remaining ? remaining : monthly;
    }
    final depreciation = toIntRp(monthlyDep / 30);
    // Amortisasi sewa: rentTotal ÷ rentMonths ÷ 30 (0 bila belum diatur).
    final rentTotal =
        int.tryParse(await db.getSetting('rentTotal') ?? '') ?? 0;
    final rentMonths =
        int.tryParse(await db.getSetting('rentMonths') ?? '') ?? 0;
    final rent = rentTotal > 0 && rentMonths > 0
        ? toIntRp((rentTotal / rentMonths) / 30)
        : 0;
    return (opex: opex, depreciation: depreciation, rent: rent);
  }

  /// Ringkasan hari ini.
  static Future<TodaySummary> todaySummary(
    AppDatabase db, {
    DateTime? now,
  }) async {
    final day = now ?? DateTime.now();
    final pl = await Reports.profitLoss(db, dayStart(day), dayEnd(day));
    final sales = await (db.select(db.sales)
          ..where(
            (s) =>
                s.date.isBiggerOrEqualValue(
                  dayStart(day).millisecondsSinceEpoch,
                ) &
                s.date.isSmallerOrEqualValue(
                  dayEnd(day).millisecondsSinceEpoch,
                ) &
                s.voided.equals(0),
          ))
        .get();
    var revenue = 0;
    for (final s in sales) {
      revenue += s.total;
    }
    final prorata = await dailyProrata(db, now: day);
    final netReal = pl.netRevenue -
        pl.hpp -
        prorata.opex -
        prorata.depreciation -
        prorata.rent;
    final count = sales.length;
    return TodaySummary(
      revenue: revenue,
      netRevenue: pl.netRevenue,
      hpp: pl.hpp,
      grossProfit: pl.grossProfit,
      opexDaily: prorata.opex,
      depreciationDaily: prorata.depreciation,
      rentDaily: prorata.rent,
      netProfitReal: netReal,
      transactions: count,
      avgPerTransaction: count == 0 ? 0 : revenue ~/ count,
    );
  }

  /// Progress BEP vs modal awal.
  static Future<BepProgress> bepProgress(
    AppDatabase db, {
    DateTime? now,
  }) async {
    final day = now ?? DateTime.now();
    final bs = await Reports.balanceSheet(db, day);
    final capital = bs.capital;
    final cumulative = (await Reports.profitLoss(
      db,
      DateTime.fromMillisecondsSinceEpoch(0),
      day,
    ))
        .netProfit;
    final percent = capital == 0 ? 0.0 : cumulative / capital * 100;
    // Rentang data: dari penjualan pertama sampai hari ini.
    final firstSale = await (db.select(db.sales)
          ..orderBy([(s) => OrderingTerm.asc(s.date)])
          ..limit(1))
        .getSingleOrNull();
    final daysOfData = firstSale == null
        ? 0
        : day
            .difference(
              DateTime.fromMillisecondsSinceEpoch(firstSale.date),
            )
            .inDays;
    final hasEnoughData = daysOfData >= 30;
    DateTime? estimated;
    if (hasEnoughData && cumulative < capital) {
      final from30 = day.subtract(const Duration(days: 30));
      final pl30 = await Reports.profitLoss(db, from30, day);
      final dailyRate = pl30.netProfit / 30;
      if (dailyRate > 0) {
        final daysLeft =
            ((capital - cumulative) / dailyRate).ceil();
        estimated = day.add(Duration(days: daysLeft));
      }
    }
    return BepProgress(
      capital: capital,
      cumulativeProfit: cumulative,
      percent: percent,
      hasEnoughData: hasEnoughData,
      daysOfData: daysOfData,
      estimatedDate: estimated,
    );
  }

  /// Penjualan per jam hari ini (00–23).
  static Future<HourlySales> hourlySales(
    AppDatabase db, {
    DateTime? now,
  }) async {
    final day = now ?? DateTime.now();
    final sales = await (db.select(db.sales)
          ..where(
            (s) =>
                s.date.isBiggerOrEqualValue(
                  dayStart(day).millisecondsSinceEpoch,
                ) &
                s.date.isSmallerOrEqualValue(
                  dayEnd(day).millisecondsSinceEpoch,
                ) &
                s.voided.equals(0),
          ))
        .get();
    final counts = List<int>.filled(24, 0);
    final revenue = List<int>.filled(24, 0);
    for (final s in sales) {
      final hour = DateTime.fromMillisecondsSinceEpoch(s.date).hour;
      counts[hour]++;
      revenue[hour] += s.total;
    }
    int? peak;
    var peakCount = 0;
    for (var h = 0; h < 24; h++) {
      if (counts[h] > peakCount) {
        peakCount = counts[h];
        peak = h;
      }
    }
    return HourlySales(
      counts: counts,
      revenue: revenue,
      peakHour: peak,
      total: sales.length,
    );
  }

  /// Matriks menu: top-selling (qty) + margin tertinggi (harga − HPP).
  static Future<({List<MenuMatrixItem> topSelling, List<MenuMatrixItem> topMargin})>
      menuMatrix(AppDatabase db) async {
    final products = await (db.select(db.products)
          ..where((p) => p.isActive.equals(1) & p.isDeleted.equals(0)))
        .get();
    // Qty + omzet dari penjualan tidak void.
    final sales = await (db.select(db.sales)
          ..where((s) => s.voided.equals(0)))
        .get();
    final saleIds = sales.map((s) => s.id).toSet();
    final qtyByProduct = <String, int>{};
    final revenueByProduct = <String, int>{};
    if (saleIds.isNotEmpty) {
      final lines = await (db.select(db.saleLines)
            ..where((l) => l.saleId.isIn(saleIds)))
          .get();
      for (final l in lines) {
        qtyByProduct[l.productId] =
            (qtyByProduct[l.productId] ?? 0) + l.qty;
        revenueByProduct[l.productId] =
            (revenueByProduct[l.productId] ?? 0) + l.price * l.qty;
      }
    }
    final items = <MenuMatrixItem>[];
    for (final p in products) {
      final hpp = await Bom.hppPerUnit(db, p.id);
      items.add(
        MenuMatrixItem(
          productId: p.id,
          name: p.name,
          qtySold: qtyByProduct[p.id] ?? 0,
          revenue: revenueByProduct[p.id] ?? 0,
          price: p.price,
          hppPerUnit: hpp,
        ),
      );
    }
    // Top-selling: qty terbanyak; seri -> nama A-Z.
    final byQty = List<MenuMatrixItem>.of(items)
      ..sort((a, b) {
        final c = b.qtySold.compareTo(a.qtySold);
        return c != 0 ? c : a.name.compareTo(b.name);
      });
    // Margin tertinggi: margin per unit terbanyak; seri -> nama A-Z.
    final byMargin = List<MenuMatrixItem>.of(items)
      ..sort((a, b) {
        final c = b.marginPerUnit.compareTo(a.marginPerUnit);
        return c != 0 ? c : a.name.compareTo(b.name);
      });
    return (
      topSelling: byQty.take(5).toList(),
      topMargin: byMargin.take(5).toList(),
    );
  }

  /// Alert stok: bahan minus dulu, lalu menipis. Kosong = stok aman.
  static Future<List<StockAlertItem>> stockAlerts(AppDatabase db) async {
    final ingredients = await (db.select(db.ingredients)
          ..where((i) => i.isDeleted.equals(0))
          ..orderBy([(i) => OrderingTerm.asc(i.name)]))
        .get();
    final out = <StockAlertItem>[];
    for (final ing in ingredients) {
      if (ing.stockQty < 0) {
        out.add(StockAlertItem(ingredient: ing, isMinus: true));
      } else if (ing.lowStockAt > 0 && ing.stockQty <= ing.lowStockAt) {
        out.add(StockAlertItem(ingredient: ing, isMinus: false));
      }
    }
    // Minus di atas (sudah urut nama di tiap kelompok karena query).
    out.sort((a, b) {
      if (a.isMinus != b.isMinus) return a.isMinus ? -1 : 1;
      return a.ingredient.name.compareTo(b.ingredient.name);
    });
    return out;
  }

  /// Staf hari ini: siapa check-in + total jam (dari recap periode).
  static Future<List<StaffTodayItem>> staffToday(
    AppDatabase db, {
    DateTime? now,
  }) async {
    final day = now ?? DateTime.now();
    final period = currentPeriod(day);
    final employees = await (db.select(db.employees)
          ..where((e) => e.isActive.equals(1) & e.isDeleted.equals(0))
          ..orderBy([(e) => OrderingTerm.asc(e.name)]))
        .get();
    final out = <StaffTodayItem>[];
    for (final e in employees) {
      final recap = await StaffService.recap(db, e.id, period);
      final todayRow = recap.rows.where(
        (r) => r.date == dayStartMs(day),
      );
      final row = todayRow.isEmpty ? null : todayRow.first;
      out.add(
        StaffTodayItem(
          employee: e,
          checkedIn: row?.clockIn != null,
          clockIn: row?.clockIn,
          clockOut: row?.clockOut,
          workMinutes: row == null ? 0 : StaffService.workMinutes(row),
        ),
      );
    }
    // Yang check-in dulu, lalu nama A-Z.
    out.sort((a, b) {
      if (a.checkedIn != b.checkedIn) return a.checkedIn ? -1 : 1;
      return a.employee.name.compareTo(b.employee.name);
    });
    return out;
  }

  /// Semua data Command Center sekaligus (satu panggilan untuk UI).
  static Future<DashboardData> load(AppDatabase db, {DateTime? now}) async {
    final day = now ?? DateTime.now();
    final today = await todaySummary(db, now: day);
    final bep = await bepProgress(db, now: day);
    final hourly = await hourlySales(db, now: day);
    final matrix = await menuMatrix(db);
    final alerts = await stockAlerts(db);
    final staff = await staffToday(db, now: day);
    return DashboardData(
      today: today,
      bep: bep,
      hourly: hourly,
      topSelling: matrix.topSelling,
      topMargin: matrix.topMargin,
      stockAlerts: alerts,
      staffToday: staff,
    );
  }
}
