// Casirz ERP — Fase 6 (Modul E Owner Command Center).
// Provider Riverpod untuk data dashboard (hanya Owner — dijaga
// halaman + shell, lihat auth.dart MenuId.dashboard).
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pos/pos_providers.dart';
import 'dashboard_service.dart';

/// Dinaikkan untuk me-refresh data Command Center.
final dashboardVersionProvider = StateProvider<int>((ref) => 0);

/// Semua data Command Center (di-hitung dari DB lokal, bukan angka ketik).
final dashboardDataProvider = FutureProvider<DashboardData>((ref) async {
  ref.watch(dashboardVersionProvider);
  final db = ref.watch(databaseProvider);
  return DashboardService.load(db);
});
