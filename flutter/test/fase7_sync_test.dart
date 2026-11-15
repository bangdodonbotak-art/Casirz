// Casirz ERP — Fase 7 (Sinkronisasi + CI -> APK/AAB).
// Test sync engine (fake transport, tanpa Supabase sungguhan) +
// backup/restore + validasi workflow YAML + ikon aplikasi.
//
// Aturan yang dites (BLUEPRINT §5.3, §11):
// - Push FIFO + BERHENTI di gagal pertama.
// - Pull delta memakai watermark (hanya yang berubah).
// - APPEND = INSERT OR IGNORE by UUID (duplikat tidak ganda).
// - MASTER = last-write-wins (updatedAt; seri -> deviceId) + log konflik.
// - Hapus = tombstone (baris tetap ada, _deleted = 1).
// - Config kosong -> sync nonaktif + throw "Supabase belum dikonfigurasi".
import 'dart:io';

import 'package:casirz/core/backup.dart';
import 'package:casirz/core/db.dart';
import 'package:casirz/core/supabase_config.dart';
import 'package:casirz/core/sync.dart';
import 'package:casirz/core/sync_engine.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Fake transport — tidak menyentuh jaringan / Supabase.
// ---------------------------------------------------------------------------
class FakeSyncTransport implements SyncTransport {
  /// Baris remote per tabel (seolah-olah isi Supabase).
  final Map<String, List<Map<String, Object?>>> remote = {};

  /// Baris yang berhasil di-push, sesuai urutan push.
  final List<({String table, Map<String, Object?> row})> pushed = [];

  /// Nomor panggilan push yang dibuat gagal (1-based). -1 = tidak gagal.
  var failPushAt = -1;
  var pushCalls = 0;

  @override
  Future<void> pushRow(String table, Map<String, Object?> row) async {
    pushCalls++;
    if (pushCalls == failPushAt) {
      throw StateError('jaringan putus (simulasi)');
    }
    pushed.add((table: table, row: Map<String, Object?>.of(row)));
  }

  @override
  Future<List<Map<String, Object?>>> pullDelta(
    String table,
    int sinceMs,
  ) async {
    final rows = remote[table] ?? const [];
    return rows
        .where((r) => (r['updated_at'] as int) > sinceMs)
        .map((r) => Map<String, Object?>.from(r))
        .toList();
  }
}

// ---------------------------------------------------------------------------
// Pembantu.
// ---------------------------------------------------------------------------
Future<void> insertProduct(
  AppDatabase db, {
  required String id,
  String name = 'Kopi Susu',
  int updatedAt = 1000,
  String deviceId = 'aaa',
  int isDeleted = 0,
}) async {
  await db.into(db.products).insert(
        ProductsCompanion.insert(
          id: id,
          name: name,
          category: 'Minuman',
          price: 18000,
          cost: 9000,
          updatedAt: updatedAt,
          deviceId: deviceId,
          isDeleted: Value(isDeleted),
        ),
      );
}

Map<String, Object?> remoteProduct({
  required String id,
  String name = 'Kopi Susu',
  int updatedAt = 1000,
  String deviceId = 'aaa',
  int isDeleted = 0,
}) {
  return {
    'id': id,
    'name': name,
    'category': 'Minuman',
    'price': 18000,
    'cost': 9000,
    'stock': 10,
    'barcode': null,
    'isActive': 1,
    'updated_at': updatedAt,
    'device_id': deviceId,
    '_deleted': isDeleted,
  };
}

Future<void> insertOutbox(
  AppDatabase db, {
  required String table,
  required String rowId,
  String operation = 'insert',
  int createdAt = 1000,
  String payload = '{}',
}) async {
  await db.into(db.syncOutbox).insert(
        SyncOutboxCompanion.insert(
          id: newId(),
          table: table,
          rowId: rowId,
          operation: operation,
          payload: payload,
          status: 'pending',
          createdAt: createdAt,
        ),
      );
}

Future<void> resetWatermark(AppDatabase db, String table) async {
  await (db.delete(db.syncState)..where((s) => s.id.equals(table))).go();
}

Future<int> countRows(AppDatabase db, String table) async {
  final rows = await db.customSelect('SELECT COUNT(*) AS n FROM "$table"').get();
  return rows.first.data['n'] as int;
}

/// Lebar/tinggi PNG dari header IHDR (tanpa package image).
({int width, int height}) pngSize(File file) {
  final bytes = file.readAsBytesSync();
  int be(int offset) =>
      (bytes[offset] << 24) |
      (bytes[offset + 1] << 16) |
      (bytes[offset + 2] << 8) |
      bytes[offset + 3];
  return (width: be(16), height: be(20));
}

void main() {
  group('Fase 7 — push FIFO', () {
    test('push berurutan FIFO dan BERHENTI di gagal pertama', () async {
      final db = AppDatabase.memory();
      final transport = FakeSyncTransport()..failPushAt = 2;
      final engine = RealSyncEngine(db, transport: transport);
      for (var i = 1; i <= 3; i++) {
        await insertProduct(db, id: 'p$i');
        await insertOutbox(
          db,
          table: 'products',
          rowId: 'p$i',
          createdAt: i * 1000,
        );
      }

      final result = await engine.pushPending();

      expect(result.pushed, 1);
      expect(result.failed, 1);
      expect(transport.pushed.map((p) => p.row['id']), ['p1']);
      final outbox = await (db.select(db.syncOutbox)
            ..orderBy([(o) => OrderingTerm.asc(o.createdAt)]))
          .get();
      expect(outbox.map((o) => o.status), ['done', 'failed', 'pending']);
      // Gagal pertama tidak mengulang dari awal: p3 tetap pending.
      expect(await Outbox.pendingCount(db), 2);
      await db.close();
    });

    test('push mengirim BARIS LENGKAP, bukan payload outbox (sebagian)',
        () async {
      final db = AppDatabase.memory();
      final transport = FakeSyncTransport();
      final engine = RealSyncEngine(db, transport: transport);
      await db.into(db.sales).insert(
            SalesCompanion.insert(
              id: 's1',
              code: 'CSZ-20261115-0001',
              date: 1000,
              channel: 'dine-in',
              paymentMethod: 'tunai',
              subtotal: 36000,
              total: 36000,
              paid: 36000,
              updatedAt: 1000,
              deviceId: 'aaa',
            ),
          );
      // Payload outbox ASLI (Fase 2) hanya sebagian — engine harus
      // membaca baris lengkap dari SQLite, bukan payload ini.
      await insertOutbox(
        db,
        table: 'sales',
        rowId: 's1',
        payload: '{"id":"s1","total":36000}',
      );

      final result = await engine.pushPending();

      expect(result.pushed, 1);
      final pushed = transport.pushed.single.row;
      expect(pushed['subtotal'], 36000);
      expect(pushed['code'], 'CSZ-20261115-0001');
      expect(pushed['channel'], 'dine-in');
      expect(pushed['updated_at'], 1000);
      await db.close();
    });
  });

  group('Fase 7 — pull delta + watermark', () {
    test('pull hanya menarik delta (watermark maju)', () async {
      final db = AppDatabase.memory();
      final transport = FakeSyncTransport();
      final engine = RealSyncEngine(db, transport: transport);
      transport.remote['products'] = [
        remoteProduct(id: 'r1', updatedAt: 100),
        remoteProduct(id: 'r2', updatedAt: 200),
      ];

      final first = await engine.pullDelta();
      expect(first.pulled, 2);
      expect(await countRows(db, 'products'), 2);
      final mark = await (db.select(db.syncState)
            ..where((s) => s.id.equals('products')))
          .getSingle();
      expect(mark.lastPulledAt, 200);

      // Putaran kedua: tidak ada yang berubah -> 0 ditarik.
      final second = await engine.pullDelta();
      expect(second.pulled, 0);
      await db.close();
    });

    test('APPEND duplikat UUID tidak ganda (INSERT OR IGNORE)', () async {
      final db = AppDatabase.memory();
      final transport = FakeSyncTransport();
      final engine = RealSyncEngine(db, transport: transport);
      transport.remote['sales'] = [
        {
          'id': 's-dup',
          'code': 'CSZ-20261115-0001',
          'date': 500,
          'channel': 'dine-in',
          'payment_method': 'tunai',
          'subtotal': 36000,
          'discount': 0,
          'tax': 0,
          'service_charge': 0,
          'ojol_fee': 0,
          'total': 36000,
          'paid': 36000,
          'change': 0,
          'voided': 0,
          'voided_at': null,
          'shift_id': null,
          'employee_id': null,
          'customer_id': null,
          'order_id': null,
          'split_group_id': null,
          'updated_at': 500,
          'device_id': 'bbb',
        },
      ];

      await engine.pullDelta();
      expect(await countRows(db, 'sales'), 1);
      // Tarik ulang baris yang sama (watermark direset) -> tetap 1 baris.
      await resetWatermark(db, 'sales');
      final again = await engine.pullDelta();
      expect(again.pulled, 0);
      expect(await countRows(db, 'sales'), 1);
      await db.close();
    });

    test('MASTER last-write-wins: baru menang, lama kalah, seri deviceId',
        () async {
      final db = AppDatabase.memory();
      final transport = FakeSyncTransport();
      final engine = RealSyncEngine(db, transport: transport);
      await insertProduct(
        db,
        id: 'p-lww',
        name: 'Lama',
        updatedAt: 1000,
        deviceId: 'aaa',
      );

      // Remote lebih baru -> menang.
      transport.remote['products'] = [
        remoteProduct(id: 'p-lww', name: 'Baru', updatedAt: 2000),
      ];
      await engine.pullDelta();
      var local = await (db.select(db.products)
            ..where((p) => p.id.equals('p-lww')))
          .getSingle();
      expect(local.name, 'Baru');
      expect(local.updatedAt, 2000);

      // Remote lebih lama -> kalah, lokal dipertahankan + konflik dicatat.
      await resetWatermark(db, 'products');
      transport.remote['products'] = [
        remoteProduct(id: 'p-lww', name: 'Tua', updatedAt: 500),
      ];
      await engine.pullDelta();
      local = await (db.select(db.products)
            ..where((p) => p.id.equals('p-lww')))
          .getSingle();
      expect(local.name, 'Baru');
      expect(await countRows(db, 'sync_conflicts'), 1);

      // Seri updatedAt, deviceId remote lebih besar -> remote menang.
      await resetWatermark(db, 'products');
      transport.remote['products'] = [
        remoteProduct(
          id: 'p-lww',
          name: 'SeriMenang',
          updatedAt: 2000,
          deviceId: 'zzz',
        ),
      ];
      await engine.pullDelta();
      local = await (db.select(db.products)
            ..where((p) => p.id.equals('p-lww')))
          .getSingle();
      expect(local.name, 'SeriMenang');
      expect(local.deviceId, 'zzz');

      // Seri updatedAt, deviceId remote lebih kecil -> remote kalah.
      await resetWatermark(db, 'products');
      transport.remote['products'] = [
        remoteProduct(
          id: 'p-lww',
          name: 'SeriKalah',
          updatedAt: 2000,
          deviceId: '000',
        ),
      ];
      await engine.pullDelta();
      local = await (db.select(db.products)
            ..where((p) => p.id.equals('p-lww')))
          .getSingle();
      expect(local.name, 'SeriMenang');
      expect(engine.conflicts.length, 2);
      expect(await countRows(db, 'sync_conflicts'), 2);
      await db.close();
    });

    test('tombstone: hapus remote menandai _deleted, baris tetap ada',
        () async {
      final db = AppDatabase.memory();
      final transport = FakeSyncTransport();
      final engine = RealSyncEngine(db, transport: transport);
      await insertProduct(db, id: 'p-del', updatedAt: 1000);
      transport.remote['products'] = [
        remoteProduct(id: 'p-del', updatedAt: 3000, isDeleted: 1),
      ];

      await engine.pullDelta();

      final local = await (db.select(db.products)
            ..where((p) => p.id.equals('p-del')))
          .getSingle();
      expect(local.isDeleted, 1);
      expect(await countRows(db, 'products'), 1);
      await db.close();
    });

    test('syncNow: push dulu lalu pull; jam sync terakhir tercatat',
        () async {
      final db = AppDatabase.memory();
      final transport = FakeSyncTransport();
      final engine = RealSyncEngine(db, transport: transport);
      await insertProduct(db, id: 'p1');
      await insertOutbox(db, table: 'products', rowId: 'p1');
      transport.remote['products'] = [
        remoteProduct(id: 'r1', updatedAt: 100),
      ];

      final result = await engine.syncNow();

      expect(result.pushed, 1);
      expect(result.pulled, 1);
      expect(result.failed, 0);
      final status = await engine.currentStatus();
      expect(status.lastSyncAt, isNotNull);
      expect(status.pendingCount, 0);
      await db.close();
    });

    test('syncNow: bila push gagal, pull DILEWATI', () async {
      final db = AppDatabase.memory();
      final transport = FakeSyncTransport()..failPushAt = 1;
      final engine = RealSyncEngine(db, transport: transport);
      await insertProduct(db, id: 'p1');
      await insertOutbox(db, table: 'products', rowId: 'p1');
      transport.remote['products'] = [
        remoteProduct(id: 'r1', updatedAt: 100),
      ];

      final result = await engine.syncNow();

      expect(result.pushed, 0);
      expect(result.failed, 1);
      expect(result.pulled, 0);
      expect(await countRows(db, 'products'), 1); // r1 tidak ditarik
      await db.close();
    });
  });

  group('Fase 7 — config kosong = sync nonaktif', () {
    test('config kosong -> nonaktif; transport throw pesan jelas', () {
      const empty = SupabaseConfig(url: '', anonKey: '');
      expect(empty.isConfigured, isFalse);
      expect(
        () => SupabaseTransport(empty),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('Supabase belum dikonfigurasi'),
          ),
        ),
      );
    });

    test('tanpa --dart-define, config lingkungan kosong', () {
      expect(SupabaseConfig.fromEnvironment().isConfigured, isFalse);
    });

    test('engine tanpa transport: syncNow/push/pull = nol, tanpa koneksi',
        () async {
      final db = AppDatabase.memory();
      final engine = RealSyncEngine(db);
      expect(engine.isEnabled, isFalse);
      await insertProduct(db, id: 'p1');
      await insertOutbox(db, table: 'products', rowId: 'p1');

      expect(await engine.syncNow(), const SyncResultMatcher(0, 0, 0));
      expect(await engine.pushPending(), const SyncResultMatcher(0, 0, 0));
      expect(await engine.pullDelta(), const SyncResultMatcher(0, 0, 0));
      // Outbox tetap pending — tidak ada yang mencoba mengirim.
      expect(await Outbox.pendingCount(db), 1);
      await db.close();
    });
  });

  group('Fase 7 — backup / restore', () {
    test('export lalu import: data kembali utuh', () async {
      final db = AppDatabase.memory();
      await insertProduct(db, id: 'p1', name: 'Kopi Susu');
      await db.into(db.customers).insert(
            CustomersCompanion.insert(
              id: 'c1',
              name: 'Budi',
              updatedAt: 1000,
              deviceId: 'aaa',
            ),
          );
      final backup = BackupService(db);
      final jsonStr = await backup.exportJsonString();

      final db2 = AppDatabase.memory();
      final deviceId2 = await db2.deviceId();
      final summary =
          await BackupService(db2).importJsonString(jsonStr);
      expect(summary.rows, greaterThan(0));
      expect(await countRows(db2, 'products'), 1);
      expect(await countRows(db2, 'customers'), 1);
      // deviceId HP tujuan dipertahankan, bukan ditimpa backup.
      expect(await db2.deviceId(), deviceId2);
      await db.close();
      await db2.close();
    });

    test('import format salah -> ditolak, database tidak berubah', () async {
      final db = AppDatabase.memory();
      await insertProduct(db, id: 'p1');
      await expectLater(
        BackupService(db).importJsonString(
          '{"format":"bukan-backup","tables":{}}',
        ),
        throwsA(isA<BackupInvalid>()),
      );
      await expectLater(
        BackupService(db).importJsonString('bukan json'),
        throwsA(isA<FormatException>()),
      );
      expect(await countRows(db, 'products'), 1);
      await db.close();
    });

    test('pengingat backup: belum pernah -> true; setelah backup -> false',
        () async {
      final db = AppDatabase.memory();
      final backup = BackupService(db);
      expect(await backup.needsBackupReminder(), isTrue);
      expect(await backup.lastBackupAt(), isNull);
      await backup.markBackedUp();
      expect(await backup.needsBackupReminder(), isFalse);
      expect(await backup.lastBackupAt(), isNotNull);
      // Backup 8 hari lalu -> pengingat muncul lagi.
      final old = DateTime.now()
          .subtract(const Duration(days: 8))
          .millisecondsSinceEpoch;
      await db.setSetting('lastBackupAt', old.toString());
      expect(await backup.needsBackupReminder(), isTrue);
      await db.close();
    });
  });

  group('Fase 7 — workflow CI', () {
    test('build-apk.yml: ada job debug-apk + release-aab + signing kondisional',
        () {
      final file = File('.github/workflows/build-apk.yml');
      expect(file.existsSync(), isTrue, reason: 'workflow CI tidak ada');
      final text = file.readAsStringSync();
      expect(text, contains('build-debug-apk'));
      expect(text, contains('build-release-aab'));
      expect(text, contains('flutter build apk --debug'));
      expect(text, contains('flutter build appbundle --release'));
      expect(text, contains('flutter analyze'));
      expect(text, contains('flutter test'));
      expect(text, contains("flutter-version: '3.35.7'"));
      expect(text, contains('subosito/flutter-action'));
      expect(text, contains('KEYSTORE_BASE64'));
      expect(text, contains('KEYSTORE_PASSWORD'));
      expect(text, contains('KEY_ALIAS'));
      expect(text, contains('KEY_PASSWORD'));
      expect(text, contains("secrets.KEYSTORE_BASE64 != ''"));
      // Tidak ada password keystore yang di-hardcode.
      expect(text.contains('storePassword=') && !text.contains('\$KEYSTORE_PASSWORD'), isFalse);
    });
  });

  group('Fase 7 — ikon aplikasi', () {
    test('ikon Android ada di semua densitas + ukuran benar', () {
      const sizes = {
        'mdpi': 48,
        'hdpi': 72,
        'xhdpi': 96,
        'xxhdpi': 144,
        'xxxhdpi': 192,
      };
      for (final e in sizes.entries) {
        final file = File(
          'android/app/src/main/res/mipmap-${e.key}/ic_launcher.png',
        );
        expect(file.existsSync(), isTrue, reason: '${e.key} hilang');
        final size = pngSize(file);
        expect(size.width, e.value, reason: 'lebar ${e.key}');
        expect(size.height, e.value, reason: 'tinggi ${e.key}');
      }
    });

    test('adaptive icon: foreground + background + xml ada', () {
      const sizes = {
        'mdpi': 108,
        'hdpi': 162,
        'xhdpi': 216,
        'xxhdpi': 324,
        'xxxhdpi': 432,
      };
      for (final e in sizes.entries) {
        for (final kind in ['foreground', 'background']) {
          final file = File(
            'android/app/src/main/res/mipmap-${e.key}/ic_launcher_$kind.png',
          );
          expect(file.existsSync(), isTrue, reason: '$kind ${e.key} hilang');
          expect(pngSize(file).width, e.value);
        }
      }
      expect(
        File('android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml')
            .existsSync(),
        isTrue,
      );
    });

    test('ikon iOS AppIcon: 1024 + ukuran kecil ada', () {
      const base = 'ios/Runner/Assets.xcassets/AppIcon.appiconset';
      final checks = {
        'Icon-App-1024x1024@1x.png': 1024,
        'Icon-App-20x20@1x.png': 20,
        'Icon-App-60x60@3x.png': 180,
        'Icon-App-83.5x83.5@2x.png': 167,
      };
      for (final e in checks.entries) {
        final file = File('$base/${e.key}');
        expect(file.existsSync(), isTrue, reason: '${e.key} hilang');
        expect(pngSize(file).width, e.value, reason: e.key);
      }
    });

    test('nama aplikasi = Casirz (manifest + Info.plist)', () {
      final manifest = File(
        'android/app/src/main/AndroidManifest.xml',
      ).readAsStringSync();
      expect(manifest, contains('android:label="Casirz"'));
      final plist =
          File('ios/Runner/Info.plist').readAsStringSync();
      expect(plist, contains('<string>Casirz</string>'));
    });
  });
}

/// Matcher SyncResult (pushed/pulled/failed) — SyncResult tidak punya ==.
class SyncResultMatcher extends Matcher {
  const SyncResultMatcher(this.pushed, this.pulled, this.failed);
  final int pushed;
  final int pulled;
  final int failed;

  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) {
    return item is SyncResult &&
        item.pushed == pushed &&
        item.pulled == pulled &&
        item.failed == failed;
  }

  @override
  Description describe(Description description) => description
      .add('SyncResult(pushed: $pushed, pulled: $pulled, failed: $failed)');
}
