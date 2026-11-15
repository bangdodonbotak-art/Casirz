// Casirz ERP — Fase 2.
// Widget angka uang: format Rp id_ID + tabularFigures (angka rata,
// BLUEPRINT-FLUTTER.md §8.4). Satu tempat untuk semua tampilan uang.
import 'package:flutter/material.dart';

import '../../core/money.dart';

class MoneyText extends StatelessWidget {
  const MoneyText(
    this.amount, {
    super.key,
    this.style,
    this.negativeRed = false,
  });
  final int amount;
  final TextStyle? style;
  final bool negativeRed;

  @override
  Widget build(BuildContext context) {
    final color = negativeRed && amount < 0 ? Colors.red : style?.color;
    return Text(
      fmt(amount),
      style: (style ?? const TextStyle()).copyWith(
        fontFeatures: const [FontFeature.tabularFigures()],
        color: color,
      ),
    );
  }
}
