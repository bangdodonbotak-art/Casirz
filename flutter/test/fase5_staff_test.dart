// Casirz ERP — Fase 5 (Modul D Staf) tests.
// PIN (hash + kunci 3x salah 1 menit) + RBAC + absensi PIN +
// payroll (bulanan/harian, idempotent, nonaktif ditolak) + skema v2
// + lock screen / setup owner / RBAC shell (widget).
import 'dart:ui';

import 'package:casirz/app.dart';
import 'package:casirz/core/accounting_service.dart';
import 'package:casirz/core/db.dart';
import 'package:casirz/core/money.dart';
import 'package:casirz/features/staff/auth.dart';
import 'package:casirz/features/staff/staff_service.dart';
import 'package:drift/drift.dart' hide Column, isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<String> addEmployee(
  AppDatabase db, {
  String name = 'Kasir 1',
  String role = 'kasir',
  String salaryType = 'bulanan',
  int baseSalary = 1500000,
}) {
  return StaffService.createEmployee(
    db,
    name: name,
    role: role,
    salaryType: salaryType,
    baseSalary: baseSalary,
  );
}

Future<int> payrollJournalCount(AppDatabase db) async {
  final rows = await (db.select(db.journals)
        ..where((j) => j.refType.equals('payroll')))
      .get();
  return rows.length;
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  late AppDatabase db;
  var dbClosed = false;

  setUp(() {
    db = AppDatabase.memory();
    dbClosed = false;
  });

  tearDown(() async {
    // Widget test menutup DB di akhir body (seperti widget_test.dart) —
    // supaya stream Drift sudah tertutup sebelum tree di-dispose dan
    // tidak ada Timer pending di akhir test. Unit test ditutup di sini.
    if (!dbClosed) {
      await db.close();
    }
  });

  /// Tutup DB di akhir body widget test (sebelum tree di-dispose).
  Future<void> closeDbInBody() async {
    await db.close();
    dbClosed = true;
  }

  group('hash PIN (SHA-256 + salt)', () {
    test('PIN sama, salt beda -> hash beda; PIN mentah tidak tersimpan',
        () async {
      final h1 = AuthService.createPinHash('1234');
      final h2 = AuthService.createPinHash('1234');
      expect(h1, isNot(h2));
      expect(h1.contains('1234'), isFalse);
      expect(h2.contains('1234'), isFalse);
      expect(h1.contains(':'), isTrue);
      expect(AuthService.checkPinHash('1234', h1), isTrue);
      expect(AuthService.checkPinHash('1234', h2), isTrue);
      expect(AuthService.checkPinHash('4321', h1), isFalse);
      expect(AuthService.checkPinHash('1234', ''), isFalse);
      expect(AuthService.checkPinHash('1234', 'bukan-format-hash'), isFalse);
    });

    test('format PIN ditolak: <4, >6, bukan angka', () async {
      final id = await addEmployee(db);
      final auth = AuthService();
      await expectLater(() => auth.setPin(db, id, '123'), throwsArgumentError);
      await expectLater(() => auth.setPin(db, id, '1234567'), throwsArgumentError);
      await expectLater(() => auth.setPin(db, id, '12a4'), throwsArgumentError);
      await expectLater(() => auth.setPin(db, id, ''), throwsArgumentError);
      // PIN tidak jadi tersimpan.
      final e = await (db.select(db.employees)
            ..where((x) => x.id.equals(id)))
          .getSingle();
      expect(e.pinHash, isEmpty);
    });
  });

  group('verifikasi PIN + kunci 3x salah', () {
    test('PIN benar -> masuk, PIN salah -> ditolak', () async {
      final id = await addEmployee(db);
      final auth = AuthService();
      await auth.setPin(db, id, '1234');
      expect(await auth.verifyPin(db, id, '1234'), isTrue);
      expect(await auth.verifyPin(db, id, '0000'), isFalse);
    });

    test('PIN belum diatur -> PinNotSetException', () async {
      final id = await addEmployee(db);
      final auth = AuthService();
      await expectLater(
        () => auth.verifyPin(db, id, '1234'),
        throwsA(isA<PinNotSetException>()),
      );
    });

    test('3x salah -> kunci 1 menit; jam palsu +61 detik -> bisa lagi',
        () async {
      var now = DateTime(2026, 11, 15, 8, 0);
      final auth = AuthService(now: () => now);
      final id = await addEmployee(db);
      await auth.setPin(db, id, '1234');
      expect(await auth.verifyPin(db, id, '0000'), isFalse);
      expect(await auth.verifyPin(db, id, '0000'), isFalse);
      await expectLater(
        () => auth.verifyPin(db, id, '0000'),
        throwsA(isA<PinLockedException>()),
      );
      expect(auth.isLocked(id), isTrue);
      // PIN benar pun ditolak selama terkunci.
      await expectLater(
        () => auth.verifyPin(db, id, '1234'),
        throwsA(isA<PinLockedException>()),
      );
      // Maju 61 detik: kunci kedaluwarsa, PIN benar masuk lagi.
      now = now.add(const Duration(seconds: 61));
      expect(auth.isLocked(id), isFalse);
      expect(await auth.verifyPin(db, id, '1234'), isTrue);
    });

    test('PIN benar me-reset penghitung salah', () async {
      final auth = AuthService();
      final id = await addEmployee(db);
      await auth.setPin(db, id, '1234');
      expect(await auth.verifyPin(db, id, '0000'), isFalse);
      expect(await auth.verifyPin(db, id, '0000'), isFalse);
      expect(await auth.verifyPin(db, id, '1234'), isTrue);
      // Setelah sukses, 2x salah lagi belum mengunci.
      expect(await auth.verifyPin(db, id, '0000'), isFalse);
      expect(await auth.verifyPin(db, id, '0000'), isFalse);
      expect(auth.isLocked(id), isFalse);
      expect(await auth.verifyPin(db, id, '1234'), isTrue);
    });
  });

  group('RBAC', () {
    test('matriks hak akses menu per peran', () {
      const owner = StaffRole.owner;
      const manager = StaffRole.manager;
      const kasir = StaffRole.kasir;
      for (final m in MenuId.values) {
        expect(owner.canAccess(m), isTrue, reason: 'owner-$m');
      }
      expect(manager.canAccess(MenuId.akuntansi), isFalse);
      expect(manager.canAccess(MenuId.bahan), isTrue);
      expect(manager.canAccess(MenuId.laporan), isTrue);
      expect(manager.canAccess(MenuId.staf), isTrue);
      expect(manager.canAccess(MenuId.pengaturan), isTrue);
      expect(kasir.canAccess(MenuId.kasir), isTrue);
      expect(kasir.canAccess(MenuId.meja), isTrue);
      expect(kasir.canAccess(MenuId.transaksi), isTrue);
      expect(kasir.canAccess(MenuId.shift), isTrue);
      expect(kasir.canAccess(MenuId.akuntansi), isFalse);
      expect(kasir.canAccess(MenuId.staf), isFalse);
      expect(kasir.canAccess(MenuId.bahan), isFalse);
      expect(kasir.canAccess(MenuId.laporan), isFalse);
      expect(kasir.canAccess(MenuId.pengaturan), isFalse);
    });

    test('hanya Owner: kelola karyawan + proses gaji', () {
      expect(StaffRole.owner.canManageEmployees, isTrue);
      expect(StaffRole.manager.canManageEmployees, isFalse);
      expect(StaffRole.kasir.canManageEmployees, isFalse);
      expect(StaffRole.owner.canProcessPayroll, isTrue);
      expect(StaffRole.manager.canProcessPayroll, isFalse);
      expect(StaffRole.kasir.canProcessPayroll, isFalse);
      expect(StaffRole.manager.canViewPayroll, isTrue);
      expect(StaffRole.kasir.canViewPayroll, isFalse);
    });

    test('pesan kunci menjelaskan peran yang dibutuhkan', () {
      final msg = MenuId.akuntansi.lockedReason(StaffRole.kasir);
      expect(msg.contains('Owner'), isTrue);
      expect(msg.contains('Kasir'), isTrue);
    });
  });

  group('karyawan', () {
    test('tambah + ubah gaji + nonaktifkan (tombstone)', () async {
      final id = await addEmployee(
        db,
        name: 'Budi',
        role: 'manager',
        salaryType: 'harian',
        baseSalary: 100000,
      );
      var e = await (db.select(db.employees)..where((x) => x.id.equals(id)))
          .getSingle();
      expect(e.salaryType, 'harian');
      expect(e.baseSalary, 100000);
      await StaffService.updateEmployee(
        db,
        id,
        baseSalary: 120000,
      );
      e = await (db.select(db.employees)..where((x) => x.id.equals(id)))
          .getSingle();
      expect(e.baseSalary, 120000);
      await StaffService.setEmployeeActive(db, id, false);
      e = await (db.select(db.employees)..where((x) => x.id.equals(id)))
          .getSingle();
      expect(e.isActive, 0);
      // Baris tetap ada (bukan hapus fisik).
      final all = await StaffService.allEmployees(db);
      expect(all.any((x) => x.id == id), isTrue);
    });

    test('validasi: nama kosong, peran salah, gaji negatif ditolak',
        () async {
      await expectLater(
        () => StaffService.createEmployee(db, name: ' ', role: 'kasir'),
        throwsArgumentError,
      );
      await expectLater(
        () => StaffService.createEmployee(db, name: 'A', role: 'bos'),
        throwsArgumentError,
      );
      await expectLater(
        () => StaffService.createEmployee(
          db,
          name: 'A',
          role: 'kasir',
          baseSalary: -1,
        ),
        throwsArgumentError,
      );
    });
  });

  group('absensi PIN', () {
    late String kasirId;
    late AuthService auth;

    setUp(() async {
      auth = AuthService();
      kasirId = await addEmployee(db);
      await auth.setPin(db, kasirId, '1234');
    });

    test('check-in 08:00 + check-out 17:00 -> 9 jam', () async {
      final inRow = await StaffService.clockIn(
        db,
        employeeId: kasirId,
        pin: '1234',
        now: DateTime(2026, 11, 15, 8, 0),
        auth: auth,
      );
      expect(inRow.pinVerified, 1);
      final outRow = await StaffService.clockOut(
        db,
        employeeId: kasirId,
        pin: '1234',
        now: DateTime(2026, 11, 15, 17, 0),
        auth: auth,
      );
      expect(StaffService.workMinutes(outRow), 540);
      final recap = await StaffService.recap(db, kasirId, '2026-11');
      expect(recap.daysPresent, 1);
      expect(recap.totalMinutes, 540);
      expect(recap.lateDays, 0);
      expect(recap.notCheckedOutDays, 0);
      expect(fmtWorkMinutes(540), '9 jam');
    });

    test('check-in 08:15 -> telat 1 hari (jam masuk default 08:00)',
        () async {
      await StaffService.clockIn(
        db,
        employeeId: kasirId,
        pin: '1234',
        now: DateTime(2026, 11, 15, 8, 15),
        auth: auth,
      );
      await StaffService.clockOut(
        db,
        employeeId: kasirId,
        pin: '1234',
        now: DateTime(2026, 11, 15, 17, 0),
        auth: auth,
      );
      final recap = await StaffService.recap(db, kasirId, '2026-11');
      expect(recap.lateDays, 1);
    });

    test('jam masuk diubah 09:00 -> check-in 08:30 tidak telat', () async {
      await setWorkStart(db, '09:00');
      final start = await getWorkStart(db);
      expect(start, (9, 0));
      await StaffService.clockIn(
        db,
        employeeId: kasirId,
        pin: '1234',
        now: DateTime(2026, 11, 15, 8, 30),
        auth: auth,
      );
      final recap = await StaffService.recap(db, kasirId, '2026-11');
      expect(recap.lateDays, 0);
      await expectLater(() => setWorkStart(db, '25:00'), throwsArgumentError);
    });

    test('lupa check-out -> jam 0 + flag belum check-out', () async {
      await StaffService.clockIn(
        db,
        employeeId: kasirId,
        pin: '1234',
        now: DateTime(2026, 11, 15, 8, 0),
        auth: auth,
      );
      final row = await StaffService.attendanceForDay(
        db,
        kasirId,
        DateTime(2026, 11, 15),
      );
      expect(row, isNotNull);
      expect(StaffService.workMinutes(row!), 0);
      expect(StaffService.isNotCheckedOut(row), isTrue);
      final recap = await StaffService.recap(db, kasirId, '2026-11');
      expect(recap.daysPresent, 1);
      expect(recap.totalMinutes, 0);
      expect(recap.notCheckedOutDays, 1);
    });

    test('aturan: 2x check-in / check-out tanpa check-in / 2x check-out',
        () async {
      await expectLater(
        () => StaffService.clockOut(
          db,
          employeeId: kasirId,
          pin: '1234',
          now: DateTime(2026, 11, 15, 17, 0),
          auth: auth,
        ),
        throwsStateError,
      );
      await StaffService.clockIn(
        db,
        employeeId: kasirId,
        pin: '1234',
        now: DateTime(2026, 11, 15, 8, 0),
        auth: auth,
      );
      await expectLater(
        () => StaffService.clockIn(
          db,
          employeeId: kasirId,
          pin: '1234',
          now: DateTime(2026, 11, 15, 8, 5),
          auth: auth,
        ),
        throwsStateError,
      );
      await StaffService.clockOut(
        db,
        employeeId: kasirId,
        pin: '1234',
        now: DateTime(2026, 11, 15, 17, 0),
        auth: auth,
      );
      await expectLater(
        () => StaffService.clockOut(
          db,
          employeeId: kasirId,
          pin: '1234',
          now: DateTime(2026, 11, 15, 17, 5),
          auth: auth,
        ),
        throwsStateError,
      );
    });

    test('PIN salah saat absen -> ditolak; karyawan nonaktif tidak bisa absen',
        () async {
      await expectLater(
        () => StaffService.clockIn(
          db,
          employeeId: kasirId,
          pin: '0000',
          now: DateTime(2026, 11, 15, 8, 0),
          auth: auth,
        ),
        throwsStateError,
      );
      await StaffService.setEmployeeActive(db, kasirId, false);
      await expectLater(
        () => StaffService.clockIn(
          db,
          employeeId: kasirId,
          pin: '1234',
          now: DateTime(2026, 11, 15, 8, 0),
          auth: auth,
        ),
        throwsStateError,
      );
    });
  });

  group('payroll', () {
    late AuthService auth;

    setUp(() {
      auth = AuthService();
    });

    Future<String> attendDays(
      String employeeId,
      List<int> days, {
      int inHour = 8,
      int outHour = 17,
    }) async {
      for (final d in days) {
        await StaffService.clockIn(
          db,
          employeeId: employeeId,
          pin: '1234',
          now: DateTime(2026, 11, d, inHour),
          auth: auth,
        );
        await StaffService.clockOut(
          db,
          employeeId: employeeId,
          pin: '1234',
          now: DateTime(2026, 11, d, outHour),
          auth: auth,
        );
      }
      return employeeId;
    }

    test('bulanan = gaji pokok (tidak tergantung hari hadir)', () async {
      final id = await addEmployee(db, baseSalary: 1500000);
      await auth.setPin(db, id, '1234');
      await attendDays(id, [10, 11]); // hanya 2 hari hadir
      final payrollId = await StaffService.processPayroll(
        db,
        employeeId: id,
        period: '2026-11',
      );
      final payroll = await (db.select(db.payrolls)
            ..where((p) => p.id.equals(payrollId)))
          .getSingle();
      expect(payroll.baseSalary, 1500000);
      expect(payroll.deductions, 0);
      expect(payroll.netPay, 1500000);
      expect(payroll.paidAt, isNotNull);
      // Jurnal D 5130 / K 1000 Rp1.500.000.
      final journal = await (db.select(db.journals)
            ..where((j) => j.refType.equals('payroll')))
          .getSingle();
      final lines = await (db.select(db.journalLines)
            ..where((l) => l.journalId.equals(journal.id)))
          .get();
      expect(lines.length, 2);
      final d5130 = lines.firstWhere((l) => l.accountCode == '5130');
      final k1000 = lines.firstWhere((l) => l.accountCode == '1000');
      expect(d5130.debit, 1500000);
      expect(k1000.credit, 1500000);
    });

    test('harian = tarif x hari hadir', () async {
      final id = await addEmployee(
        db,
        salaryType: 'harian',
        baseSalary: 100000,
      );
      await auth.setPin(db, id, '1234');
      await attendDays(id, [10, 11, 12]);
      final payrollId = await StaffService.processPayroll(
        db,
        employeeId: id,
        period: '2026-11',
      );
      final payroll = await (db.select(db.payrolls)
            ..where((p) => p.id.equals(payrollId)))
          .getSingle();
      expect(payroll.baseSalary, 300000);
      expect(payroll.netPay, 300000);
    });

    test('tambahan + potongan beralasan -> bersih benar + tersimpan',
        () async {
      final id = await addEmployee(db, baseSalary: 1500000);
      await auth.setPin(db, id, '1234');
      await attendDays(id, [10]);
      final payrollId = await StaffService.processPayroll(
        db,
        employeeId: id,
        period: '2026-11',
        additions: 50000,
        additionsNote: 'bonus lembur',
        deductions: 25000,
        deductionsNote: 'keterlambatan',
      );
      final payroll = await (db.select(db.payrolls)
            ..where((p) => p.id.equals(payrollId)))
          .getSingle();
      expect(payroll.baseSalary, 1550000); // pokok + tambahan
      expect(payroll.additions, 50000);
      expect(payroll.deductions, 25000);
      expect(payroll.netPay, 1525000);
      expect(payroll.note, contains('bonus lembur'));
      expect(payroll.note, contains('keterlambatan'));
    });

    test('proses 2x periode sama -> ditolak, jurnal tetap 1', () async {
      final id = await addEmployee(db, baseSalary: 1500000);
      await auth.setPin(db, id, '1234');
      await StaffService.processPayroll(db, employeeId: id, period: '2026-11');
      expect(await payrollJournalCount(db), 1);
      await expectLater(
        () => StaffService.processPayroll(
          db,
          employeeId: id,
          period: '2026-11',
        ),
        throwsStateError,
      );
      expect(await payrollJournalCount(db), 1);
      final rows = await StaffService.payrollsForPeriod(db, '2026-11');
      expect(rows.length, 1);
      // paySalary langsung 2x juga ditolak UNIQUE (employee+period).
      await expectLater(
        () => AccountingService.paySalary(
          db,
          employeeId: id,
          period: '2026-11',
          baseSalary: 1500000,
        ),
        throwsA(anything),
      );
    });

    test('payroll karyawan nonaktif -> ditolak', () async {
      final id = await addEmployee(db, baseSalary: 1500000);
      await StaffService.setEmployeeActive(db, id, false);
      await expectLater(
        () => StaffService.processPayroll(
          db,
          employeeId: id,
          period: '2026-11',
        ),
        throwsStateError,
      );
      expect(await payrollJournalCount(db), 0);
    });

    test('potongan melebihi gaji -> ditolak, tanpa jurnal', () async {
      final id = await addEmployee(db, baseSalary: 100000);
      await expectLater(
        () => StaffService.processPayroll(
          db,
          employeeId: id,
          period: '2026-11',
          deductions: 200000,
        ),
        throwsArgumentError,
      );
      expect(await payrollJournalCount(db), 0);
    });

    test('bayar dari bank -> kredit 1010', () async {
      final id = await addEmployee(db, baseSalary: 1500000);
      await StaffService.processPayroll(
        db,
        employeeId: id,
        period: '2026-11',
        payFrom: 'bank',
      );
      final journal = await (db.select(db.journals)
            ..where((j) => j.refType.equals('payroll')))
          .getSingle();
      final lines = await (db.select(db.journalLines)
            ..where((l) => l.journalId.equals(journal.id)))
          .get();
      expect(lines.any((l) => l.accountCode == '1010' && l.credit == 1500000),
          isTrue);
    });

    test('slip gaji memuat nama, periode, dan gaji bersih', () async {
      final id = await addEmployee(db, name: 'Kasir 1', baseSalary: 1500000);
      await auth.setPin(db, id, '1234');
      await attendDays(id, [10, 11]);
      final payrollId = await StaffService.processPayroll(
        db,
        employeeId: id,
        period: '2026-11',
      );
      final payroll = await (db.select(db.payrolls)
            ..where((p) => p.id.equals(payrollId)))
          .getSingle();
      final employee = await (db.select(db.employees)
            ..where((e) => e.id.equals(id)))
          .getSingle();
      final recap = await StaffService.recap(db, id, '2026-11');
      final slip = StaffService.slipText(
        storeName: 'Casirz',
        employee: employee,
        payroll: payroll,
        daysPresent: recap.daysPresent,
        totalMinutes: recap.totalMinutes,
        lateDays: recap.lateDays,
      );
      expect(slip.contains('Kasir 1'), isTrue);
      expect(slip.contains('November 2026'), isTrue);
      expect(slip.contains(fmt(1500000)), isTrue);
      expect(slip.contains('2 hari'), isTrue);
    });

    test('riwayat absensi + payroll tetap ada setelah nonaktif', () async {
      final id = await addEmployee(db, baseSalary: 1500000);
      await auth.setPin(db, id, '1234');
      await attendDays(id, [10]);
      await StaffService.processPayroll(db, employeeId: id, period: '2026-11');
      await StaffService.setEmployeeActive(db, id, false);
      final recap = await StaffService.recap(db, id, '2026-11');
      expect(recap.daysPresent, 1);
      final payroll = await StaffService.payrollFor(db, id, '2026-11');
      expect(payroll, isNotNull);
      expect(payroll!.netPay, 1500000);
    });
  });

  group('skema v2 (migrasi)', () {
    test('kolom gaji karyawan + tambahan/alasan payroll ada di DB baru',
        () async {
      final id = await StaffService.createEmployee(
        db,
        name: 'Harian',
        role: 'kasir',
        salaryType: 'harian',
        baseSalary: 75000,
      );
      final e = await (db.select(db.employees)..where((x) => x.id.equals(id)))
          .getSingle();
      expect(e.salaryType, 'harian');
      expect(e.baseSalary, 75000);
      // Default kolom baru untuk karyawan lama (tanpa nilai eksplisit).
      final id2 = newId();
      await db.into(db.employees).insert(
            EmployeesCompanion.insert(
              id: id2,
              name: 'Lama',
              role: 'kasir',
              pinHash: '',
              updatedAt: nowMs(),
              deviceId: 'test',
            ),
          );
      final e2 = await (db.select(db.employees)
            ..where((x) => x.id.equals(id2)))
          .getSingle();
      expect(e2.salaryType, 'bulanan');
      expect(e2.baseSalary, 0);
      // Baris payroll dengan additions + note.
      final deviceId = await db.deviceId();
      final pid = newId();
      await db.into(db.payrolls).insert(
            PayrollsCompanion.insert(
              id: pid,
              employeeId: id,
              period: '2026-11',
              baseSalary: 75000,
              deductions: 0,
              netPay: 75000,
              additions: const Value(5000),
              note: const Value('bonus'),
              updatedAt: nowMs(),
              deviceId: deviceId,
            ),
          );
      final p = await (db.select(db.payrolls)..where((x) => x.id.equals(pid)))
          .getSingle();
      expect(p.additions, 5000);
      expect(p.note, 'bonus');
    });
  });

  group('widget: lock screen + setup owner + RBAC shell', () {
    // Layar HP itu tinggi: viewport test default 800x600 membuat keypad
    // PIN jatuh di bawah lipatan (tap meleset). Pakai 800x1400.
    void setTallScreen(WidgetTester tester) {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    Future<void> tapPin(WidgetTester tester, String pin) async {
      for (final ch in pin.split('')) {
        await tester.tap(find.text(ch).first);
        await tester.pump();
      }
    }

    testWidgets('DB kosong -> shell langsung (tanpa kunci)', (tester) async {
      setTallScreen(tester);
      await tester.pumpWidget(CasirzApp(db: db));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Kasir'), findsWidgets);
      await closeDbInBody();
    });

    testWidgets('owner tanpa PIN -> setup PIN, lalu masuk sebagai owner',
        (tester) async {
      setTallScreen(tester);
      await addEmployee(db, name: 'Owner', role: 'owner', baseSalary: 0);
      await tester.pumpWidget(CasirzApp(db: db));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Buat PIN Owner'), findsOneWidget);
      // Pilih owner, lanjut, isi PIN 2x.
      await tester.tap(find.text('Owner').first);
      await tester.pump();
      await tester.tap(find.text('Lanjut Buat PIN'));
      await tester.pump();
      await tapPin(tester, '1234');
      await tester.tap(find.text('Lanjut'));
      await tester.pump();
      await tapPin(tester, '1234');
      await tester.tap(find.text('Simpan PIN'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Kasir'), findsWidgets);
      // PIN tersimpan sebagai hash, bukan mentah.
      final e = await (db.select(db.employees)).getSingle();
      expect(e.pinHash.isNotEmpty, isTrue);
      expect(e.pinHash.contains('1234'), isFalse);
      await closeDbInBody();
    });

    testWidgets('PIN salah ditolak, PIN benar masuk', (tester) async {
      setTallScreen(tester);
      final auth = AuthService();
      final id = await addEmployee(db, name: 'Owner', role: 'owner');
      await auth.setPin(db, id, '1234');
      await tester.pumpWidget(CasirzApp(db: db));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Masuk dengan PIN'), findsOneWidget);
      await tester.tap(find.text('Owner').first);
      await tester.pump();
      await tapPin(tester, '0000');
      await tester.tap(find.text('Masuk'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.textContaining('PIN salah'), findsOneWidget);
      await tapPin(tester, '1234');
      await tester.tap(find.text('Masuk'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Kasir'), findsWidgets);
      await closeDbInBody();
    });

    testWidgets('kasir: menu Staf hilang; Akuntansi terkunci di Lainnya',
        (tester) async {
      setTallScreen(tester);
      final auth = AuthService();
      final ownerId =
          await addEmployee(db, name: 'Owner', role: 'owner', baseSalary: 0);
      await auth.setPin(db, ownerId, '1234');
      final kasirId = await addEmployee(db, name: 'Kasir 1', role: 'kasir');
      await auth.setPin(db, kasirId, '5678');
      await tester.pumpWidget(CasirzApp(db: db));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.text('Kasir 1').first);
      await tester.pump();
      await tapPin(tester, '5678');
      await tester.tap(find.text('Masuk'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      // Bottom nav kasir: tanpa Staf.
      expect(find.text('Staf'), findsNothing);
      expect(find.text('Kasir'), findsWidgets);
      await tester.tap(find.text('Lainnya').first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Akuntansi'), findsOneWidget);
      await tester.tap(find.text('Akuntansi'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Menu Akuntansi Terkunci'), findsOneWidget);
      expect(find.textContaining('hanya untuk Owner'), findsOneWidget);
      await closeDbInBody();
    });
  });
}
