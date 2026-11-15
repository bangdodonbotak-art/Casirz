// Casirz ERP — Fase 5 (Modul D Staf).
// App shell + RBAC: bottom nav mobile portrait (<=5 item + "Lainnya") +
// sidebar tablet landscape. Badge sync pending di header + nama toko.
//
// RBAC (BLUEPRINT + keputusan Fase 5):
// - Owner: semua menu.
// - Manager: POS + Meja + Transaksi + Bahan Baku (+opname) + Laporan
//   (lihat saja) + Shift + Staf + Pengaturan. TIDAK: Akuntansi
//   (Modal/Aset) + ubah PIN orang lain.
// - Kasir: POS + Meja + Transaksi (lihat saja) + Shift. TIDAK:
//   Akuntansi, Staf, Bahan Baku/opname, Laporan, Pengaturan.
// Menu yang tidak boleh: disembunyikan dari nav, TAPI tetap muncul di
// sheet "Lainnya" sebagai entri terkunci (ikon gembok + alasan jelas)
// — bukan tombol mati tanpa penjelasan. Mengetuknya menampilkan dialog
// alasan, bukan membuka halaman.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/session.dart';
import '../../core/supabase_config.dart';
import '../../shared/theme/app_theme.dart';
import '../accounting/accounting_page.dart';
import '../accounting/reports_page.dart';
import '../dashboard/dashboard_page.dart';
import '../inventory/inventory_page.dart';
import '../pos/pos_page.dart';
import '../pos/pos_providers.dart';
import '../pos/shift.dart';
import '../pos/tables.dart';
import '../pos/transactions.dart';
import '../settings/settings_page.dart';
import '../staff/auth.dart';
import '../staff/staff_page.dart';
import '../staff/staff_providers.dart';

final shellIndexProvider = StateProvider<int>((ref) => 0);

class _NavDest {
  const _NavDest({
    required this.label,
    required this.icon,
    required this.page,
  });
  final String label;
  final IconData icon;
  final Widget page;
}

class _MoreItem {
  const _MoreItem({
    required this.menu,
    required this.icon,
    required this.page,
  });
  final MenuId menu;
  final IconData icon;
  final Widget Function() page;
}

const _moreItems = [
  _MoreItem(
    menu: MenuId.dashboard,
    icon: Icons.dashboard,
    page: CommandCenterPage.new,
  ),
  _MoreItem(
    menu: MenuId.bahan,
    icon: Icons.inventory_2,
    page: InventoryPage.new,
  ),
  _MoreItem(
    menu: MenuId.akuntansi,
    icon: Icons.account_balance,
    page: AccountingPage.new,
  ),
  _MoreItem(
    menu: MenuId.laporan,
    icon: Icons.assessment,
    page: ReportsPage.new,
  ),
  _MoreItem(
    menu: MenuId.shift,
    icon: Icons.store,
    page: ShiftPage.new,
  ),
  _MoreItem(
    menu: MenuId.pengaturan,
    icon: Icons.settings,
    page: SettingsPage.new,
  ),
];

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  StaffRole _role(SessionState session) {
    final employee = session.employee;
    if (employee == null) return StaffRole.owner; // DB kosong / belum login
    return roleFromString(employee.role);
  }

  List<_NavDest> _navDests(StaffRole role) {
    final dests = <_NavDest>[
      const _NavDest(label: 'Kasir', icon: Icons.point_of_sale, page: PosPage()),
      const _NavDest(
        label: 'Meja',
        icon: Icons.table_restaurant,
        page: TablesPage(),
      ),
      const _NavDest(
        label: 'Transaksi',
        icon: Icons.receipt_long,
        page: TransactionsPage(),
      ),
    ];
    if (role.canAccess(MenuId.staf)) {
      dests.add(
        const _NavDest(label: 'Staf', icon: Icons.people, page: StaffPage()),
      );
    }
    return dests;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final role = _role(session);
    final dests = _navDests(role);
    final rawIndex = ref.watch(shellIndexProvider);
    final index = rawIndex.clamp(0, dests.length - 1);
    final settingsAsync = ref.watch(posSettingsProvider);
    final storeName = settingsAsync.value?.storeName ?? 'Casirz';
    final isWide = MediaQuery.of(context).size.width >= 900;

    final appBar = AppBar(
      // Rework premium: nama toko serif Fraunces (momen brand) +
      // judul max 1 baris + ellipsis — jangan kepotong tanpa elipsis.
      // (Flexible tidak berlaku di dalam AppBar: AppBar sendiri sudah
      // memberi ruang terbatas pada title; ellipsis + chip Offline
      // yang ringkas memberi judul ruang lebih.)
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: storeName,
              style: const TextStyle(
                fontFamily: AppTheme.displayFont,
                fontWeight: FontWeight.w600,
                // 18 (bukan 20): di lebar 360dp, "Warkop Kekinian"
                // dalam Fraunces 20 tidak muat di samping chip Offline
                // + tombol tema dan terpotong jadi "Warkop Keki…".
                fontSize: 18,
                fontVariations: [FontVariation('opsz', 18)],
              ),
            ),
            // TANPA sufiks " — {halaman}": di lebar 360dp sufiks itu
            // membuat nama toko terpotong ("Warkop Keki…"); halaman
            // aktif sudah ditandai di bottom navigation.
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      actions: [
        const _SyncBadge(),
        if (session.employee != null) _UserChip(role: role),
        IconButton(
          tooltip: 'Ganti tema',
          icon: Icon(
            ref.watch(themeModeProvider) == ThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode,
          ),
          onPressed: () async {
            final current = ref.read(themeModeProvider);
            final next = current == ThemeMode.dark
                ? ThemeMode.light
                : ThemeMode.dark;
            ref.read(themeModeProvider.notifier).state = next;
            final db = ref.read(databaseProvider);
            await db.setSetting(
              'themeMode',
              next == ThemeMode.dark ? 'dark' : 'light',
            );
            ref.read(settingsVersionProvider.notifier).state++;
          },
        ),
      ],
    );

    if (isWide) {
      return Scaffold(
        appBar: appBar,
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: index,
              onDestinationSelected: (i) =>
                  ref.read(shellIndexProvider.notifier).state = i,
              labelType: NavigationRailLabelType.all,
              destinations: dests
                  .map(
                    (d) => NavigationRailDestination(
                      icon: Icon(d.icon),
                      label: Text(d.label),
                    ),
                  )
                  .toList(),
              trailing: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    for (final item in _moreItems)
                      _RailMoreButton(item: item, role: role),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: IndexedStack(
                index: index,
                children: dests.map((d) => d.page).toList(),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: appBar,
      body: IndexedStack(
        index: index,
        children: dests.map((d) => d.page).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) {
          if (i == dests.length) {
            _openMoreSheet(context, ref, role);
            return;
          }
          ref.read(shellIndexProvider.notifier).state = i;
        },
        items: [
          for (final d in dests)
            BottomNavigationBarItem(icon: Icon(d.icon), label: d.label),
          const BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'Lainnya',
          ),
        ],
      ),
    );
  }

  void _openMoreSheet(BuildContext context, WidgetRef ref, StaffRole role) {
    final session = ref.read(sessionProvider);
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (session.employee != null)
                ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      session.employee!.name.isEmpty
                          ? '?'
                          : session.employee!.name[0],
                    ),
                  ),
                  title: Text(session.employee!.name),
                  subtitle: Text('Login sebagai ${role.label}'),
                  trailing: TextButton(
                    onPressed: () async {
                      Navigator.of(ctx).pop();
                      ref.read(shellIndexProvider.notifier).state = 0;
                      await ref.read(sessionProvider.notifier).lock();
                    },
                    child: const Text('Ganti Pengguna'),
                  ),
                ),
              const Divider(),
              for (final item in _moreItems)
                _MoreTile(item: item, role: role),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tombol "Lainnya" di rail tablet: buka halaman bila boleh, bila
/// terkunci tampilkan gembok + dialog alasan.
class _RailMoreButton extends ConsumerWidget {
  const _RailMoreButton({required this.item, required this.role});
  final _MoreItem item;
  final StaffRole role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allowed = role.canAccess(item.menu);
    return IconButton(
      tooltip: allowed
          ? item.menu.label
          : '${item.menu.label} (terkunci untuk ${role.label})',
      icon: Icon(allowed ? item.icon : Icons.lock),
      onPressed: () {
        if (allowed) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => item.page()),
          );
        } else {
          showLockedDialog(context, item.menu, role);
        }
      },
    );
  }
}

/// Entri sheet "Lainnya": terbuka -> navigasi; terkunci -> gembok +
/// alasan + dialog saat diketuk.
class _MoreTile extends StatelessWidget {
  const _MoreTile({required this.item, required this.role});
  final _MoreItem item;
  final StaffRole role;

  @override
  Widget build(BuildContext context) {
    final allowed = role.canAccess(item.menu);
    return ListTile(
      leading: Icon(allowed ? item.icon : Icons.lock),
      title: Text(item.menu.label),
      subtitle: allowed
          ? null
          : Text(
              'Terkunci — hanya ${item.menu == MenuId.akuntansi || item.menu == MenuId.dashboard ? 'Owner' : 'Owner/Manager'}',
            ),
      onTap: () {
        if (allowed) {
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => item.page()),
          );
        } else {
          // Jangan pop sheet dulu — dialog alasan tampil di atas sheet.
          showLockedDialog(context, item.menu, role);
        }
      },
    );
  }
}

/// Dialog penjelasan menu terkunci (RBAC) — bukan tombol mati.
void showLockedDialog(BuildContext context, MenuId menu, StaffRole role) {
  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Menu ${menu.label} Terkunci'),
      content: Text(menu.lockedReason(role)),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Mengerti'),
        ),
      ],
    ),
  );
}

/// Chip pengguna aktif di AppBar (nama + peran). Diketuk -> ganti
/// pengguna (kunci aplikasi, tanpa tutup aplikasi).
class _UserChip extends ConsumerWidget {
  const _UserChip({required this.role});
  final StaffRole role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final name = session.employee?.name ?? '';
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: ActionChip(
        avatar: const Icon(Icons.switch_account, size: 18),
        label: Text('$name (${role.label})'),
        onPressed: () async {
          final ok = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Ganti Pengguna'),
              content: Text(
                'Keluar dari sesi $name (${role.label}) dan kembali '
                'ke layar kunci? Data tidak hilang.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text('Batal'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: const Text('Ya, Ganti Pengguna'),
                ),
              ],
            ),
          );
          if (ok == true) {
            ref.read(shellIndexProvider.notifier).state = 0;
            await ref.read(sessionProvider.notifier).lock();
          }
        },
      ),
    );
  }
}

/// Badge "N perubahan belum tersinkron" + jam sync terakhir.
/// Bila Supabase belum dikonfigurasi (Fase 7, nonaktif): chip ringkas
/// "Offline" — bukan angka palsu, bukan error.
class _SyncBadge extends ConsumerWidget {
  const _SyncBadge();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configured = SupabaseConfig.fromEnvironment().isConfigured;
    final statusAsync = ref.watch(syncStatusProvider);
    return statusAsync.when(
      data: (status) {
        final label = !configured
            ? 'Offline'
            : status.pendingCount > 0
                ? '${status.pendingCount} belum tersinkron'
                : 'Tersinkron';
        return Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Tooltip(
            message: !configured
                ? 'Sinkronisasi belum diaktifkan — aktifkan proyek '
                    'Supabase dulu (Fase 7). Data tetap aman di HP ini.'
                : status.lastSyncAt == null
                    ? 'Belum pernah tersinkron'
                    : 'Terakhir sync: ${status.lastSyncAt}',
            child: Chip(
              avatar: Icon(
                !configured || status.pendingCount > 0
                    ? Icons.cloud_off
                    : Icons.cloud_done,
                size: 16,
              ),
              label: Text(label),
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
