// Casirz ERP — Fase 2 (Modul A Kasir+).
// Service meja & open bill (orders + orderLines + shopTables).
// Memakai API engine (Ledger/Bom TIDAK disentuh — order belum bayar
// jadi belum ada jurnal/stok; jurnal + potong stok terjadi saat
// checkout lewat SaleService.recordSale).
//
// Aturan:
// - Order 'open' = belum bayar. BEDA dari sales (sudah bayar).
// - Split bill per item = pindahkan orderLines ke order baru.
// - Merge bill = pindahkan semua lines order B ke order A, lalu
//   order B di-void (bukan dihapus fisik — status 'void').
// - Status meja ikut order: ada order open -> 'terisi'; tidak ada ->
//   'kosong'. 'reserved' hanya diubah manual.
// - Setiap tulis ikut menulis syncOutbox (kelas MASTER, last-write-wins).
import 'package:drift/drift.dart';

import '../../core/db.dart';
import '../../core/sync.dart';

class OrderService {
  /// Buat order baru (open bill). Mengembalikan id order.
  static Future<String> createOrder(
    AppDatabase db, {
    String? tableId,
    required String channel,
  }) async {
    if (!saleChannelValues.contains(channel)) {
      throw ArgumentError('Channel tidak dikenal: $channel');
    }
    final deviceId = await db.deviceId();
    final orderId = newId();
    await db.transaction(() async {
      final now = nowMs();
      await db.into(db.orders).insert(
            OrdersCompanion.insert(
              id: orderId,
              tableId: Value(tableId),
              status: 'open',
              channel: channel,
              updatedAt: now,
              deviceId: deviceId,
            ),
          );
      await Outbox.write(
        db,
        table: 'orders',
        rowId: orderId,
        operation: 'insert',
        payload: {'id': orderId, 'status': 'open', 'channel': channel},
      );
      if (tableId != null) {
        await _setTableStatus(db, tableId, 'terisi');
      }
    });
    return orderId;
  }

  /// Tambah baris ke order. Harga snapshot = harga produk saat dipesan
  /// (atau [priceOverride] bila ada markup ojol).
  static Future<String> addLine(
    AppDatabase db, {
    required String orderId,
    required String productId,
    required int qty,
    int? priceOverride,
  }) async {
    if (qty <= 0) throw ArgumentError('qty harus > 0.');
    final deviceId = await db.deviceId();
    final lineId = newId();
    await db.transaction(() async {
      final now = nowMs();
      final order = await (db.select(db.orders)
            ..where((o) => o.id.equals(orderId)))
          .getSingleOrNull();
      if (order == null) throw ArgumentError('Order tidak ditemukan.');
      if (order.status != 'open') {
        throw ArgumentError('Order sudah ${order.status}, tidak bisa diubah.');
      }
      final product = await (db.select(db.products)
            ..where((p) => p.id.equals(productId)))
          .getSingleOrNull();
      if (product == null) {
        throw ArgumentError('Produk tidak ditemukan: $productId');
      }
      // Bila produk sudah ada di order, tambah qty-nya (satu baris
      // per produk per order).
      final existing = await (db.select(db.orderLines)
            ..where(
              (l) =>
                  l.orderId.equals(orderId) &
                  l.productId.equals(productId),
            ))
          .getSingleOrNull();
      if (existing != null) {
        await (db.update(db.orderLines)
              ..where((l) => l.id.equals(existing.id)))
            .write(
              OrderLinesCompanion(
                qty: Value(existing.qty + qty),
                updatedAt: Value(now),
              ),
            );
        await Outbox.write(
          db,
          table: 'order_lines',
          rowId: existing.id,
          operation: 'update',
          payload: {'id': existing.id, 'qty': existing.qty + qty},
        );
        return existing.id;
      }
      await db.into(db.orderLines).insert(
            OrderLinesCompanion.insert(
              id: lineId,
              orderId: orderId,
              productId: productId,
              qty: qty,
              price: priceOverride ?? product.price,
              updatedAt: now,
              deviceId: deviceId,
            ),
          );
      await Outbox.write(
        db,
        table: 'order_lines',
        rowId: lineId,
        operation: 'insert',
        payload: {
          'id': lineId,
          'orderId': orderId,
          'productId': productId,
          'qty': qty,
        },
      );
    });
    return lineId;
  }

  /// Ubah qty baris order. qty 0 = hapus baris.
  static Future<void> setLineQty(
    AppDatabase db,
    String lineId,
    int qty,
  ) async {
    if (qty < 0) throw ArgumentError('qty tidak boleh negatif.');
    await db.transaction(() async {
      final now = nowMs();
      if (qty == 0) {
        await (db.update(db.orderLines)
              ..where((l) => l.id.equals(lineId)))
            .write(
              OrderLinesCompanion(
                isDeleted: const Value(1),
                updatedAt: Value(now),
              ),
            );
        await Outbox.write(
          db,
          table: 'order_lines',
          rowId: lineId,
          operation: 'update',
          payload: {'id': lineId, '_deleted': 1},
        );
        return;
      }
      await (db.update(db.orderLines)
            ..where((l) => l.id.equals(lineId)))
          .write(
            OrderLinesCompanion(qty: Value(qty), updatedAt: Value(now)),
          );
      await Outbox.write(
        db,
        table: 'order_lines',
        rowId: lineId,
        operation: 'update',
        payload: {'id': lineId, 'qty': qty},
      );
    });
  }

  /// Split bill per item: pindahkan [lineIds] ke order baru (channel
  /// sama, meja sama). Mengembalikan id order baru.
  static Future<String> splitOrderByItems(
    AppDatabase db, {
    required String orderId,
    required List<String> lineIds,
  }) async {
    if (lineIds.isEmpty) {
      throw ArgumentError('Pilih minimal satu item untuk dipisah.');
    }
    final deviceId = await db.deviceId();
    final newOrderId = newId();
    await db.transaction(() async {
      final now = nowMs();
      final order = await (db.select(db.orders)
            ..where((o) => o.id.equals(orderId)))
          .getSingleOrNull();
      if (order == null) throw ArgumentError('Order tidak ditemukan.');
      if (order.status != 'open') {
        throw ArgumentError('Order sudah ${order.status}.');
      }
      final lines = await (db.select(db.orderLines)
            ..where(
              (l) =>
                  l.orderId.equals(orderId) & l.id.isIn(lineIds),
            ))
          .get();
      if (lines.length != lineIds.length) {
        throw ArgumentError('Ada item yang tidak ada di order ini.');
      }
      if (lines.length ==
          (await (db.select(db.orderLines)
                    ..where(
                      (l) =>
                          l.orderId.equals(orderId) &
                          l.isDeleted.equals(0),
                    ))
                  .get())
              .length) {
        throw ArgumentError(
          'Tidak bisa memisahkan SEMUA item — order asal akan kosong. '
          'Pindahkan sebagian saja.',
        );
      }
      await db.into(db.orders).insert(
            OrdersCompanion.insert(
              id: newOrderId,
              tableId: Value(order.tableId),
              status: 'open',
              channel: order.channel,
              updatedAt: now,
              deviceId: deviceId,
            ),
          );
      for (final line in lines) {
        await (db.update(db.orderLines)
              ..where((l) => l.id.equals(line.id)))
            .write(
              OrderLinesCompanion(
                orderId: Value(newOrderId),
                updatedAt: Value(now),
              ),
            );
        await Outbox.write(
          db,
          table: 'order_lines',
          rowId: line.id,
          operation: 'update',
          payload: {'id': line.id, 'orderId': newOrderId},
        );
      }
      await Outbox.write(
        db,
        table: 'orders',
        rowId: newOrderId,
        operation: 'insert',
        payload: {'id': newOrderId, 'status': 'open'},
      );
    });
    return newOrderId;
  }

  /// Merge bill: pindahkan semua baris [fromOrderId] ke [intoOrderId],
  /// lalu void order asal. Kedua order harus 'open'.
  static Future<void> mergeOrders(
    AppDatabase db, {
    required String intoOrderId,
    required String fromOrderId,
  }) async {
    if (intoOrderId == fromOrderId) {
      throw ArgumentError('Tidak bisa menggabungkan order dengan dirinya.');
    }
    await db.transaction(() async {
      final now = nowMs();
      final into = await (db.select(db.orders)
            ..where((o) => o.id.equals(intoOrderId)))
          .getSingleOrNull();
      final from = await (db.select(db.orders)
            ..where((o) => o.id.equals(fromOrderId)))
          .getSingleOrNull();
      if (into == null || from == null) {
        throw ArgumentError('Order tidak ditemukan.');
      }
      if (into.status != 'open' || from.status != 'open') {
        throw ArgumentError('Hanya order open yang bisa digabung.');
      }
      final lines = await (db.select(db.orderLines)
            ..where(
              (l) =>
                  l.orderId.equals(fromOrderId) & l.isDeleted.equals(0),
            ))
          .get();
      for (final line in lines) {
        // Gabung ke baris produk yang sama bila sudah ada di tujuan.
        final existing = await (db.select(db.orderLines)
              ..where(
                (l) =>
                    l.orderId.equals(intoOrderId) &
                    l.productId.equals(line.productId) &
                    l.isDeleted.equals(0),
              ))
            .getSingleOrNull();
        if (existing != null) {
          await (db.update(db.orderLines)
                ..where((l) => l.id.equals(existing.id)))
            .write(
              OrderLinesCompanion(
                qty: Value(existing.qty + line.qty),
                updatedAt: Value(now),
              ),
            );
          await (db.update(db.orderLines)
                ..where((l) => l.id.equals(line.id)))
            .write(
              OrderLinesCompanion(
                isDeleted: const Value(1),
                updatedAt: Value(now),
              ),
            );
        } else {
          await (db.update(db.orderLines)
                ..where((l) => l.id.equals(line.id)))
            .write(
              OrderLinesCompanion(
                orderId: Value(intoOrderId),
                updatedAt: Value(now),
              ),
            );
        }
      }
      await (db.update(db.orders)
            ..where((o) => o.id.equals(fromOrderId)))
        .write(
          OrdersCompanion(status: const Value('void'), updatedAt: Value(now)),
        );
      await Outbox.write(
        db,
        table: 'orders',
        rowId: fromOrderId,
        operation: 'update',
        payload: {'id': fromOrderId, 'status': 'void'},
      );
      await _refreshTableStatus(db, from.tableId);
    });
  }

  /// Tandai order sudah dibayar (setelah SaleService.recordSale sukses
  /// dengan orderId ini). Meja dikosongkan bila tidak ada order open lain.
  static Future<void> markPaid(
    AppDatabase db,
    String orderId,
  ) async {
    await db.transaction(() async {
      final now = nowMs();
      final order = await (db.select(db.orders)
            ..where((o) => o.id.equals(orderId)))
          .getSingleOrNull();
      if (order == null) throw ArgumentError('Order tidak ditemukan.');
      await (db.update(db.orders)
            ..where((o) => o.id.equals(orderId)))
        .write(
          OrdersCompanion(status: const Value('paid'), updatedAt: Value(now)),
        );
      await Outbox.write(
        db,
        table: 'orders',
        rowId: orderId,
        operation: 'update',
        payload: {'id': orderId, 'status': 'paid'},
      );
      await _refreshTableStatus(db, order.tableId);
    });
  }

  /// Void order open (belum bayar) — mis. pelanggan batal.
  static Future<void> voidOrder(AppDatabase db, String orderId) async {
    await db.transaction(() async {
      final now = nowMs();
      final order = await (db.select(db.orders)
            ..where((o) => o.id.equals(orderId)))
          .getSingleOrNull();
      if (order == null) throw ArgumentError('Order tidak ditemukan.');
      if (order.status != 'open') {
        throw ArgumentError('Order sudah ${order.status}.');
      }
      await (db.update(db.orders)
            ..where((o) => o.id.equals(orderId)))
        .write(
          OrdersCompanion(status: const Value('void'), updatedAt: Value(now)),
        );
      await Outbox.write(
        db,
        table: 'orders',
        rowId: orderId,
        operation: 'update',
        payload: {'id': orderId, 'status': 'void'},
      );
      await _refreshTableStatus(db, order.tableId);
    });
  }

  /// Tambah meja baru. Nama harus unik di antara meja aktif.
  static Future<String> addTable(AppDatabase db, String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) throw ArgumentError('Nama meja tidak boleh kosong.');
    final deviceId = await db.deviceId();
    final id = newId();
    await db.transaction(() async {
      final now = nowMs();
      final dup = await (db.select(db.shopTables)
            ..where(
              (t) => t.name.equals(trimmed) & t.isDeleted.equals(0),
            ))
          .getSingleOrNull();
      if (dup != null) {
        throw ArgumentError('Meja "$trimmed" sudah ada.');
      }
      await db.into(db.shopTables).insert(
            ShopTablesCompanion.insert(
              id: id,
              name: trimmed,
              status: 'kosong',
              updatedAt: now,
              deviceId: deviceId,
            ),
          );
      await Outbox.write(
        db,
        table: 'tables',
        rowId: id,
        operation: 'insert',
        payload: {'id': id, 'name': trimmed, 'status': 'kosong'},
      );
    });
    return id;
  }

  /// Ubah status meja manual (hanya 'kosong' | 'reserved').
  /// 'terisi' diatur otomatis oleh order, bukan manual.
  static Future<void> setTableStatusManual(
    AppDatabase db,
    String tableId,
    String status,
  ) async {
    if (status != 'kosong' && status != 'reserved') {
      throw ArgumentError('Status manual hanya kosong/reserved.');
    }
    await db.transaction(() async {
      await _setTableStatus(db, tableId, status);
    });
  }

  /// Total order (Rp) dari orderLines aktif.
  static Future<int> orderTotal(AppDatabase db, String orderId) async {
    final lines = await (db.select(db.orderLines)
          ..where(
            (l) => l.orderId.equals(orderId) & l.isDeleted.equals(0),
          ))
        .get();
    var total = 0;
    for (final l in lines) {
      total += l.price * l.qty;
    }
    return total;
  }

  static Future<void> _setTableStatus(
    AppDatabase db,
    String tableId,
    String status,
  ) async {
    final now = nowMs();
    await (db.update(db.shopTables)
          ..where((t) => t.id.equals(tableId)))
        .write(
          ShopTablesCompanion(status: Value(status), updatedAt: Value(now)),
        );
    await Outbox.write(
      db,
      table: 'tables',
      rowId: tableId,
      operation: 'update',
      payload: {'id': tableId, 'status': status},
    );
  }

  /// Setelah order paid/void: meja 'kosong' bila tidak ada order open
  /// lain di meja itu; 'reserved' dipertahankan.
  static Future<void> _refreshTableStatus(
    AppDatabase db,
    String? tableId,
  ) async {
    if (tableId == null) return;
    final open = await (db.select(db.orders)
          ..where(
            (o) => o.tableId.equals(tableId) & o.status.equals('open'),
          ))
        .get();
    if (open.isEmpty) {
      final table = await (db.select(db.shopTables)
            ..where((t) => t.id.equals(tableId)))
          .getSingleOrNull();
      if (table != null && table.status == 'terisi') {
        await _setTableStatus(db, tableId, 'kosong');
      }
    }
  }
}

/// Channel yang dikenal SaleService (disalin dari SaleService.channels
/// supaya service ini tidak bergantung ke file service lain).
const List<String> saleChannelValues = ['dine-in', 'takeaway', 'ojol'];
