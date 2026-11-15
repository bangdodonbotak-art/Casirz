// Regression test: MainActivity yang dideklarasikan di AndroidManifest
// harus benar-benar ada sebagai class Kotlin/Java dengan package yang
// sama. Bug nyata 15 Nov 2026: namespace/applicationId = com.casirz.app,
// tapi MainActivity.kt ber-package com.casirz.casirz — CI hijau,
// aplikasi crash instan di HP (ClassNotFoundException).
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Android - MainActivity ter-resolve di manifest', () {
    test('package MainActivity == namespace + nama activity di manifest',
        () {
      final manifest =
          File('android/app/src/main/AndroidManifest.xml').readAsStringSync();
      final gradle =
          File('android/app/build.gradle.kts').readAsStringSync();

      final namespace = RegExp(r'namespace\s*=\s*"([^"]+)"')
          .firstMatch(gradle)!
          .group(1)!;
      final activityName = RegExp(
              r'<activity[^>]*android:name="([^"]+)"',
              dotAll: true)
          .firstMatch(manifest)!
          .group(1)!;

      final expected = activityName.startsWith('.')
          ? '$namespace$activityName'
          : activityName.contains('.')
              ? activityName
              : '$namespace.$activityName';

      final sources = <File>[];
      for (final root in [
        'android/app/src/main/kotlin',
        'android/app/src/main/java'
      ]) {
        final dir = Directory(root);
        if (dir.existsSync()) {
          sources.addAll(dir
              .listSync(recursive: true)
              .whereType<File>()
              .where((f) =>
                  f.path.endsWith('MainActivity.kt') ||
                  f.path.endsWith('MainActivity.java')));
        }
      }
      expect(sources, hasLength(1),
          reason: 'harus tepat satu file MainActivity, bukan 0 atau duplikat');
      final source = sources.single.readAsStringSync();
      final pkg = RegExp(r'^\s*package\s+([\w.]+)', multiLine: true)
          .firstMatch(source)!
          .group(1)!;
      final actual = '$pkg.MainActivity';
      expect(actual, expected,
          reason: 'MainActivity di $pkg tidak cocok dengan manifest ($expected)');
    });
  });
}
