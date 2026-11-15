// Casirz ERP — Fase 5 (Modul D Staf).
// Lock screen + setup PIN owner pertama + absensi dari layar kunci.
//
// - Lock screen: pilih karyawan -> PIN (4-6 digit) -> masuk. 3x salah
//   -> kunci 1 menit (pesan jelas + hitung mundur).
// - Setup owner: saat ada karyawan tapi belum ada owner ber-PIN, layar
//   ini WAJIB dilewati sebelum menu lain bisa dipakai. TIDAK ADA PIN
//   BAWAAN: owner membuat PIN-nya sendiri di sini (2x ketik).
// - Absensi dari layar kunci: karyawan bisa check-in/check-out pakai
//   PIN tanpa masuk penuh ke aplikasi (mode kiosk).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/db.dart';
import '../pos/pos_providers.dart';
import 'auth.dart';
import 'staff_providers.dart';
import 'staff_service.dart';

/// Keypad PIN 4-6 digit (tombol >= 56px). [onSubmit] dipanggil saat
/// tombol aksi ditekan dengan PIN sepanjang 4-6 digit.
class PinPad extends StatefulWidget {
  const PinPad({
    super.key,
    required this.onSubmit,
    this.submitLabel = 'Masuk',
    this.enabled = true,
  });

  final void Function(String pin) onSubmit;
  final String submitLabel;
  final bool enabled;

  @override
  State<PinPad> createState() => _PinPadState();
}

class _PinPadState extends State<PinPad> {
  var _pin = '';

  void _press(String d) {
    if (!widget.enabled) return;
    if (_pin.length >= 6) return;
    setState(() => _pin += d);
  }

  void _backspace() {
    if (!widget.enabled) return;
    if (_pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(6, (i) {
            final filled = i < _pin.length;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: filled
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 2.2,
          children: [
            for (final d in ['1', '2', '3', '4', '5', '6', '7', '8', '9'])
              _KeyButton(label: d, onTap: () => _press(d)),
            _KeyButton(label: 'C', onTap: () => setState(() => _pin = '')),
            _KeyButton(label: '0', onTap: () => _press('0')),
            _KeyButton(icon: Icons.backspace_outlined, onTap: _backspace),
          ],
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: widget.enabled && _pin.length >= 4
              ? () {
                  widget.onSubmit(_pin);
                  setState(() => _pin = '');
                }
              : null,
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
          ),
          child: Text(widget.submitLabel),
        ),
      ],
    );
  }
}

class _KeyButton extends StatelessWidget {
  const _KeyButton({this.label, this.icon, required this.onTap});
  final String? label;
  final IconData? icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 56),
          padding: EdgeInsets.zero,
        ),
        child: icon != null
            ? Icon(icon)
            : Text(
                label ?? '',
                style: const TextStyle(fontSize: 22),
              ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Lock screen
// ---------------------------------------------------------------------------

class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  var _modeLogin = true; // false = mode absensi
  String? _selectedId;
  String? _verifiedPin; // PIN yang baru diverifikasi (mode absensi saja,
  // hanya di memori, dihapus saat ganti nama/mode) — supaya check-in/out
  // tidak minta PIN dua kali.
  var _busy = false;
  String? _error;
  String? _attendanceResult;
  AttendanceRow? _todayRow;
  var _attendanceVerified = false; // PIN terverifikasi (mode absensi)

  void _resetSelection() {
    _selectedId = null;
    _verifiedPin = null;
    _error = null;
    _attendanceResult = null;
    _todayRow = null;
    _attendanceVerified = false;
  }

  Future<void> _submitPin(String pin) async {
    final id = _selectedId;
    if (id == null || _busy) return;
    setState(() {
      _busy = true;
      _error = null;
      _attendanceResult = null;
    });
    try {
      final db = ref.read(databaseProvider);
      final auth = ref.read(authServiceProvider);
      final ok = await auth.verifyPin(db, id, pin);
      if (!ok) {
        final left = AuthService.maxAttempts - auth.failCount(id);
        setState(() {
          _error = 'PIN salah. Sisa percobaan: $left.';
        });
        return;
      }
      final employee = await (db.select(db.employees)
            ..where((e) => e.id.equals(id)))
          .getSingle();
      if (_modeLogin) {
        ref.read(sessionProvider.notifier).unlock(employee);
      } else {
        final row = await StaffService.attendanceForDay(
          db,
          id,
          DateTime.now(),
        );
        setState(() {
          _todayRow = row;
          _verifiedPin = pin;
          _attendanceVerified = true;
        });
      }
    } on PinLockedException catch (e) {
      setState(() => _error = e.toString());
    } on PinNotSetException catch (e) {
      setState(() => _error = e.toString());
    } catch (e) {
      setState(() => _error = 'Gagal: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _clockInOut(bool checkIn) async {
    final id = _selectedId;
    final pin = _verifiedPin;
    if (id == null || pin == null || _busy) return;
    setState(() {
      _busy = true;
      _error = null;
      _attendanceResult = null;
    });
    try {
      final db = ref.read(databaseProvider);
      final row = checkIn
          ? await StaffService.clockIn(db, employeeId: id, pin: pin)
          : await StaffService.clockOut(db, employeeId: id, pin: pin);
      setState(() {
        _todayRow = row;
        _attendanceResult = checkIn
            ? 'Check-in tercatat ${_fmtTime(row.clockIn!)}.'
            : 'Check-out tercatat ${_fmtTime(row.clockOut!)} '
                '(${fmtWorkMinutes(StaffService.workMinutes(row))} kerja).';
      });
    } on PinLockedException catch (e) {
      setState(() => _error = e.toString());
    } catch (e) {
      setState(() => _error = 'Gagal: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final employeesAsync = ref.watch(employeesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(_modeLogin ? 'Masuk dengan PIN' : 'Absensi'),
        actions: [
          TextButton(
            onPressed: () => setState(() {
              _modeLogin = !_modeLogin;
              _resetSelection();
            }),
            child: Text(_modeLogin ? 'Absensi' : 'Masuk Aplikasi'),
          ),
        ],
      ),
      body: employeesAsync.when(
        data: (employees) {
          final withPin =
              employees.where((e) => e.pinHash.isNotEmpty).toList();
          if (withPin.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Belum ada karyawan yang PIN-nya diatur.\n'
                  'Minta Owner mengatur PIN di menu Staf.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          final selected = _selectedId == null
              ? null
              : withPin.where((e) => e.id == _selectedId).firstOrNull;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Pilih nama, lalu masukkan PIN (4-6 digit). '
                'Tidak ada PIN bawaan — PIN diatur Owner untuk tiap '
                'karyawan.',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 12),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Lupa PIN? Minta owner yang sedang login untuk mengatur '
                    'ulang PIN Anda di menu Staf. Bila Anda satu-satunya '
                    'owner dan lupa PIN, satu-satunya jalan adalah reset '
                    'data total (Pengaturan → Reset Data) — semua data '
                    'akan hilang.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ...withPin.map(
                (e) => Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(e.name.isEmpty ? '?' : e.name[0]),
                    ),
                    title: Text(e.name),
                    subtitle: Text(roleFromString(e.role).label),
                    trailing: _selectedId == e.id
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () => setState(() {
                      _resetSelection();
                      _selectedId = e.id;
                    }),
                  ),
                ),
              ),
              if (selected != null) ...[
                const SizedBox(height: 16),
                Text(
                  _modeLogin
                      ? 'PIN ${selected.name}:'
                      : 'PIN ${selected.name} (untuk absensi):',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                PinPad(
                  onSubmit: _submitPin,
                  submitLabel: _modeLogin ? 'Masuk' : 'Verifikasi PIN',
                  enabled: !_busy,
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                if (!_modeLogin && _attendanceVerified) ...[
                  const SizedBox(height: 16),
                  _TodayAttendanceCard(
                    row: _todayRow,
                    onCheckIn: _todayRow == null ||
                            _todayRow!.clockIn == null
                        ? () => _clockInOut(true)
                        : null,
                    onCheckOut: _todayRow != null &&
                            _todayRow!.clockIn != null &&
                            _todayRow!.clockOut == null
                        ? () => _clockInOut(false)
                        : null,
                    busy: _busy,
                  ),
                ],
                if (_attendanceResult != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _attendanceResult!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Gagal memuat karyawan: $e')),
      ),
    );
  }

  static String _fmtTime(int epochMs) {
    final d = DateTime.fromMillisecondsSinceEpoch(epochMs);
    return DateFormat('HH:mm', 'id_ID').format(d);
  }
}

class _TodayAttendanceCard extends StatelessWidget {
  const _TodayAttendanceCard({
    required this.row,
    required this.onCheckIn,
    required this.onCheckOut,
    required this.busy,
  });
  final AttendanceRow? row;
  final VoidCallback? onCheckIn;
  final VoidCallback? onCheckOut;
  final bool busy;

  String _time(int? ms) {
    if (ms == null) return '—';
    return DateFormat(
      'HH:mm',
      'id_ID',
    ).format(DateTime.fromMillisecondsSinceEpoch(ms));
  }

  @override
  Widget build(BuildContext context) {
    final minutes = row == null ? 0 : StaffService.workMinutes(row!);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Absensi hari ini',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text('Check-in: ${_time(row?.clockIn)}'),
            Text('Check-out: ${_time(row?.clockOut)}'),
            if (row != null &&
                row!.clockIn != null &&
                row!.clockOut == null)
              const Text(
                'Belum check-out — jam kerja dihitung 0 sampai check-out.',
                style: TextStyle(fontSize: 12),
              ),
            if (row?.clockOut != null)
              Text(
                'Total kerja: ${fmtWorkMinutes(minutes)}',
              ),
            const SizedBox(height: 12),
            if (onCheckIn != null)
              FilledButton(
                onPressed: busy ? null : onCheckIn,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text('Check-in'),
              ),
            if (onCheckOut != null)
              FilledButton(
                onPressed: busy ? null : onCheckOut,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text('Check-out'),
              ),
            if (onCheckIn == null && onCheckOut == null)
              const Text('Absensi hari ini sudah lengkap.'),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Setup PIN owner pertama
// ---------------------------------------------------------------------------

/// Ditampilkan saat ada karyawan tapi belum ada owner ber-PIN.
/// Owner membuat PIN-nya sendiri (ketik 2x). Setelah berhasil, langsung
/// masuk sebagai owner tersebut.
class OwnerSetupScreen extends ConsumerStatefulWidget {
  const OwnerSetupScreen({super.key});

  @override
  ConsumerState<OwnerSetupScreen> createState() => _OwnerSetupScreenState();
}

class _OwnerSetupScreenState extends ConsumerState<OwnerSetupScreen> {
  String? _selectedOwnerId;
  String? _firstPin;
  var _step = 0; // 0 = pilih owner / isi nama, 1 = PIN, 2 = konfirmasi PIN
  var _busy = false;
  String? _error;
  String? _message;
  final _nameCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _savePin(String pin) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final db = ref.read(databaseProvider);
      String ownerId;
      Employee owner;
      if (_selectedOwnerId != null) {
        ownerId = _selectedOwnerId!;
        owner = await (db.select(db.employees)
              ..where((e) => e.id.equals(ownerId)))
            .getSingle();
      } else {
        // Belum ada owner sama sekali — buat owner baru.
        final name = _nameCtrl.text.trim();
        if (name.isEmpty) {
          throw ArgumentError('Nama owner wajib diisi.');
        }
        ownerId = await StaffService.createEmployee(
          db,
          name: name,
          role: 'owner',
        );
        owner = await (db.select(db.employees)
              ..where((e) => e.id.equals(ownerId)))
            .getSingle();
      }
      await ref.read(authServiceProvider).setPin(db, ownerId, pin);
      await ref.read(sessionProvider.notifier).refresh();
      ref.read(sessionProvider.notifier).unlock(owner);
      ref.read(staffVersionProvider.notifier).state++;
      setState(() {
        _message = 'PIN owner berhasil dibuat. Selamat datang, ${owner.name}.';
      });
    } catch (e) {
      setState(() => _error = 'Gagal menyimpan PIN: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final employeesAsync = ref.watch(employeesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Buat PIN Owner')),
      body: employeesAsync.when(
        data: (employees) {
          final ownersWithoutPin = employees
              .where((e) => e.role == 'owner' && e.pinHash.isEmpty)
              .toList();
          final noOwnerAtAll =
              !employees.any((e) => e.role == 'owner');
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Aplikasi ini belum punya PIN owner. Buat PIN owner dulu '
                'sebelum menu lain bisa dipakai.\n'
                'Tidak ada PIN bawaan — PIN ini yang akan dipakai Owner '
                'untuk masuk, dan Owner yang mengatur PIN karyawan lain.',
              ),
              const SizedBox(height: 16),
              if (noOwnerAtAll) ...[
                TextField(
                  controller: _nameCtrl,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    labelText: 'Nama owner',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
              ] else ...[
                const Text(
                  'Pilih owner yang akan dibuat PIN-nya:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...ownersWithoutPin.map(
                  (e) => Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(e.name.isEmpty ? '?' : e.name[0]),
                      ),
                      title: Text(e.name),
                      subtitle: const Text('Owner'),
                      trailing: _selectedOwnerId == e.id
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                      onTap: () => setState(() {
                        _selectedOwnerId = e.id;
                        _error = null;
                      }),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              if ((noOwnerAtAll && _nameCtrl.text.isNotEmpty) ||
                  _selectedOwnerId != null) ...[
                if (_step == 0)
                  FilledButton(
                    onPressed: () => setState(() => _step = 1),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text('Lanjut Buat PIN'),
                  ),
                if (_step == 1) ...[
                  const Text(
                    'Masukkan PIN baru (4-6 digit angka):',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  PinPad(
                    submitLabel: 'Lanjut',
                    enabled: !_busy,
                    onSubmit: (pin) {
                      setState(() {
                        _firstPin = pin;
                        _step = 2;
                      });
                    },
                  ),
                ],
                if (_step == 2) ...[
                  const Text(
                    'Ketik ulang PIN yang sama untuk konfirmasi:',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  PinPad(
                    submitLabel: 'Simpan PIN',
                    enabled: !_busy,
                    onSubmit: (pin) {
                      if (pin != _firstPin) {
                        setState(() {
                          _error =
                              'PIN tidak sama. Ulangi dari awal.';
                          _step = 1;
                          _firstPin = null;
                        });
                        return;
                      }
                      _savePin(pin);
                    },
                  ),
                ],
              ],
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (_message != null) ...[
                const SizedBox(height: 12),
                Text(_message!, textAlign: TextAlign.center),
              ],
              const SizedBox(height: 16),
              const Text(
                'Catatan: PIN disimpan dalam bentuk hash (SHA-256 + salt), '
                'bukan PIN mentah. Kalau PIN lupa, tidak ada jalan pintas '
                'di aplikasi — Owner lain / reset data yang bisa '
                'memulihkannya.',
                style: TextStyle(fontSize: 12),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Gagal memuat karyawan: $e')),
      ),
    );
  }
}
