// Casirz ERP — Fase 2, diperbarui Fase 3.
// Service pelanggan: tambah pelanggan.
//
// POIN (Adendum blueprint no. 3 + Adendum pasca-Fase 2 butir 2):
// 1 poin per Rp10.000 belanja (floor(total/10000)) per penjualan,
// diakrual ATOMIK di dalam transaksi SaleService.recordSale
// (param opsional `accruePoints`, default true). Penukaran poin
// TIDAK ada di v1.
//
// PERUBAHAN FASE 3: metode `accruePoints` (transaksi terpisah setelah
// recordSale) DIHAPUS — dua jalur akrual = risiko poin ganda / poin
// hilang saat crash di antara dua transaksi (temuan ensemble Fase 3).
// Satu-satunya jalur akrual sekarang adalah di dalam recordSale.
// Pemanggil lama: checkout.dart (sekarang membaca poin kembali dari
// DB setelah recordSale) + test poin di pos_logic_test.dart.
import 'package:drift/drift.dart';

import '../../core/db.dart';
import '../../core/sync.dart';

class CustomerService {
  /// Tambah pelanggan baru. Mengembalikan id pelanggan.
  static Future<String> addCustomer(
    AppDatabase db, {
    required String name,
    String? phone,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Nama pelanggan tidak boleh kosong.');
    }
    final deviceId = await db.deviceId();
    final id = newId();
    await db.transaction(() async {
      final now = nowMs();
      await db.into(db.customers).insert(
            CustomersCompanion.insert(
              id: id,
              name: trimmed,
              phone: Value(phone?.trim().isEmpty == true ? null : phone?.trim()),
              updatedAt: now,
              deviceId: deviceId,
            ),
          );
      await Outbox.write(
        db,
        table: 'customers',
        rowId: id,
        operation: 'insert',
        payload: {'id': id, 'name': trimmed, 'points': 0},
      );
    });
    return id;
  }
}
