// Casirz ERP — Fase 2.
// Pengaturan kasir: nama toko, tarif komisi ojol per platform
// (editable, default 0 — JANGAN dikarang), markup ojol, PPN default,
// service charge / PB1, nama toko, mode struk 58/80mm, tema,
// printer thermal, dan tombol "Isi Data Demo Warkop" (SeedDemo.run).
// Fase 7: seksi Sinkronisasi & Backup (_SyncBackupSection).
import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/backup.dart';
import '../../core/money.dart';
import '../../core/printer/printer_port.dart';
import '../../core/seed.dart';
import '../../core/supabase_config.dart';
import '../../core/sync_engine.dart';
import '../../shared/widgets/common.dart';
import '../pos/pos_providers.dart';
import '../staff/auth.dart';
import '../staff/staff_providers.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  var _busySeed = false;
  String? _seedResult;
  var _busyReset = false;
  String? _resetResult;

  /// Reset data hanya untuk Owner (DB kosong / belum login = owner).
  bool get _isOwner {
    final employee = ref.watch(sessionProvider).employee;
    if (employee == null) return true;
    return roleFromString(employee.role) == StaffRole.owner;
  }

  Future<void> _save(String key, String value) async {
    final db = ref.read(databaseProvider);
    await db.setSetting(key, value);
    ref.read(settingsVersionProvider.notifier).state++;
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(posSettingsProvider);
    final settings = settingsAsync.value ?? PosSettings.fromMap({});
    final themeMode = ref.watch(themeModeProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: settingsAsync.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _section('Toko'),
                _TextSettingRow(
                  label: 'Nama toko',
                  value: settings.storeName,
                  onSave: (v) => _save('storeName', v.trim()),
                ),
                SwitchListTile(
                  title: const Text('Tema gelap'),
                  value: themeMode == ThemeMode.dark,
                  onChanged: (v) async {
                    ref.read(themeModeProvider.notifier).state =
                        v ? ThemeMode.dark : ThemeMode.light;
                    await _save('themeMode', v ? 'dark' : 'light');
                  },
                ),
                _section('Kasir'),
                SwitchListTile(
                  title: const Text('PPN 11% aktif (default)'),
                  subtitle: const Text(
                    'Bila aktif, PPN dihitung otomatis di keranjang. '
                    'Kasir tetap bisa mematikan per transaksi.',
                  ),
                  value: settings.ppnEnabled,
                  onChanged: (v) =>
                      _save('ppnEnabled', v ? '1' : '0'),
                ),
                _IntSettingRow(
                  label: 'Tarif PPN (%)',
                  value: settings.ppnRate,
                  onSave: (v) => _save('ppnRate', v.toString()),
                ),
                _IntSettingRow(
                  label: 'Service charge default (%)',
                  value: settings.serviceRate,
                  onSave: (v) => _save('serviceChargeRate', v.toString()),
                ),
                _IntSettingRow(
                  label: 'PB1 default (%)',
                  value: settings.pb1Rate,
                  onSave: (v) => _save('pb1Rate', v.toString()),
                ),
                _section('Absensi'),
                ListTile(
                  title: const Text('Jam masuk'),
                  subtitle: Text(
                    '${settings.workStartTime} — check-in setelah jam ini '
                    'dihitung telat di rekap absensi.',
                  ),
                  trailing: const Icon(Icons.edit),
                  onTap: () async {
                    final parts = settings.workStartTime.split(':');
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(
                        hour: int.tryParse(parts[0]) ?? 8,
                        minute: parts.length > 1
                            ? int.tryParse(parts[1]) ?? 0
                            : 0,
                      ),
                    );
                    if (picked != null) {
                      await _save(
                        'workStartTime',
                        '${picked.hour.toString().padLeft(2, '0')}:'
                        '${picked.minute.toString().padLeft(2, '0')}',
                      );
                    }
                  },
                ),
                _section('Ojol — komisi & markup per platform'),
                const Text(
                  'Default 0. Dony yang mengisi tarifnya — jangan dikarang. '
                  'Komisi dihitung dari subtotal setelah diskon; markup '
                  'menaikkan harga jual di channel ojol.',
                ),
                _IntSettingRow(
                  label: 'Komisi GoFood (%)',
                  value: settings.ojolFeeGoFood,
                  onSave: (v) => _save('ojolFeeGoFood', v.toString()),
                ),
                _IntSettingRow(
                  label: 'Komisi GrabFood (%)',
                  value: settings.ojolFeeGrabFood,
                  onSave: (v) => _save('ojolFeeGrabFood', v.toString()),
                ),
                _IntSettingRow(
                  label: 'Komisi ShopeeFood (%)',
                  value: settings.ojolFeeShopeeFood,
                  onSave: (v) => _save('ojolFeeShopeeFood', v.toString()),
                ),
                _IntSettingRow(
                  label: 'Markup GoFood (%)',
                  value: settings.ojolMarkupGoFood,
                  onSave: (v) => _save('ojolMarkupGoFood', v.toString()),
                ),
                _IntSettingRow(
                  label: 'Markup GrabFood (%)',
                  value: settings.ojolMarkupGrabFood,
                  onSave: (v) => _save('ojolMarkupGrabFood', v.toString()),
                ),
                _IntSettingRow(
                  label: 'Markup ShopeeFood (%)',
                  value: settings.ojolMarkupShopeeFood,
                  onSave: (v) => _save('ojolMarkupShopeeFood', v.toString()),
                ),
                _section('Struk'),
                ListTile(
                  title: const Text('Lebar kertas struk'),
                  trailing: DropdownButton<String>(
                    value: settings.paperWidth,
                    items: const [
                      DropdownMenuItem(value: '58', child: Text('58mm')),
                      DropdownMenuItem(value: '80', child: Text('80mm')),
                    ],
                    onChanged: (v) {
                      if (v != null) {
                        _save('receiptPaperWidth', v);
                      }
                    },
                  ),
                ),
                const _PrinterSection(),
                _section('Sinkronisasi & Backup'),
                const _SyncBackupSection(),
                _section('Data Demo'),
                const Text(
                  'Preset "Warkop Kekinian" Rp60jt: 11 bahan, 10 menu + BOM, '
                  '4 aset, modal Rp60jt, 15 transaksi (omzet Rp574.000). '
                  'Menekan tombol ini MERESET data lama lalu mengisi ulang — '
                  'bukan rencana investor Warkop Hits (Rp50jt).',
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: _busySeed ? null : () => _runSeed(context),
                  icon: _busySeed
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.download),
                  label: const Text('Isi Data Demo Warkop'),
                ),
                if (_seedResult != null) ...[
                  const SizedBox(height: 12),
                  Text(_seedResult!),
                ],
                _section('Beban Bulanan (untuk Command Center)'),
                const Text(
                  'Beban tetap bulanan — dipakai Command Center untuk '
                  'menghitung OPEX prorata harian (dibagi 30). Gaji tidak '
                  'di sini: gaji dihitung otomatis dari karyawan aktif.',
                  style: TextStyle(fontSize: 12),
                ),
                _RpSettingRow(
                  label: 'Listrik (Rp/bulan)',
                  value: settings.opexListrik,
                  onSave: (v) => _save('opexListrik', v.toString()),
                ),
                _RpSettingRow(
                  label: 'Air (Rp/bulan)',
                  value: settings.opexAir,
                  onSave: (v) => _save('opexAir', v.toString()),
                ),
                _RpSettingRow(
                  label: 'Internet (Rp/bulan)',
                  value: settings.opexInternet,
                  onSave: (v) => _save('opexInternet', v.toString()),
                ),
                _section('Reset Data'),
                const Text(
                  'Hapus SEMUA data (penjualan, stok, karyawan, pengaturan) '
                  'dan kembali seperti aplikasi baru. Satu-satunya jalan '
                  'bila satu-satunya owner lupa PIN — tidak ada jalan lain. '
                  'Data yang terhapus TIDAK bisa dikembalikan.',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 12),
                if (_isOwner)
                  FilledButton.icon(
                    onPressed: _busyReset ? null : () => _resetData(context),
                    icon: const Icon(Icons.delete_forever),
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                    label: const Text('Reset Data Total'),
                  )
                else
                  const Text(
                    'Reset data hanya bisa dilakukan Owner yang sedang login.',
                    style: TextStyle(fontSize: 12),
                  ),
                if (_resetResult != null) ...[
                  const SizedBox(height: 12),
                  Text(_resetResult!),
                ],
              ],
            ),
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Future<void> _runSeed(BuildContext context) async {
    final db = ref.read(databaseProvider);
    final alreadySeeded = await SeedDemo.isSeeded(db);
    if (!context.mounted) return;
    if (alreadySeeded) {
      final ok = await showConfirmDialog(
        context,
        title: 'Data demo sudah ada',
        message:
            'Menekan tombol ini akan MERESET semua data (penjualan, stok, '
            'shift, order) lalu mengisi ulang data demo dari awal. Lanjutkan?',
        actionLabel: 'Ya, reset & isi ulang',
      );
      if (!ok) return;
    }
    setState(() {
      _busySeed = true;
      _seedResult = null;
    });
    try {
      await SeedDemo.run(db);
      ref.read(settingsVersionProvider.notifier).state++;
      ref.invalidate(productsProvider);
      setState(() {
        _seedResult =
            'Berhasil. Modal Rp60.000.000, 11 bahan (Rp3.000.000), '
            '10 menu, 15 transaksi (omzet Rp574.000, HPP Rp210.360, '
            'laba kotor Rp363.640). Karyawan: Owner, Kasir 1, Kasir 2 '
            '(PIN belum diatur — atur di Staf, Fase 5).';
      });
    } catch (e) {
      setState(() => _seedResult = 'Gagal mengisi data demo: $e');
    } finally {
      if (mounted) setState(() => _busySeed = false);
    }
  }

  Future<void> _resetData(BuildContext context) async {
    final ok = await showConfirmDialog(
      context,
      title: 'Reset Data Total?',
      message:
          'SEMUA data akan dihapus permanen: penjualan, stok, karyawan, '
          'pengaturan, dan semua riwayat. Aplikasi kembali seperti baru. '
          'Data yang terhapus TIDAK bisa dikembalikan. Lanjutkan?',
      actionLabel: 'Ya, hapus semua data',
    );
    if (!ok || !context.mounted) return;
    setState(() {
      _busyReset = true;
      _resetResult = null;
    });
    try {
      final db = ref.read(databaseProvider);
      await db.resetAllData();
      // Karyawan habis -> sesi kembali "open" (DB kosong).
      await ref.read(sessionProvider.notifier).refresh();
      ref.read(settingsVersionProvider.notifier).state++;
      if (mounted) {
        setState(() {
          _resetResult = 'Semua data sudah dihapus. Aplikasi kembali baru.';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _resetResult = 'Gagal reset data: $e');
      }
    } finally {
      if (mounted) setState(() => _busyReset = false);
    }
  }
}

/// Baris setting teks (dialog edit).
class _TextSettingRow extends StatelessWidget {
  const _TextSettingRow({
    required this.label,
    required this.value,
    required this.onSave,
  });
  final String label;
  final String value;
  final void Function(String value) onSave;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      subtitle: Text(value),
      trailing: const Icon(Icons.edit),
      onTap: () async {
        final ctrl = TextEditingController(text: value);
        final saved = await showDialog<String>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(label),
            content: TextField(
              controller: ctrl,
              autofocus: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Batal'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop(ctrl.text),
                child: const Text('Simpan'),
              ),
            ],
          ),
        );
        if (saved != null) onSave(saved);
      },
    );
  }
}

/// Baris setting angka (Rp) — dialog edit, tanpa batas persen.
class _RpSettingRow extends StatelessWidget {
  const _RpSettingRow({
    required this.label,
    required this.value,
    required this.onSave,
  });
  final String label;
  final int value;
  final void Function(int value) onSave;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      subtitle: Text(fmt(value)),
      trailing: const Icon(Icons.edit),
      onTap: () async {
        final ctrl = TextEditingController(text: value.toString());
        final saved = await showDialog<int>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(label),
            content: TextField(
              controller: ctrl,
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixText: 'Rp ',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Batal'),
              ),
              FilledButton(
                onPressed: () {
                  final v =
                      int.tryParse(ctrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
                          0;
                  Navigator.of(ctx).pop(v < 0 ? 0 : v);
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        );
        if (saved != null) onSave(saved);
      },
    );
  }
}

/// Baris setting angka (%) — dialog edit, 0-100.
class _IntSettingRow extends StatelessWidget {
  const _IntSettingRow({
    required this.label,
    required this.value,
    required this.onSave,
  });
  final String label;
  final int value;
  final void Function(int value) onSave;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      subtitle: Text('$value%'),
      trailing: const Icon(Icons.edit),
      onTap: () async {
        final ctrl = TextEditingController(text: value.toString());
        final saved = await showDialog<int>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(label),
            content: TextField(
              controller: ctrl,
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                suffixText: '%',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Batal'),
              ),
              FilledButton(
                onPressed: () {
                  final v =
                      int.tryParse(ctrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
                          0;
                  Navigator.of(ctx).pop(v.clamp(0, 100));
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        );
        if (saved != null) onSave(saved);
      },
    );
  }
}

/// Bagian printer: cari + hubungkan + status.
///
/// JUJUR: printer fisik tidak bisa dites di VM. Bagian ini melaporkan
/// status apa adanya (ditemukan / gagal + alasan).
class _PrinterSection extends ConsumerStatefulWidget {
  const _PrinterSection();

  @override
  ConsumerState<_PrinterSection> createState() => _PrinterSectionState();
}

class _PrinterSectionState extends ConsumerState<_PrinterSection> {
  List<DiscoveredPrinter> _found = [];
  DiscoveredPrinter? _connected;
  var _scanning = false;
  String? _status;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Printer Thermal',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              _connected == null
                  ? 'Belum ada printer terhubung.'
                  : 'Terhubung: ${_connected!.name} (${_connected!.kind.name})',
            ),
            if (_status != null) ...[
              const SizedBox(height: 4),
              Text(_status!),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                FilledButton.icon(
                  onPressed: _scanning ? null : _scan,
                  icon: _scanning
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.search),
                  label: const Text('Cari Printer'),
                ),
                const SizedBox(width: 8),
                if (_connected != null)
                  OutlinedButton(
                    onPressed: () async {
                      try {
                        await ref.read(printerPortProvider).disconnect();
                        setState(() {
                          _connected = null;
                          _status = 'Printer diputuskan.';
                        });
                      } catch (e) {
                        setState(() => _status = 'Gagal memutuskan: $e');
                      }
                    },
                    child: const Text('Putuskan'),
                  ),
              ],
            ),
            if (_found.isNotEmpty) ...[
              const SizedBox(height: 8),
              ..._found.map(
                (p) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(p.name),
                  subtitle: Text(p.kind.name),
                  trailing: _connected?.id == p.id
                      ? const Icon(Icons.check, color: Colors.green)
                      : TextButton(
                          onPressed: () => _connect(p),
                          child: const Text('Hubungkan'),
                        ),
                ),
              ),
            ],
            const SizedBox(height: 4),
            const Text(
              'Catatan: printer fisik belum bisa dites di VM. '
              'Di HP, pastikan printer menyala (USB/BT/network) lalu '
              'tekan "Cari Printer".',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _scan() async {
    setState(() {
      _scanning = true;
      _status = null;
    });
    try {
      final found = await ref.read(printerPortProvider).discover();
      setState(() {
        _found = found;
        _status = found.isEmpty
            ? 'Tidak ada printer ditemukan. Pastikan printer menyala dan '
                'dalam jangkauan.'
            : '${found.length} printer ditemukan.';
      });
    } catch (e) {
      setState(() => _status = 'Pencarian gagal: $e');
    } finally {
      if (mounted) setState(() => _scanning = false);
    }
  }

  Future<void> _connect(DiscoveredPrinter p) async {
    setState(() => _status = 'Menghubungkan ke ${p.name}...');
    try {
      await ref.read(printerPortProvider).connect(p);
      setState(() {
        _connected = p;
        _status = 'Berhasil terhubung ke ${p.name}.';
      });
    } catch (e) {
      setState(() => _status = 'Gagal terhubung: $e');
    }
  }
}

/// Bagian sinkronisasi + backup manual (Fase 7).
///
/// - Sync NONAKTIF bila Supabase belum dikonfigurasi: tombol
///   "Sinkronkan sekarang" menampilkan "Sinkronisasi belum diaktifkan"
///   (bukan error). Data tetap aman di HP.
/// - Backup: export JSON `casirz-backup-v1` (semua tabel) lewat
///   file_picker saveFile; restore dari file backup yang sama.
///   File TIDAK terenkripsi — jangan bagikan ke pihak tak dikenal.
/// - Pengingat mingguan: banner kuning bila belum backup > 7 hari
///   (bukan notifikasi sistem).
class _SyncBackupSection extends ConsumerStatefulWidget {
  const _SyncBackupSection();

  @override
  ConsumerState<_SyncBackupSection> createState() =>
      _SyncBackupSectionState();
}

class _SyncBackupSectionState extends ConsumerState<_SyncBackupSection> {
  var _busySync = false;
  var _busyBackup = false;
  var _busyRestore = false;
  String? _syncResult;
  String? _backupResult;
  String? _restoreResult;

  bool get _configured => SupabaseConfig.fromEnvironment().isConfigured;

  @override
  Widget build(BuildContext context) {
    final db = ref.read(databaseProvider);
    final backup = BackupService(db);
    final engine = ref.watch(syncEngineProvider);
    final statusAsync = ref.watch(syncStatusProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sinkronisasi',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            statusAsync.when(
              data: (status) => Text(
                _configured
                    ? status.pendingCount > 0
                        ? '${status.pendingCount} perubahan belum tersinkron.'
                        : 'Semua perubahan sudah tersinkron.'
                    : 'Sinkronisasi belum diaktifkan — aktifkan proyek '
                        'Supabase dulu (butuh URL + anon key). '
                        'Data tetap aman di HP ini.',
              ),
              loading: () => const Text('Memuat status sync...'),
              error: (_, _) => const Text('Status sync tidak bisa dibaca.'),
            ),
            if (_configured)
              statusAsync.when(
                data: (status) => Text(
                  status.lastSyncAt == null
                      ? 'Belum pernah tersinkron.'
                      : 'Terakhir sync: ${status.lastSyncAt}',
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: _busySync ? null : _syncNow,
              icon: _busySync
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.sync),
              label: const Text('Sinkronkan sekarang'),
            ),
            if (_syncResult != null) ...[
              const SizedBox(height: 4),
              Text(_syncResult!),
            ],
            if (engine is RealSyncEngine)
              FutureBuilder(
                future: engine.recentConflicts(limit: 1),
                builder: (ctx, snap) {
                  if (!snap.hasData || snap.data!.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Ada konflik sync yang tercatat (baris lokal '
                      'dipertahankan). Lihat detail di back-office.',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 16),
            Text(
              'Backup Manual',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            FutureBuilder<bool>(
              future: backup.needsBackupReminder(),
              builder: (ctx, snap) {
                if (snap.data != true) return const SizedBox.shrink();
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 4, bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Sudah lebih dari 7 hari sejak backup terakhir (atau '
                    'belum pernah backup). Segera backup supaya data tidak '
                    'hilang bila HP rusak / hilang.',
                  ),
                );
              },
            ),
            FutureBuilder<DateTime?>(
              future: backup.lastBackupAt(),
              builder: (ctx, snap) => Text(
                snap.data == null
                    ? 'Belum pernah backup.'
                    : 'Backup terakhir: ${snap.data}',
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                FilledButton.icon(
                  onPressed: _busyBackup ? null : _backup,
                  icon: const Icon(Icons.backup),
                  label: const Text('Backup sekarang'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: _busyRestore ? null : _restore,
                  icon: const Icon(Icons.restore),
                  label: const Text('Restore'),
                ),
              ],
            ),
            if (_backupResult != null) ...[
              const SizedBox(height: 4),
              Text(_backupResult!),
            ],
            if (_restoreResult != null) ...[
              const SizedBox(height: 4),
              Text(_restoreResult!),
            ],
            const SizedBox(height: 4),
            const Text(
              'Backup berisi SEMUA data (format casirz-backup-v1) dan '
              'TIDAK terenkripsi — simpan di tempat yang hanya kamu yang '
              'bisa buka (Drive pribadi / HP sendiri).',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _syncNow() async {
    if (!_configured) {
      setState(() {
        _syncResult =
            'Sinkronisasi belum diaktifkan — aktifkan proyek Supabase '
            'dulu (butuh URL + anon key).';
      });
      return;
    }
    setState(() {
      _busySync = true;
      _syncResult = null;
    });
    try {
      final result =
          await ref.read(syncEngineProvider).syncNow();
      ref.invalidate(syncStatusProvider);
      setState(() {
        _syncResult = result.failed > 0
            ? 'Sync gagal sebagian: terkirim ${result.pushed}, '
                'ditarik ${result.pulled}, gagal ${result.failed}. '
                'Periksa internet lalu coba lagi.'
            : 'Sync berhasil: terkirim ${result.pushed}, '
                'ditarik ${result.pulled}.';
      });
    } catch (e) {
      setState(() => _syncResult = 'Sync gagal: $e');
    } finally {
      if (mounted) setState(() => _busySync = false);
    }
  }

  Future<void> _backup() async {
    setState(() {
      _busyBackup = true;
      _backupResult = null;
    });
    try {
      final db = ref.read(databaseProvider);
      final backup = BackupService(db);
      final json = await backup.exportJsonString();
      final fileName = BackupService.fileNameFor(DateTime.now());
      final path = await FilePicker.saveFile(
        dialogTitle: 'Simpan backup Casirz',
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: ['json'],
        bytes: Uint8List.fromList(utf8.encode(json)),
      );
      if (path == null) {
        setState(() => _backupResult = 'Backup dibatalkan.');
        return;
      }
      await backup.markBackedUp();
      setState(() => _backupResult = 'Backup tersimpan: $path');
    } catch (e) {
      setState(() => _backupResult = 'Backup gagal: $e');
    } finally {
      if (mounted) setState(() => _busyBackup = false);
    }
  }

  Future<void> _restore() async {
    final ok = await showConfirmDialog(
      context,
      title: 'Restore dari backup?',
      message:
          'SEMUA data saat ini akan DIHAPUS lalu diganti isi file backup. '
          'Pastikan file backup yang dipilih benar. Lanjutkan?',
      actionLabel: 'Ya, restore',
    );
    if (!ok || !mounted) return;
    setState(() {
      _busyRestore = true;
      _restoreResult = null;
    });
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        withData: true,
      );
      final bytes = result?.files.single.bytes;
      if (bytes == null) {
        setState(() => _restoreResult = 'Restore dibatalkan.');
        return;
      }
      final db = ref.read(databaseProvider);
      final summary = await BackupService(db)
          .importJsonString(utf8.decode(bytes));
      ref.read(settingsVersionProvider.notifier).state++;
      setState(() {
        _restoreResult =
            'Restore berhasil: ${summary.rows} baris dari '
            '${summary.tables} tabel.';
      });
    } catch (e) {
      setState(() => _restoreResult = 'Restore gagal: $e');
    } finally {
      if (mounted) setState(() => _busyRestore = false);
    }
  }
}
