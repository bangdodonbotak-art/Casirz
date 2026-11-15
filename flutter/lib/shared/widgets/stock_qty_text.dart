// Casirz ERP — Fase 2.
// Aturan tampil stok minus (BLUEPRINT-FLUTTER.md §6.5): angka minus
// WARNA MERAH + badge "Stok Minus". Satu widget = satu sumber kebenaran
// visual, dipakai semua layar (kasir, bahan Fase 3, dst).
import 'package:flutter/material.dart';

import '../../core/money.dart';

/// Teks kuantitas bahan: merah bila < 0, oranye bila <= ambang menipis.
class StockQtyText extends StatelessWidget {
  const StockQtyText(
    this.qty, {
    super.key,
    required this.unit,
    this.lowStockAt = 0,
    this.style,
  });
  final double qty;
  final String unit;
  final double lowStockAt;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final color = qty < 0
        ? Colors.red
        : (lowStockAt > 0 && qty <= lowStockAt ? Colors.orange : null);
    return Text(
      '${fmtQty(qty)} $unit',
      style: (style ?? const TextStyle()).copyWith(
        color: color,
        fontWeight: qty < 0 ? FontWeight.bold : style?.fontWeight,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}

/// Badge merah "Stok Minus" — tampil di kartu menu & daftar bahan.
class StokMinusBadge extends StatelessWidget {
  const StokMinusBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.red.shade600,
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Text(
        'Stok Minus',
        style: TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Badge "HERO" — produk unggulan (3 produk dengan qty terjual terbanyak,
/// dihitung dari data penjualan nyata, bukan angka karangan).
class HeroBadge extends StatelessWidget {
  const HeroBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF059669),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Text(
        'HERO',
        style: TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
