// Casirz ERP — Fase 2.
// Wiring aplikasi: SATU ProviderScope (DB di-override di sini) + tema
// + AppShell. Font sistem (tanpa font Google). Bahasa UI Indonesia.
//
// Struktur: CasirzApp (StatefulWidget biasa) -> ProviderScope ->
// _CasirzAppInner (Consumer — baca themeModeProvider). Satu scope saja,
// supaya state tema/kasir tidak hilang di antara scope bersarang.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/db.dart';
import 'core/session.dart';
import 'features/pos/pos_providers.dart';
import 'features/shell/app_shell.dart';
import 'features/staff/lock_screen.dart';
import 'features/staff/staff_providers.dart';
import 'shared/theme/app_theme.dart';

class CasirzApp extends StatefulWidget {
  const CasirzApp({super.key, required this.db, this.initialDark = false});
  final AppDatabase db;
  final bool initialDark;

  @override
  State<CasirzApp> createState() => _CasirzAppState();
}

class _CasirzAppState extends State<CasirzApp> {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(widget.db),
        sessionProvider.overrideWith(
          (ref) => SessionNotifier(widget.db),
        ),
      ],
      child: _CasirzAppInner(initialDark: widget.initialDark),
    );
  }
}

/// Gerbang sesi (Fase 5): lock screen / setup PIN owner / shell.
/// - loading: spinner sebentar.
/// - open (DB kosong, belum ada karyawan): shell langsung — supaya
///   pemilik bisa isi seed demo / tambah owner pertama.
/// - needsOwnerSetup: owner wajib buat PIN dulu (tanpa PIN bawaan).
/// - locked: pilih karyawan + PIN.
/// - unlocked: shell.
class SessionGate extends ConsumerWidget {
  const SessionGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    switch (session.status) {
      case SessionStatus.loading:
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      case SessionStatus.needsOwnerSetup:
        return const OwnerSetupScreen();
      case SessionStatus.locked:
        return const LockScreen();
      case SessionStatus.open:
      case SessionStatus.unlocked:
        return const AppShell();
    }
  }
}

class _CasirzAppInner extends ConsumerStatefulWidget {
  const _CasirzAppInner({required this.initialDark});
  final bool initialDark;

  @override
  ConsumerState<_CasirzAppInner> createState() => _CasirzAppInnerState();
}

class _CasirzAppInnerState extends ConsumerState<_CasirzAppInner> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(themeModeProvider.notifier).state =
          widget.initialDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      title: 'Casirz ERP',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      home: const SessionGate(),
    );
  }
}
