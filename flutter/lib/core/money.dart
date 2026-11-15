// Casirz ERP — Fase 1 Core Engine.
// Uang = integer Rupiah di semua perhitungan (BLUEPRINT-FLUTTER.md §4.1).
// Tidak ada float untuk uang. Kuantitas bahan dibulatkan 3 desimal.
import 'package:intl/intl.dart';

/// Membulatkan angka menjadi integer Rupiah (round half away from zero).
int toIntRp(num n) => n.round();

/// Membulatkan kuantitas bahan ke 3 desimal (gram/ml/pcs).
/// Jangan pernah menyimpan 0.30000000000000004.
double round3(double n) => (n * 1000).round() / 1000;

/// Format uang: 'Rp1.500.000' (id_ID, 0 desimal).
String fmt(int n) => NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(n);

/// Format kuantitas bahan: maksimal 3 desimal, nol akhir dipangkas.
/// Contoh: 1500 -> '1.500', 250 -> '250', 0.5 -> '0,5'.
String fmtQty(double n) =>
    NumberFormat('#,##0.###', 'id_ID').format(round3(n));
