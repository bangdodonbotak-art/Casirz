// Casirz ERP — Fase 5 (Modul D Staf).
// Staf: 3 tab — Karyawan | Absensi | Payroll.
//
// - Karyawan: tambah/edit (nama, peran, gaji pokok bulanan/harian),
//   atur/ubah PIN (HANYA Owner), nonaktifkan (tombstone — riwayat
//   absensi + payroll tetap ada). Tidak ada PIN bawaan.
// - Absensi: check-in/check-out pakai PIN, rekap per karyawan per
//   periode (hadir, total jam, telat). Jam masuk default 08:00, bisa
//   diubah di Pengaturan.
// - Payroll: hitung gaji periode (bulanan = pokok; harian = tarif x
//   hari hadir) + tambahan/potongan manual beralasan -> "Proses Gaji"
//   (D 5130 / K 1000|1010 via paySalary, idempotent) -> slip gaji
//   (tampil di layar + share teks; BUKAN PDF).
//
// Hak akses: Kasir TIDAK bisa membuka halaman ini (dijaga shell +
// guard di bawah). Manager boleh lihat + absensi, tapi TIDAK boleh
// ubah karyawan/PIN dan TIDAK boleh proses gaji (hanya Owner).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/db.dart';
import '../../core/money.dart';
import '../../shared/widgets/common.dart';
import '../pos/pos_providers.dart';
import 'auth.dart';
import 'staff_providers.dart';
import 'staff_service.dart';

class StaffPage extends ConsumerStatefulWidget {
  const StaffPage({super.key, this.initialTab = 0});
  final int initialTab;

  @override
  ConsumerState<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends ConsumerState<StaffPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  String _period = currentPeriod();

  @override
  void initState() {
    super.initState();
    _tabs = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTab.clamp(0, 2),
    );
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  StaffRole get _role {
    final employee = ref.watch(sessionProvider).employee;
    if (employee == null) return StaffRole.owner; // DB kosong / belum login
    return roleFromString(employee.role);
  }

  void _refresh() {
    ref.read(staffVersionProvider.notifier).state++;
  }

  @override
  Widget build(BuildContext context) {
    if (_role == StaffRole.kasir) {
      return Scaffold(
        appBar: AppBar(title: const Text('Staf')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Menu Staf hanya untuk Owner dan Manager.\n'
              'Peran Anda saat ini: Kasir. Untuk absensi, pakai tombol '
              '"Absensi" di layar kunci (pilih nama, masukkan PIN).',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
    ref.watch(staffVersionProvider);
    final canManage = _role.canManageEmployees;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staf'),
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(text: 'Karyawan'),
            Tab(text: 'Absensi'),
            Tab(text: 'Payroll'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _EmployeesTab(canManage: canManage, onChanged: _refresh),
          _AttendanceTab(onChanged: _refresh),
          _PayrollTab(
            period: _period,
            canProcess: _role.canProcessPayroll,
            onPeriodChanged: (p) => setState(() => _period = p),
            onChanged: _refresh,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tab Karyawan
// ---------------------------------------------------------------------------

class _EmployeesTab extends ConsumerStatefulWidget {
  const _EmployeesTab({required this.canManage, required this.onChanged});
  final bool canManage;
  final VoidCallback onChanged;

  @override
  ConsumerState<_EmployeesTab> createState() => _EmployeesTabState();
}

class _EmployeesTabState extends ConsumerState<_EmployeesTab> {
  Future<List<Employee>> _load() async {
    final db = ref.read(databaseProvider);
    return StaffService.allEmployees(db);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Employee>>(
      future: _load(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(child: Text('Gagal memuat karyawan: ${snap.error}'));
        }
        final employees = snap.data ?? [];
        if (employees.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Belum ada karyawan.\n'
                    'Isi Data Demo Warkop di Pengaturan untuk membuat '
                    'Owner + 2 Kasir, atau tambah karyawan di bawah ini.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  if (widget.canManage)
                    FilledButton.icon(
                      onPressed: () => _employeeForm(context, null),
                      icon: const Icon(Icons.add),
                      label: const Text('Tambah Karyawan'),
                    ),
                ],
              ),
            ),
          );
        }
        final ownerMissingPin = employees.any(
          (e) => e.role == 'owner' && e.pinHash.isEmpty && e.isActive == 1,
        );
        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            if (ownerMissingPin)
              const Card(
                color: Color(0xFFFFF7E6),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'PERHATIAN: Owner belum punya PIN. Tanpa PIN, aplikasi '
                    'tidak terkunci dan siapa pun bisa membuka semua menu. '
                    'Atur PIN owner sekarang (tombol "Atur PIN" di kartu '
                    'owner). Tidak ada PIN bawaan.',
                  ),
                ),
              ),
            if (widget.canManage)
              FilledButton.icon(
                onPressed: () => _employeeForm(context, null),
                icon: const Icon(Icons.add),
                label: const Text('Tambah Karyawan'),
              )
            else
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Anda login sebagai Manager: bisa melihat daftar '
                    'karyawan dan absensi, tapi tambah/edit karyawan dan '
                    'atur PIN hanya bisa dilakukan Owner.',
                  ),
                ),
              ),
            const SizedBox(height: 8),
            ...employees.map(
              (e) => _EmployeeTile(
                employee: e,
                canManage: widget.canManage,
                onEdit: () => _employeeForm(context, e),
                onSetPin: () => _pinForm(context, e),
                onToggleActive: () => _toggleActive(context, e),
              ),
            ),
            const SizedBox(height: 16),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Karyawan nonaktif TIDAK dihapus — riwayat absensi dan '
                  'payroll-nya tetap tersimpan dan tetap bisa dilihat.',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _employeeForm(BuildContext context, Employee? existing) async {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    var role = existing?.role ?? 'kasir';
    var salaryType = existing?.salaryType ?? 'bulanan';
    final salaryCtrl = TextEditingController(
      text: existing == null ? '' : existing.baseSalary.toString(),
    );
    var salary = existing?.baseSalary ?? 0;
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(existing == null ? 'Tambah Karyawan' : 'Ubah Karyawan'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nama',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: role,
                  decoration: const InputDecoration(
                    labelText: 'Peran',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'owner', child: Text('Owner')),
                    DropdownMenuItem(
                      value: 'manager',
                      child: Text('Manager'),
                    ),
                    DropdownMenuItem(value: 'kasir', child: Text('Kasir')),
                  ],
                  onChanged: (v) {
                    if (v != null) setDialogState(() => role = v);
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: salaryType,
                  decoration: const InputDecoration(
                    labelText: 'Tipe gaji',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'bulanan',
                      child: Text('Bulanan (gaji sebulan)'),
                    ),
                    DropdownMenuItem(
                      value: 'harian',
                      child: Text('Harian (tarif per hari hadir)'),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null) setDialogState(() => salaryType = v);
                  },
                ),
                const SizedBox(height: 12),
                RpInput(
                  controller: salaryCtrl,
                  label: salaryType == 'harian'
                      ? 'Tarif harian'
                      : 'Gaji pokok bulanan',
                  onChanged: (v) => salary = v,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
    if (saved != true || !context.mounted) return;
    try {
      final db = ref.read(databaseProvider);
      if (existing == null) {
        await StaffService.createEmployee(
          db,
          name: nameCtrl.text,
          role: role,
          salaryType: salaryType,
          baseSalary: salary,
        );
      } else {
        await StaffService.updateEmployee(
          db,
          existing.id,
          name: nameCtrl.text,
          role: role,
          salaryType: salaryType,
          baseSalary: salary,
        );
      }
      widget.onChanged();
      setState(() {});
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Karyawan disimpan.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $e')),
        );
      }
    }
  }

  Future<void> _pinForm(BuildContext context, Employee employee) async {
    final pinCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Atur PIN — ${employee.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'PIN 4-6 digit angka. Disimpan dalam bentuk hash, bukan '
              'PIN mentah.',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: pinCtrl,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'PIN baru',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmCtrl,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'Ketik ulang PIN',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Simpan PIN'),
          ),
        ],
      ),
    );
    if (saved != true || !context.mounted) return;
    if (pinCtrl.text != confirmCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PIN tidak sama. Coba lagi.')),
      );
      return;
    }
    try {
      final db = ref.read(databaseProvider);
      await ref.read(authServiceProvider).setPin(db, employee.id, pinCtrl.text);
      await ref.read(sessionProvider.notifier).refresh();
      widget.onChanged();
      setState(() {});
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PIN ${employee.name} sudah diatur.'),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengatur PIN: $e')),
        );
      }
    }
  }

  Future<void> _toggleActive(BuildContext context, Employee e) async {
    final activate = e.isActive != 1;
    final ok = await showConfirmDialog(
      context,
      title: activate ? 'Aktifkan kembali?' : 'Nonaktifkan karyawan?',
      message: activate
          ? '${e.name} bisa absen dan digaji lagi.'
          : '${e.name} tidak bisa absen dan tidak bisa diproses gajinya '
              'lagi. Riwayat absensi dan payroll-nya TETAP tersimpan.',
      actionLabel: activate ? 'Ya, aktifkan' : 'Ya, nonaktifkan',
    );
    if (!ok || !context.mounted) return;
    try {
      final db = ref.read(databaseProvider);
      await StaffService.setEmployeeActive(db, e.id, activate);
      widget.onChanged();
      setState(() {});
    } catch (err) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: $err')),
        );
      }
    }
  }
}

class _EmployeeTile extends StatelessWidget {
  const _EmployeeTile({
    required this.employee,
    required this.canManage,
    required this.onEdit,
    required this.onSetPin,
    required this.onToggleActive,
  });
  final Employee employee;
  final bool canManage;
  final VoidCallback onEdit;
  final VoidCallback onSetPin;
  final VoidCallback onToggleActive;

  @override
  Widget build(BuildContext context) {
    final active = employee.isActive == 1;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text(employee.name.isEmpty ? '?' : employee.name[0]),
        ),
        title: Text(employee.name),
        subtitle: Text(
          'Peran: ${roleFromString(employee.role).label} • '
          '${employee.salaryType == 'harian' ? 'Harian' : 'Bulanan'} '
          '${fmt(employee.baseSalary)}'
          '${employee.pinHash.isEmpty ? ' • PIN belum diatur' : ' • PIN sudah diatur'}',
        ),
        trailing: Text(active ? 'Aktif' : 'Nonaktif'),
        onTap: canManage
            ? () => _showActions(context)
            : null,
      ),
    );
  }

  void _showActions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Ubah data (nama/peran/gaji)'),
              onTap: () {
                Navigator.of(ctx).pop();
                onEdit();
              },
            ),
            ListTile(
              leading: const Icon(Icons.pin),
              title: const Text('Atur / ubah PIN'),
              subtitle: const Text('Hanya Owner. PIN disimpan hash.'),
              onTap: () {
                Navigator.of(ctx).pop();
                onSetPin();
              },
            ),
            ListTile(
              leading: Icon(
                employee.isActive == 1
                    ? Icons.person_off
                    : Icons.person_add,
              ),
              title: Text(
                employee.isActive == 1
                    ? 'Nonaktifkan karyawan'
                    : 'Aktifkan kembali',
              ),
              onTap: () {
                Navigator.of(ctx).pop();
                onToggleActive();
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tab Absensi
// ---------------------------------------------------------------------------

class _AttendanceTab extends ConsumerStatefulWidget {
  const _AttendanceTab({required this.onChanged});
  final VoidCallback onChanged;

  @override
  ConsumerState<_AttendanceTab> createState() => _AttendanceTabState();
}

class _AttendanceTabState extends ConsumerState<_AttendanceTab> {
  String? _selectedId;
  final _pinCtrl = TextEditingController();
  var _busy = false;
  String? _result;
  String _recapPeriod = currentPeriod();

  @override
  void dispose() {
    _pinCtrl.dispose();
    super.dispose();
  }

  Future<void> _clock(bool checkIn) async {
    if (_selectedId == null) {
      setState(() => _result = 'Pilih karyawan dulu.');
      return;
    }
    setState(() {
      _busy = true;
      _result = null;
    });
    try {
      final db = ref.read(databaseProvider);
      final row = checkIn
          ? await StaffService.clockIn(
              db,
              employeeId: _selectedId!,
              pin: _pinCtrl.text,
            )
          : await StaffService.clockOut(
              db,
              employeeId: _selectedId!,
              pin: _pinCtrl.text,
            );
      _pinCtrl.clear();
      widget.onChanged();
      setState(() {
        _result = checkIn
            ? 'Check-in tercatat ${_fmtTime(row.clockIn!)}.'
            : 'Check-out tercatat ${_fmtTime(row.clockOut!)} '
                '(${fmtWorkMinutes(StaffService.workMinutes(row))} kerja).';
      });
    } on PinLockedException catch (e) {
      setState(() => _result = e.toString());
    } catch (e) {
      setState(() => _result = 'Gagal: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final employeesAsync = ref.watch(employeesProvider);
    final settingsAsync = ref.watch(posSettingsProvider);
    final workStart = settingsAsync.value?.workStartTime ?? '08:00';
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Absensi PIN',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'Jam masuk: $workStart (diubah di Pengaturan). '
                  'Check-in setelah jam ini dihitung telat.',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 12),
                employeesAsync.when(
                  data: (employees) => DropdownButtonFormField<String>(
                    initialValue: _selectedId,
                    decoration: const InputDecoration(
                      labelText: 'Karyawan',
                      border: OutlineInputBorder(),
                    ),
                    items: employees
                        .map(
                          (e) => DropdownMenuItem(
                            value: e.id,
                            child: Text(
                              '${e.name} (${roleFromString(e.role).label})',
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() {
                      _selectedId = v;
                      _result = null;
                    }),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Gagal memuat karyawan: $e'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _pinCtrl,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: const InputDecoration(
                    labelText: 'PIN karyawan (4-6 digit)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: _busy ? null : () => _clock(true),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                        ),
                        child: const Text('Check-in'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _busy ? null : () => _clock(false),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                        ),
                        child: const Text('Check-out'),
                      ),
                    ),
                  ],
                ),
                if (_result != null) ...[
                  const SizedBox(height: 12),
                  Text(_result!),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        _TodayList(onChanged: widget.onChanged),
        const SizedBox(height: 12),
        _RecapCard(
          period: _recapPeriod,
          workStart: workStart,
          onPeriodChanged: (p) => setState(() => _recapPeriod = p),
        ),
      ],
    );
  }

  static String _fmtTime(int epochMs) {
    final d = DateTime.fromMillisecondsSinceEpoch(epochMs);
    return DateFormat('HH:mm', 'id_ID').format(d);
  }
}

/// Absensi hari ini (semua karyawan aktif).
class _TodayList extends ConsumerWidget {
  const _TodayList({required this.onChanged});
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(staffVersionProvider);
    final db = ref.watch(databaseProvider);
    return FutureBuilder<Map<String, AttendanceRow?>>(
      future: StaffService.todayAttendance(db),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Text('Gagal memuat absensi: ${snap.error}');
        }
        final map = snap.data ?? {};
        return FutureBuilder<List<Employee>>(
          future: StaffService.allEmployees(db),
          builder: (context, empSnap) {
            final employees = (empSnap.data ?? [])
                .where((e) => e.isActive == 1)
                .toList();
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Hari ini — ${DateFormat('EEEE, dd MMM yyyy', 'id_ID').format(DateTime.now())}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    if (employees.isEmpty)
                      const Text('Belum ada karyawan aktif.')
                    else
                      for (final e in employees)
                        _TodayRow(
                          employee: e,
                          row: map[e.id],
                        ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _TodayRow extends StatelessWidget {
  const _TodayRow({required this.employee, required this.row});
  final Employee employee;
  final AttendanceRow? row;

  String _time(int? ms) {
    if (ms == null) return '—';
    return DateFormat(
      'HH:mm',
      'id_ID',
    ).format(DateTime.fromMillisecondsSinceEpoch(ms));
  }

  @override
  Widget build(BuildContext context) {
    final r = row;
    final status = r == null
        ? 'Belum check-in'
        : r.clockOut != null
            ? 'Selesai (${fmtWorkMinutes(StaffService.workMinutes(r))})'
            : 'Masuk ${_time(r.clockIn)} — belum check-out';
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(employee.name),
      subtitle: Text(status),
      trailing: r != null && r.clockIn != null && r.clockOut == null
          ? const Chip(label: Text('Belum check-out'))
          : null,
    );
  }
}

/// Rekap kehadiran per karyawan per periode.
class _RecapCard extends ConsumerWidget {
  const _RecapCard({
    required this.period,
    required this.workStart,
    required this.onPeriodChanged,
  });
  final String period;
  final String workStart;
  final void Function(String period) onPeriodChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(staffVersionProvider);
    final db = ref.watch(databaseProvider);
    return FutureBuilder<List<Employee>>(
      future: StaffService.allEmployees(db),
      builder: (context, snap) {
        final employees = snap.data ?? [];
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
                        'Rekap ${periodLabel(period)}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime(
                            int.parse(period.split('-')[0]),
                            int.parse(period.split('-')[1]),
                          ),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now().add(
                            const Duration(days: 366),
                          ),
                        );
                        if (picked != null) {
                          onPeriodChanged(
                            '${picked.year}-${picked.month.toString().padLeft(2, '0')}',
                          );
                        }
                      },
                      child: const Text('Ganti Periode'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (employees.isEmpty)
                  const Text('Belum ada karyawan.')
                else
                  for (final e in employees)
                    _RecapRow(
                      employee: e,
                      period: period,
                      workStart: workStart,
                    ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RecapRow extends ConsumerWidget {
  const _RecapRow({
    required this.employee,
    required this.period,
    required this.workStart,
  });
  final Employee employee;
  final String period;
  final String workStart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return FutureBuilder<AttendanceRecap>(
      future: StaffService.recap(db, employee.id, period),
      builder: (context, snap) {
        final recap = snap.data;
        final days = recap?.daysPresent ?? 0;
        final minutes = recap?.totalMinutes ?? 0;
        final late = recap?.lateDays ?? 0;
        final missing = recap?.notCheckedOutDays ?? 0;
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(employee.name),
          subtitle: Text(
            'Hadir $days hari • ${fmtWorkMinutes(minutes)}'
            '${late > 0 ? ' • Telat $late hari' : ''}'
            '${missing > 0 ? ' • $missing hari belum check-out' : ''}'
            '${employee.isActive != 1 ? ' • Nonaktif' : ''}',
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Tab Payroll
// ---------------------------------------------------------------------------

class _PayrollTab extends ConsumerStatefulWidget {
  const _PayrollTab({
    required this.period,
    required this.canProcess,
    required this.onPeriodChanged,
    required this.onChanged,
  });
  final String period;
  final bool canProcess;
  final void Function(String period) onPeriodChanged;
  final VoidCallback onChanged;

  @override
  ConsumerState<_PayrollTab> createState() => _PayrollTabState();
}

class _PayrollTabState extends ConsumerState<_PayrollTab> {
  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    ref.watch(staffVersionProvider);
    return FutureBuilder<List<Employee>>(
      future: StaffService.allEmployees(db),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(child: Text('Gagal memuat karyawan: ${snap.error}'));
        }
        final employees = snap.data ?? [];
        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Payroll ${periodLabel(widget.period)}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime(
                                int.parse(widget.period.split('-')[0]),
                                int.parse(widget.period.split('-')[1]),
                              ),
                              firstDate: DateTime(2020),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 366)),
                            );
                            if (picked != null) {
                              widget.onPeriodChanged(
                                '${picked.year}-${picked.month.toString().padLeft(2, '0')}',
                              );
                            }
                          },
                          child: const Text('Ganti Periode'),
                        ),
                      ],
                    ),
                    const Text(
                      'Bulanan = gaji pokok. Harian = tarif harian x hari '
                      'hadir (dari absensi). Tambahan/potongan manual wajib '
                      'disertai alasan. Proses gaji menjurnal otomatis '
                      'D 5130 / K 1000 (tunai) atau K 1010 (bank).',
                      style: TextStyle(fontSize: 12),
                    ),
                    if (!widget.canProcess)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          'Anda login sebagai Manager: bisa melihat payroll '
                          'dan slip, tapi tombol "Proses Gaji" hanya untuk '
                          'Owner.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (employees.isEmpty)
              const EmptyState(message: 'Belum ada karyawan.')
            else
              for (final e in employees)
                _PayrollRow(
                  employee: e,
                  period: widget.period,
                  canProcess: widget.canProcess,
                  onChanged: widget.onChanged,
                ),
          ],
        );
      },
    );
  }
}

class _PayrollRow extends ConsumerWidget {
  const _PayrollRow({
    required this.employee,
    required this.period,
    required this.canProcess,
    required this.onChanged,
  });
  final Employee employee;
  final String period;
  final bool canProcess;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return FutureBuilder<Payroll?>(
      future: StaffService.payrollFor(db, employee.id, period),
      builder: (context, paySnap) {
        final payroll = paySnap.data;
        return FutureBuilder<AttendanceRecap>(
          future: StaffService.recap(db, employee.id, period),
          builder: (context, recapSnap) {
            final recap = recapSnap.data;
            final days = recap?.daysPresent ?? 0;
            final calc = StaffService.computePay(
              employee: employee,
              daysPresent: days,
            );
            final processed = payroll != null;
            return Card(
              child: ListTile(
                title: Text(employee.name),
                subtitle: Text(
                  processed
                      ? 'Diproses — bersih ${fmt(payroll.netPay)}'
                          '${employee.isActive != 1 ? ' • Nonaktif' : ''}'
                      : employee.isActive != 1
                          ? 'Belum diproses — karyawan nonaktif (gaji tidak bisa diproses)'
                          : 'Belum diproses — perkiraan ${fmt(calc.pokok)} '
                              '(hadir $days hari)',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Chip(
                      label: Text(processed ? 'Diproses' : 'Belum'),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      tooltip: processed
                          ? 'Lihat slip gaji'
                          : 'Proses gaji',
                      icon: Icon(
                        processed ? Icons.receipt_long : Icons.payments,
                      ),
                      onPressed: () {
                        final p = payroll;
                        if (processed && p != null) {
                          _showSlip(context, ref, p);
                        } else {
                          _processForm(context, ref, days);
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showSlip(
    BuildContext context,
    WidgetRef ref,
    Payroll payroll,
  ) async {
    final db = ref.read(databaseProvider);
    final settings = await ref.read(posSettingsProvider.future);
    final recap = await StaffService.recap(db, employee.id, period);
    final text = StaffService.slipText(
      storeName: settings.storeName,
      employee: employee,
      payroll: payroll,
      daysPresent: recap.daysPresent,
      totalMinutes: recap.totalMinutes,
      lateDays: recap.lateDays,
    );
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Slip Gaji'),
        content: SingleChildScrollView(child: Text(text)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Tutup'),
          ),
          FilledButton.icon(
            onPressed: () {
              SharePlus.instance.share(
                ShareParams(text: text, subject: 'Slip Gaji ${employee.name}'),
              );
            },
            icon: const Icon(Icons.share),
            label: const Text('Bagikan Slip'),
          ),
        ],
      ),
    );
  }

  Future<void> _processForm(
    BuildContext context,
    WidgetRef ref,
    int daysPresent,
  ) async {
    if (!canProcess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Proses gaji hanya bisa dilakukan Owner.'),
        ),
      );
      return;
    }
    if (employee.isActive != 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Karyawan nonaktif — gaji tidak bisa diproses.',
          ),
        ),
      );
      return;
    }
    final calc = StaffService.computePay(
      employee: employee,
      daysPresent: daysPresent,
    );
    var additions = 0;
    var deductions = 0;
    var payFrom = 'tunai';
    final additionsCtrl = TextEditingController();
    final additionsNoteCtrl = TextEditingController();
    final deductionsCtrl = TextEditingController();
    final deductionsNoteCtrl = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final net = calc.pokok + additions - deductions;
          return AlertDialog(
            title: Text('Proses Gaji — ${employee.name}'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Periode: ${periodLabel(period)}'),
                  Text(
                    'Tipe: ${employee.salaryType == 'harian' ? 'Harian' : 'Bulanan'}',
                  ),
                  Text(
                    'Gaji pokok: ${fmt(calc.pokok)}'
                    '${employee.salaryType == 'harian' ? ' (tarif ${fmt(employee.baseSalary)} x $daysPresent hari hadir)' : ''}',
                  ),
                  const SizedBox(height: 12),
                  RpInput(
                    controller: additionsCtrl,
                    label: 'Tambahan (Rp)',
                    onChanged: (v) => setDialogState(() => additions = v),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: additionsNoteCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Alasan tambahan',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  RpInput(
                    controller: deductionsCtrl,
                    label: 'Potongan (Rp)',
                    onChanged: (v) => setDialogState(() => deductions = v),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: deductionsNoteCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Alasan potongan',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: payFrom,
                    decoration: const InputDecoration(
                      labelText: 'Dibayar dari',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'tunai',
                        child: Text('Tunai (K 1000)'),
                      ),
                      DropdownMenuItem(
                        value: 'bank',
                        child: Text('Bank (K 1010)'),
                      ),
                    ],
                    onChanged: (v) {
                      if (v != null) setDialogState(() => payFrom = v);
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Gaji bersih: ${fmt(net)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (net < 0)
                    const Text(
                      'Gaji bersih negatif — kurangi potongan.',
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Batal'),
              ),
              FilledButton(
                onPressed: net < 0 ? null : () => Navigator.of(ctx).pop(true),
                child: const Text('Proses Gaji'),
              ),
            ],
          );
        },
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      final db = ref.read(databaseProvider);
      await StaffService.processPayroll(
        db,
        employeeId: employee.id,
        period: period,
        additions: additions,
        additionsNote: additionsNoteCtrl.text,
        deductions: deductions,
        deductionsNote: deductionsNoteCtrl.text,
        payFrom: payFrom,
      );
      onChanged();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gaji ${employee.name} ${periodLabel(period)} diproses '
              '(D 5130 / K ${payFrom == 'bank' ? '1010' : '1000'}).',
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memproses gaji: $e')),
        );
      }
    }
  }
}
