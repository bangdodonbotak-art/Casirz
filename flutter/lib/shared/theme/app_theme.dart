// Casirz ERP — Rework premium netral (15 Nov 2026, arah disetujui Dony).
// Token: scaffold light #F1F2F0, kartu PUTIH + bayangan halus, radius 16,
// TANPA border outline. Teks ink #14181A. Harga emerald #059669 (light)
// / #34D399 (dark, supaya kontras di kartu gelap). Font: Space Grotesk
// (variable, dibundel) untuk semua UI; Fraunces (variable, dibundel)
// HANYA untuk judul toko — momen brand. Ember #E85D1F dicadangkan untuk
// momen brand lain (splash/header struk), BUKAN aksen UI umum.
// Tanpa paket google_fonts (BLUEPRINT-FLUTTER.md §8.4) — font dibundel
// sebagai file di assets/fonts/ dan didaftarkan di pubspec.yaml.
import 'package:flutter/material.dart';

class AppTheme {
  static const Color emerald = Color(0xFF059669); // emerald-600
  static const Color emeraldBright = Color(0xFF34D399); // emerald-400 (dark)
  static const Color ink = Color(0xFF14181A);
  static const Color ember = Color(0xFFE85D1F); // momen brand saja

  static const String fontFamily = 'Space Grotesk';
  static const String displayFont = 'Fraunces';

  /// Warna harga sesuai kecerahan tema (emerald gelap tidak kontras
  /// di kartu gelap — pakai emerald terang di dark mode).
  static Color priceColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? emeraldBright
          : emerald;

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: emerald,
      brightness: Brightness.light,
    ).copyWith(onSurface: ink);
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: const Color(0xFFF1F2F0),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: ink,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: const Color(0x14000000), // hitam 8%
        surfaceTintColor: Colors.transparent, // kartu tetap putih murni
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 48),
          backgroundColor: emerald,
          foregroundColor: Colors.white,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(minimumSize: const Size(0, 48)),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(minimumSize: const Size(0, 44)),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: emerald,
        unselectedItemColor: Colors.grey.shade600,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  static ThemeData dark() {
    const darkCard = Color(0xFF1E2222);
    const darkText = Color(0xFFEFF2F1);
    final scheme = ColorScheme.fromSeed(
      seedColor: emerald,
      brightness: Brightness.dark,
    ).copyWith(
      surface: darkCard,
      onSurface: darkText,
    );
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: const Color(0xFF101413),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: darkText,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: const Color(0x40000000),
        surfaceTintColor: Colors.transparent,
        color: darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 48),
          backgroundColor: emerald,
          foregroundColor: Colors.white,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(minimumSize: const Size(0, 48)),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(minimumSize: const Size(0, 44)),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: emeraldBright,
        unselectedItemColor: Colors.grey.shade400,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
