// Casirz ERP — Fase 6 (Modul E Owner Command Center).
// Command Center — HANYA Owner (RBAC: MenuId.dashboard; Manager/Kasir
// melihat pesan terkunci, bukan dashboard).
//
// Isi: ringkasan hari ini (omzet, laba bersih real, transaksi,
// rata-rata/transaksi), progress BEP vs modal awal, chart jam sibuk,
// matriks menu (top-selling + margin tertinggi), alert stok bahan,
// ringkasan staf hari ini (tanpa gaji — gaji tetap di Payroll).
// Semua angka dari DashboardService (Reports.* + jurnal + sales + BOM);
// bila belum ada penjualan hari ini, grafik tampil kosong yang jujur.
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/money.dart';
import '../../shared/widgets/money_text.dart';
import '../../shared/widgets/stock_qty_text.dart';
import '../inventory/inventory_page.dart';
import '../staff/auth.dart';
import '../staff/staff_providers.dart';
import '../staff/staff_service.dart';
import 'dashboard_providers.dart';
import 'dashboard_service.dart';

/// Halaman Command Center (disebut juga Dashboard Owner).
class CommandCenterPage extends ConsumerWidget {
  const CommandCenterPage({super.key});

  StaffRole _role(WidgetRef ref) {
    final employee = ref.watch(sessionProvider).employee;
    if (employee == null) return StaffRole.owner; // DB kosong / belum login
    return roleFromString(employee.role);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = _role(ref);
    if (role != StaffRole.owner) {
      return Scaffold(
        appBar: AppBar(title: const Text('Command Center')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Menu Command Center Terkunci\n\n'
              '${MenuId.dashboard.lockedReason(role)}',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
    final dataAsync = ref.watch(dashboardDataProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Command Center'),
        actions: [
          IconButton(
            tooltip: 'Muat ulang',
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(dashboardVersionProvider.notifier).state++,
          ),
        ],
      ),
      body: dataAsync.when(
        data: (data) => _DashboardBody(data: data),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Gagal memuat dashboard: $e')),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({required this.data});
  final DashboardData data;

  @override
  Widget build(BuildContext context) {
    final today = data.today;
    final dateLabel = DateFormat(
      'EEEE, dd MMM yyyy',
      'id_ID',
    ).format(DateTime.now());
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Text(
          'Hari ini — $dateLabel',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        // ---- Ringkasan hari ini: 4 kartu.
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.9,
          children: [
            _StatCard(
              label: 'Omzet Hari Ini',
              child: MoneyText(
                today.revenue,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            _StatCard(
              label: 'Laba Bersih Real Hari Ini',
              child: MoneyText(
                today.netProfitReal,
                negativeRed: true,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            _StatCard(
              label: 'Jumlah Transaksi',
              child: Text(
                '${today.transactions}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            _StatCard(
              label: 'Rata-rata per Transaksi',
              child: MoneyText(
                today.avgPerTransaction,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Laba real = Pendapatan Bersih ${fmt(today.netRevenue)} − HPP '
          '${fmt(today.hpp)} − OPEX prorata ${fmt(today.opexDaily)} − '
          'penyusutan prorata ${fmt(today.depreciationDaily)} − amortisasi '
          'sewa prorata ${fmt(today.rentDaily)}.',
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 16),
        // ---- BEP vs modal awal.
        _SectionCard(
          title: 'Balik Modal (BEP)',
          child: _BepView(bep: data.bep),
        ),
        const SizedBox(height: 12),
        // ---- Jam sibuk.
        _SectionCard(
          title: 'Jam Sibuk Hari Ini',
          child: _BusyHoursView(hourly: data.hourly),
        ),
        const SizedBox(height: 12),
        // ---- Matriks menu.
        _SectionCard(
          title: 'Top-Selling (qty terbanyak)',
          child: _MenuList(items: data.topSelling, showQty: true),
        ),
        const SizedBox(height: 12),
        _SectionCard(
          title: 'Margin Tertinggi (per unit)',
          child: _MenuList(items: data.topMargin, showQty: false),
        ),
        const SizedBox(height: 12),
        // ---- Alert stok.
        _SectionCard(
          title: 'Alert Stok Bahan',
          trailing: _StockLinkButton(),
          child: _StockAlertsView(alerts: data.stockAlerts),
        ),
        const SizedBox(height: 12),
        // ---- Staf hari ini.
        _SectionCard(
          title: 'Staf Hari Ini',
          child: _StaffTodayView(items: data.staffToday),
        ),
        const SizedBox(height: 12),
        const Text(
          'Semua angka dihitung dari jurnal, penjualan, dan BOM — bukan '
          'angka ketik. Detail gaji ada di menu Staf → Payroll.',
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 4),
            child,
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
    this.trailing,
  });
  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

class _BepView extends StatelessWidget {
  const _BepView({required this.bep});
  final BepProgress bep;

  @override
  Widget build(BuildContext context) {
    final pct = NumberFormat('#,##0.00', 'id_ID').format(bep.percent);
    final fraction = (bep.percent / 100).clamp(0.0, 1.0);
    final estimate = bep.estimatedDate != null
        ? 'Perkiraan balik modal: ${DateFormat('dd MMM yyyy', 'id_ID').format(bep.estimatedDate!)} '
            '(dengan laju laba 30 hari terakhir).'
        : bep.cumulativeProfit >= bep.capital && bep.capital > 0
            ? 'Modal sudah kembali.'
            : !bep.hasEnoughData
                ? 'Belum cukup data untuk estimasi (butuh 30 hari data; '
                    'baru ${bep.daysOfData} hari).'
                : 'Laju laba 30 hari terakhir 0 atau negatif — belum bisa '
                    'estimasi tanggal balik modal.';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Modal awal'),
            MoneyText(bep.capital),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Laba bersih kumulatif'),
            MoneyText(bep.cumulativeProfit, negativeRed: true),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: fraction,
          minHeight: 10,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        const SizedBox(height: 4),
        Text('$pct% tercapai'),
        const SizedBox(height: 4),
        Text(estimate, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class _BusyHoursView extends StatelessWidget {
  const _BusyHoursView({required this.hourly});
  final HourlySales hourly;

  @override
  Widget build(BuildContext context) {
    if (hourly.total == 0) {
      return const SizedBox(
        height: 120,
        child: Center(
          child: Text(
            'Belum ada penjualan hari ini.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    final maxCount = hourly.counts.reduce((a, b) => a > b ? a : b);
    final peakLabel = hourly.peakHour == null
        ? ''
        : 'Jam tersibuk: ${hourly.peakHour.toString().padLeft(2, '0')}:00 '
            '(${hourly.counts[hourly.peakHour!]} transaksi).';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 180,
          child: BarChart(
            BarChartData(
              maxY: (maxCount + 1).toDouble(),
              barGroups: [
                for (var h = 0; h < 24; h++)
                  BarChartGroupData(
                    x: h,
                    barRods: [
                      BarChartRodData(
                        toY: hourly.counts[h].toDouble(),
                        color: h == hourly.peakHour
                            ? const Color(0xFF047857)
                            : const Color(0xFF059669),
                        width: 10,
                      ),
                    ],
                  ),
              ],
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (v, meta) => Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Text(
                        v.toInt().toString(),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 3,
                    getTitlesWidget: (v, meta) => Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        v.toInt().toString().padLeft(2, '0'),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                ),
              ),
              gridData: const FlGridData(show: true),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(peakLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(
          'Total ${hourly.total} transaksi hari ini.',
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

class _MenuList extends StatelessWidget {
  const _MenuList({required this.items, required this.showQty});
  final List<MenuMatrixItem> items;
  final bool showQty; // true = top-selling (qty), false = margin

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Text('Belum ada menu.');
    }
    return Column(
      children: [
        for (var i = 0; i < items.length; i++)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              radius: 14,
              child: Text('${i + 1}'),
            ),
            title: Text(items[i].name),
            subtitle: showQty
                ? Text(
                    '${items[i].qtySold} terjual • omzet '
                    '${fmt(items[i].revenue)} • HPP ${fmt(items[i].hppPerUnit)}',
                  )
                : Text(
                    'Harga ${fmt(items[i].price)} • HPP '
                    '${fmt(items[i].hppPerUnit)}',
                  ),
            trailing: showQty
                ? MoneyText(items[i].revenue)
                : MoneyText(
                    items[i].marginPerUnit,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
          ),
      ],
    );
  }
}

class _StockLinkButton extends StatelessWidget {
  const _StockLinkButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const InventoryPage()),
        );
      },
      child: const Text('Lihat Bahan Baku'),
    );
  }
}

class _StockAlertsView extends StatelessWidget {
  const _StockAlertsView({required this.alerts});
  final List<StockAlertItem> alerts;

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return const Text('Stok aman — tidak ada bahan menipis atau minus.');
    }
    return Column(
      children: [
        for (final a in alerts)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(a.ingredient.name),
            subtitle: Row(
              children: [
                StockQtyText(
                  a.ingredient.stockQty,
                  unit: a.ingredient.unit,
                  lowStockAt: a.ingredient.lowStockAt,
                ),
                if (a.isMinus) ...[
                  const SizedBox(width: 8),
                  const StokMinusBadge(),
                ],
              ],
            ),
            trailing: Text(
              a.isMinus
                  ? 'Stok Minus'
                  : 'Menipis (ambang ${fmtQty(a.ingredient.lowStockAt)} '
                      '${a.ingredient.unit})',
              style: TextStyle(
                color: a.isMinus
                    ? Theme.of(context).colorScheme.error
                    : Colors.orange.shade800,
              ),
            ),
          ),
      ],
    );
  }
}

class _StaffTodayView extends StatelessWidget {
  const _StaffTodayView({required this.items});
  final List<StaffTodayItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Text('Belum ada karyawan aktif.');
    }
    String time(int? ms) {
      if (ms == null) return '—';
      return DateFormat(
        'HH:mm',
        'id_ID',
      ).format(DateTime.fromMillisecondsSinceEpoch(ms));
    }

    return Column(
      children: [
        for (final s in items)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(s.employee.name),
            subtitle: Text(
              s.checkedIn
                  ? 'Masuk ${time(s.clockIn)}'
                      '${s.clockOut != null ? ' — pulang ${time(s.clockOut)}' : ' — belum check-out'}'
                      ' • ${fmtWorkMinutes(s.workMinutes)}'
                  : 'Belum check-in hari ini',
            ),
          ),
      ],
    );
  }
}
