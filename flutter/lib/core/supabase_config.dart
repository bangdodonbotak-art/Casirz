// Casirz ERP — Fase 7.
// Konfigurasi Supabase: URL + anon key dibaca dari --dart-define
// (String.fromEnvironment). TIDAK ADA kredensial yang di-hardcode di
// mana pun di repo ini.
//
// Cara mengaktifkan (nanti, setelah Dony mengaktifkan proyek Supabase):
//   flutter build apk --debug \
//     --dart-define=SUPABASE_URL=https://<project>.supabase.co \
//     --dart-define=SUPABASE_ANON_KEY=<anon key>
// (anon key = publishable key — JANGAN pakai service_role key di aplikasi.)
//
// Bila salah satu kosong, sync NONAKTIF: engine tidak mencoba koneksi
// apa pun dan UI menampilkan "Sinkronisasi belum diaktifkan" (bukan
// error). Data tetap aman di HP — database lokal = sumber kebenaran
// (BLUEPRINT-FLUTTER.md §1.1, §11).
class SupabaseConfig {
  const SupabaseConfig({required this.url, required this.anonKey});

  /// Baca dari --dart-define. Di `flutter test` / build tanpa
  /// --dart-define, keduanya '' sehingga sync nonaktif.
  factory SupabaseConfig.fromEnvironment() => const SupabaseConfig(
        url: String.fromEnvironment('SUPABASE_URL'),
        anonKey: String.fromEnvironment('SUPABASE_ANON_KEY'),
      );

  /// URL proyek, contoh: https://PROJECT-REF.supabase.co
  final String url;

  /// Anon (publishable) key proyek Supabase.
  final String anonKey;

  /// True hanya bila URL DAN anon key terisi.
  bool get isConfigured => url.isNotEmpty && anonKey.isNotEmpty;

  /// Throw [StateError] dengan pesan jelas bila sync belum dikonfigurasi.
  /// Dipakai [SupabaseTransport] — jangan panggil dari UI.
  void requireConfigured() {
    if (!isConfigured) {
      throw StateError(
        'Supabase belum dikonfigurasi. Aktifkan proyek Supabase dulu, '
        'lalu build dengan --dart-define=SUPABASE_URL=... '
        '--dart-define=SUPABASE_ANON_KEY=... (lihat '
        'lib/core/supabase_config.dart).',
      );
    }
  }
}
