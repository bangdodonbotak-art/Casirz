// Casirz ERP — Fase 1 Core Engine.
// Kontrak penjualan (BLUEPRINT-FLUTTER.md §5.2).
//
// Satu penjualan = SATU `db.transaction()` yang berisi, berurutan:
// 1. Buat sales + saleLines (HPP per baris via `computeHPPInTx`).
// 2. Buat salePayments (satu baris per metode; SUM(amount) == paid).
// 3. `deductBOM` per produk ber-BOM (atau kurangi `products.stock`
//    bila tanpa BOM — boleh minus).
// 4. `Ledger.postJournal` (penjualan + HPP — dua jurnal, masing-masing
//    seimbang; refId = id sale, refType = 'sale' dan 'sale-hpp').
// 5. Tulis `syncOutbox` (satu baris per tabel yang berubah) — di
//    transaksi yang sama, PALING AKHIR, supaya outbox tidak pernah
//    ketinggalan dari data.
//
// Model jurnal penjualan (seimbang menurut konstruksi):
//   total = subtotal - diskon + pajak + serviceCharge
//   dibayar = jumlah salePayments; kembalian = max(0, dibayar - total)
//   Syarat: (dibayar - kembalian) + komisiOjol == total
//   Jurnal: D kas per metode (tunai dikurangi kembalian; QRIS/ojol netto)
//           + D 4100 Diskon (bila ada) + D 4200 Komisi Ojol (bila ada)
//           / K 4000 (subtotal + serviceCharge) + K 2100 Pajak (bila ada)
//   Jurnal HPP: D 5000 totalHPP / K 1100 (bagian ber-BOM) + K 1110
//     (bagian produk tanpa BOM, HPP = products.cost — Fase 4, Adendum
//     pasca-Fase 1 butir 2). Void membalik baris jurnal asal apa adanya,
//     jadi pembalik ikut 1110 tanpa kode khusus.
//     (totalHPP = JUMLAH hppPerUnit baris yang sudah dibulatkan —
//     temuan ensemble: supaya jumlah baris selalu sama dengan jurnal).
//   Jurnal HPP dilewati bila totalHPP == 0.
//
// TEMUAN FASE 1 (diperbaiki Fase 4 — lihat Adendum pasca-Fase 1 butir 2):
// Produk tanpa BOM (mis. Air Mineral) HPP-nya = products.cost dan dulu
// dijurnal D 5000 / K 1100 seperti produk ber-BOM — padahal tidak ada
// nilai bahan yang terpakai. Akibatnya saldo akun 1100 jadi LEBIH KECIL
// dari jumlah ingredients.totalValue sebesar akumulasi HPP produk tanpa
// BOM (di seed demo: 3 x Rp2.500 = Rp7.500). Sejak Fase 4 HPP produk
// tanpa BOM dijurnal ke 1110 Persediaan Barang Dagangan, dan saldo 1100
// = Σ totalValue bahan persis.
//
// Void = transaksi baru: flag sales.voided = 1 (dengan guard
// `WHERE voided = 0`, temuan ensemble — void ganda ditolak), jurnal
// pembalik (semua baris dibalik, isReversal = 1, refType 'sale-void' /
// 'sale-hpp-void', refId = id sale), pengembalian stok dari `stockMoves`
// sale aslinya (baris 'void-kembali', memakai unitCostMilli SAAT
// penjualan — bukan resep saat ini). Jurnal asal TIDAK PERNAH dihapus
// atau diedit.
//
// CATATAN TERBUKA:
// - Poin pelanggan diakrual ATOMIK di dalam transaksi penjualan
//   (Fase 3, Adendum pasca-Fase 2 butir 2): 1 poin per Rp10.000
//   (floor(total/10000)) ke customer yang dipilih, param opsional
//   `accruePoints` (default true). Bila penjualan rollback (mis.
//   pembayaran kurang), poin ikut batal — tidak ada jalur akrual
//   terpisah lagi (CustomerService.accruePoints DIHAPUS).
//   Void membalik poin yang sama (floor(total/10000), clamp >= 0) —
//   akrual adalah fungsi deterministik dari total penjualan, jadi
//   pembalikan tanpa kolom tambahan tetap eksak selama penjualan
//   memakai jalur normal ini.
// - Metode bayar 'transfer'/'debit' masuk akun 1010 Bank (Fase 3,
//   Adendum pasca-Fase 2 butir 3); 'qris' (termasuk E-Wallet tampil)
//   tetap 1020; ojol netto tetap 1020 (BLUEPRINT §7.2).
// - Penjualan total Rp0 (mis. diskon 100%) ditolak di v1 — jurnal
//   bernilai nol tidak bisa seimbang secara bermakna.
import 'package:drift/drift.dart';

import 'bom.dart';
import 'db.dart';
import 'errors.dart';
import 'ledger.dart';
import 'sync.dart';

/// Satu baris keranjang penjualan.
class SaleLineInput {
  const SaleLineInput({required this.productId, required this.qty, this.price});
  final String productId;
  final int qty;
  final int? price; // null = pakai harga produk saat ini
}

/// Satu pembayaran dalam satu struk (multi-payment).
/// amount = uang yang DITERIMA lewat metode itu (netto untuk ojol).
class SalePaymentInput {
  const SalePaymentInput({required this.method, required this.amount});
  final String method; // 'tunai' | 'qris' | 'ojol'
  final int amount; // Rp
}

class SaleService {
  static const List<String> channels = ['dine-in', 'takeaway', 'ojol'];
  static const List<String> paymentMethods = [
    'tunai',
    'qris',
    'ojol',
    'transfer',
    'debit',
  ];

  /// Akun debit untuk satu metode bayar (BLUEPRINT §7.1 + Adendum
  /// pasca-Fase 2 butir 3): tunai -> 1000, transfer/debit -> 1010 Bank,
  /// qris/ojol -> 1020 QRIS/E-Wallet. Ojol netto tetap 1020 (§7.2).
  static String accountForMethod(String method) {
    switch (method) {
      case 'tunai':
        return '1000';
      case 'transfer':
      case 'debit':
        return '1010';
      case 'qris':
      case 'ojol':
        return '1020';
      default:
        throw ArgumentError('Metode bayar tidak dikenal: $method');
    }
  }

  /// Catat satu penjualan. Mengembalikan id sale (UUID).
  /// [employeeId] = karyawan yang login (dari sesi login, Fase 6).
  /// null = tanpa sesi login (DB kosong, gate terkecuali) — penjualan
  /// tetap dicatat, tampil sebagai "Tanpa login" di struk/transaksi.
  static Future<String> recordSale(
    AppDatabase db, {
    required DateTime date,
    required String channel,
    required List<SaleLineInput> lines,
    required List<SalePaymentInput> payments,
    String? employeeId,
    String? customerId,
    String? shiftId,
    String? orderId,
    int discount = 0,
    int tax = 0,
    int serviceCharge = 0,
    int ojolFee = 0,
    // Akrual poin atomik (Adendum pasca-Fase 2 butir 2): default true —
    // pemanggil lama (tanpa customerId / tanpa param ini) tidak berubah
    // perilakunya. `false` hanya untuk penjualan yang memang tidak
    // boleh memberi poin (saat ini tidak ada pemanggil seperti itu).
    bool accruePoints = true,
  }) async {
    if (!channels.contains(channel)) {
      throw ArgumentError('Channel tidak dikenal: $channel');
    }
    if (lines.isEmpty) {
      throw ArgumentError('Penjualan tanpa baris.');
    }
    if (payments.isEmpty) {
      throw ArgumentError('Penjualan tanpa pembayaran.');
    }
    for (final p in payments) {
      if (!paymentMethods.contains(p.method)) {
        throw ArgumentError('Metode bayar tidak dikenal: ${p.method}');
      }
      if (p.amount < 0) {
        throw ArgumentError('Jumlah bayar tidak boleh negatif.');
      }
    }
    if (discount < 0 || tax < 0 || serviceCharge < 0 || ojolFee < 0) {
      throw ArgumentError('Diskon/pajak/service/komisi tidak boleh negatif.');
    }
    if (channel == 'ojol' &&
        payments.any((p) => p.method != 'ojol')) {
      throw ArgumentError(
        'Channel ojol hanya boleh dibayar lewat metode ojol.',
      );
    }
    if (ojolFee > 0 && payments.every((p) => p.method != 'ojol')) {
      throw ArgumentError(
        'Komisi ojol hanya bila ada pembayaran ojol.',
      );
    }

    final deviceId = await db.deviceId();
    final saleId = newId();

    return db.transaction(() async {
      final now = nowMs();

      // Validasi referensi (karyawan hanya bila ada — null = tanpa login).
      if (employeeId != null) {
        final employee = await (db.select(db.employees)
              ..where((e) => e.id.equals(employeeId)))
            .getSingleOrNull();
        if (employee == null) {
          throw ArgumentError('Karyawan tidak ditemukan: $employeeId');
        }
      }
      if (customerId != null) {
        final customer = await (db.select(db.customers)
              ..where((c) => c.id.equals(customerId)))
            .getSingleOrNull();
        if (customer == null) {
          throw ArgumentError('Pelanggan tidak ditemukan: $customerId');
        }
      }
      if (shiftId != null) {
        final shift = await (db.select(db.shifts)
              ..where((s) => s.id.equals(shiftId)))
            .getSingleOrNull();
        if (shift == null) {
          throw ArgumentError('Shift tidak ditemukan: $shiftId');
        }
      }

      // Hitung total dari produk (harga snapshot saat transaksi).
      var subtotal = 0;
      final resolvedLines = <_ResolvedLine>[];
      for (final input in lines) {
        if (input.qty <= 0) {
          throw ArgumentError('qty harus > 0 (${input.productId}).');
        }
        final product = await (db.select(db.products)
              ..where((p) => p.id.equals(input.productId)))
            .getSingleOrNull();
        if (product == null) {
          throw ArgumentError('Produk tidak ditemukan: ${input.productId}');
        }
        final price = input.price ?? product.price;
        if (price < 0) {
          throw ArgumentError('Harga tidak boleh negatif.');
        }
        subtotal += price * input.qty;
        resolvedLines.add(
          _ResolvedLine(product: product, qty: input.qty, price: price),
        );
      }
      final total = subtotal - discount + tax + serviceCharge;
      if (total <= 0) {
        throw ArgumentError(
          'Total penjualan harus > 0 (subtotal Rp$subtotal, '
          'diskon Rp$discount, pajak Rp$tax, service Rp$serviceCharge).',
        );
      }
      if (discount > subtotal) {
        throw ArgumentError('Diskon melebihi subtotal.');
      }
      final paid = payments.fold<int>(0, (s, p) => s + p.amount);
      final change = paid > total ? paid - total : 0;
      if ((paid - change) + ojolFee != total) {
        throw PembayaranTidakCocok(
          'Uang diterima netto (Rp${paid - change}) + komisi ojol '
          '(Rp$ojolFee) != total Rp$total.',
        );
      }
      final tunaiAmount = payments
          .where((p) => p.method == 'tunai')
          .fold<int>(0, (s, p) => s + p.amount);
      if (change > 0 && tunaiAmount == 0) {
        throw PembayaranTidakCocok(
          'Kembalian Rp$change hanya mungkin untuk pembayaran tunai.',
        );
      }
      if (change > tunaiAmount) {
        throw PembayaranTidakCocok(
          'Kembalian Rp$change melebihi tunai yang diterima Rp$tunaiAmount.',
        );
      }

      // Kode struk dari counter harian DI DALAM transaksi yang sama.
      final code = await _nextSaleCode(db, date);

      // 1. sales + saleLines (HPP snapshot per baris).
      await db.into(db.sales).insert(
            SalesCompanion.insert(
              id: saleId,
              code: code,
              date: date.millisecondsSinceEpoch,
              channel: channel,
              paymentMethod: payments.length > 1
                  ? 'multi'
                  : payments.first.method,
              subtotal: subtotal,
              discount: Value(discount),
              tax: Value(tax),
              serviceCharge: Value(serviceCharge),
              ojolFee: Value(ojolFee),
              total: total,
              paid: paid,
              change: Value(change),
              shiftId: Value(shiftId),
              employeeId: Value(employeeId),
              customerId: Value(customerId),
              orderId: Value(orderId),
              updatedAt: now,
              deviceId: deviceId,
            ),
          );
      var totalHpp = 0;
      var totalHppBom = 0; // HPP produk ber-BOM -> K 1100
      var totalHppNoBom = 0; // HPP produk tanpa BOM -> K 1110 (Fase 4)
      final changedIngredients = <String>{};
      final changedProducts = <String>{};
      for (final line in resolvedLines) {
        final hppPerUnit =
            await Bom.computeHPPInTx(db, line.product.id, 1);
        final lineHpp = hppPerUnit * line.qty;
        totalHpp += lineHpp;
        if (await Bom.hasRecipe(db, line.product.id)) {
          totalHppBom += lineHpp;
        } else {
          totalHppNoBom += lineHpp;
        }
        await db.into(db.saleLines).insert(
              SaleLinesCompanion.insert(
                id: newId(),
                saleId: saleId,
                productId: line.product.id,
                qty: line.qty,
                price: line.price,
                hppPerUnit: hppPerUnit,
                updatedAt: now,
                deviceId: deviceId,
              ),
            );
      }

      // 2. salePayments.
      for (final p in payments) {
        await db.into(db.salePayments).insert(
              SalePaymentsCompanion.insert(
                id: newId(),
                saleId: saleId,
                method: p.method,
                amount: p.amount,
                processedAt: now,
                updatedAt: now,
                deviceId: deviceId,
              ),
            );
      }

      // 3. Potong stok (BOM atau products.stock — boleh minus).
      for (final line in resolvedLines) {
        final hasRecipe = await Bom.hasRecipe(db, line.product.id);
        if (hasRecipe) {
          for (final ingredientId
              in await Bom.recipeIngredientIds(db, line.product.id)) {
            changedIngredients.add(ingredientId);
          }
          await Bom.deductBOM(
            db,
            productId: line.product.id,
            qty: line.qty,
            saleId: saleId,
          );
        } else {
          changedProducts.add(line.product.id);
          await (db.update(db.products)
                ..where((p) => p.id.equals(line.product.id)))
              .write(
                ProductsCompanion(
                  stock: Value(line.product.stock - line.qty),
                  updatedAt: Value(now),
                ),
              );
        }
      }

      // 4a. Jurnal penjualan.
      final revenueLines = <JournalLineInput>[];
      final cashByMethod = <String, int>{};
      for (final p in payments) {
        cashByMethod[p.method] =
            (cashByMethod[p.method] ?? 0) + p.amount;
      }
      if (cashByMethod.containsKey('tunai')) {
        cashByMethod['tunai'] = cashByMethod['tunai']! - change;
      }
      // Agregasi per AKUN (bukan per metode): transfer + debit berbagi
      // akun 1010 jadi satu baris D 1010 — temuan ensemble Fase 3.
      final debitByAccount = <String, int>{};
      for (final entry in cashByMethod.entries) {
        if (entry.value <= 0) continue;
        final account = accountForMethod(entry.key);
        debitByAccount[account] =
            (debitByAccount[account] ?? 0) + entry.value;
      }
      for (final entry in debitByAccount.entries) {
        revenueLines.add(
          JournalLineInput(
            accountCode: entry.key,
            debit: entry.value,
            credit: 0,
          ),
        );
      }
      if (discount > 0) {
        revenueLines.add(
          JournalLineInput(accountCode: '4100', debit: discount, credit: 0),
        );
      }
      if (ojolFee > 0) {
        revenueLines.add(
          JournalLineInput(accountCode: '4200', debit: ojolFee, credit: 0),
        );
      }
      revenueLines.add(
        JournalLineInput(
          accountCode: '4000',
          debit: 0,
          credit: subtotal + serviceCharge,
        ),
      );
      if (tax > 0) {
        revenueLines.add(
          JournalLineInput(accountCode: '2100', debit: 0, credit: tax),
        );
      }
      final revenueJournalId = await Ledger.postJournal(
        db,
        date: date,
        memo: 'Penjualan $code',
        refType: 'sale',
        refId: saleId,
        lines: revenueLines,
      );

      // 4b. Jurnal HPP (dilewati bila totalHpp == 0).
      // Kredit dipisah: ber-BOM -> 1100, tanpa BOM -> 1110 (Fase 4).
      String? hppJournalId;
      if (totalHpp > 0) {
        final hppLines = <JournalLineInput>[
          JournalLineInput(accountCode: '5000', debit: totalHpp, credit: 0),
        ];
        if (totalHppBom > 0) {
          hppLines.add(
            JournalLineInput(
              accountCode: '1100',
              debit: 0,
              credit: totalHppBom,
            ),
          );
        }
        if (totalHppNoBom > 0) {
          hppLines.add(
            JournalLineInput(
              accountCode: '1110',
              debit: 0,
              credit: totalHppNoBom,
            ),
          );
        }
        hppJournalId = await Ledger.postJournal(
          db,
          date: date,
          memo: 'HPP penjualan $code',
          refType: 'sale-hpp',
          refId: saleId,
          lines: hppLines,
        );
      }

      // 4c. Akrual poin pelanggan — DI DALAM transaksi yang sama
      // (temuan ensemble Fase 3: setelah jurnal, sebelum outbox).
      // 1 poin per Rp10.000, floor(total/10000). Bila transaksi ini
      // rollback di titik mana pun, poin ikut batal — tidak ada lagi
      // jalur akrual terpisah di luar transaksi penjualan.
      var pointsEarned = 0;
      var newCustomerPoints = 0;
      if (customerId != null && accruePoints) {
        pointsEarned = total ~/ 10000;
        if (pointsEarned > 0) {
          final customer = await (db.select(db.customers)
                ..where((c) => c.id.equals(customerId)))
              .getSingle();
          newCustomerPoints = customer.points + pointsEarned;
          await (db.update(db.customers)
                ..where((c) => c.id.equals(customerId)))
              .write(
                CustomersCompanion(
                  points: Value(newCustomerPoints),
                  updatedAt: Value(now),
                ),
              );
        }
      }

      // 5. Outbox — PALING AKHIR dalam transaksi.
      await Outbox.write(
        db,
        table: 'sales',
        rowId: saleId,
        operation: 'insert',
        payload: {
          'id': saleId,
          'code': code,
          'date': date.millisecondsSinceEpoch,
          'channel': channel,
          'total': total,
          'paid': paid,
          'change': change,
        },
      );
      final saleLineRows = await (db.select(db.saleLines)
            ..where((l) => l.saleId.equals(saleId)))
          .get();
      for (final row in saleLineRows) {
        await Outbox.write(
          db,
          table: 'sale_lines',
          rowId: row.id,
          operation: 'insert',
          payload: {
            'id': row.id,
            'saleId': row.saleId,
            'productId': row.productId,
            'qty': row.qty,
            'price': row.price,
            'hppPerUnit': row.hppPerUnit,
          },
        );
      }
      final paymentRows = await (db.select(db.salePayments)
            ..where((p) => p.saleId.equals(saleId)))
          .get();
      for (final row in paymentRows) {
        await Outbox.write(
          db,
          table: 'sale_payments',
          rowId: row.id,
          operation: 'insert',
          payload: {
            'id': row.id,
            'saleId': row.saleId,
            'method': row.method,
            'amount': row.amount,
          },
        );
      }
      final moveRows = await (db.select(db.stockMoves)
            ..where(
              (m) => m.refType.equals('sale') & m.refId.equals(saleId),
            ))
          .get();
      for (final row in moveRows) {
        await Outbox.write(
          db,
          table: 'stock_moves',
          rowId: row.id,
          operation: 'insert',
          payload: {
            'id': row.id,
            'ingredientId': row.ingredientId,
            'qty': row.qty,
            'unitCostMilli': row.unitCostMilli,
            'refType': row.refType,
            'refId': row.refId,
          },
        );
      }
      await Outbox.writeJournal(db, revenueJournalId);
      if (hppJournalId != null) {
        await Outbox.writeJournal(db, hppJournalId);
      }
      if (pointsEarned > 0) {
        await Outbox.write(
          db,
          table: 'customers',
          rowId: customerId!,
          operation: 'update',
          payload: {'id': customerId, 'points': newCustomerPoints},
        );
      }
      for (final ingredientId in changedIngredients) {
        final ing = await (db.select(db.ingredients)
              ..where((i) => i.id.equals(ingredientId)))
            .getSingle();
        await Outbox.write(
          db,
          table: 'ingredients',
          rowId: ing.id,
          operation: 'update',
          payload: {
            'id': ing.id,
            'stockQty': ing.stockQty,
            'avgCostMilli': ing.avgCostMilli,
            'totalValue': ing.totalValue,
          },
        );
      }
      for (final productId in changedProducts) {
        final prod = await (db.select(db.products)
              ..where((p) => p.id.equals(productId)))
            .getSingle();
        await Outbox.write(
          db,
          table: 'products',
          rowId: prod.id,
          operation: 'update',
          payload: {'id': prod.id, 'stock': prod.stock},
        );
      }

      return saleId;
    });
  }

  /// Batalkan penjualan: jurnal pembalik + stok kembali.
  /// Throw [PenjualanSudahDibatalkan] bila sudah pernah dibatalkan.
  static Future<void> voidSale(AppDatabase db, String saleId) async {
    await db.transaction(() async {
      final now = nowMs();
      final sale = await (db.select(db.sales)
            ..where((s) => s.id.equals(saleId)))
          .getSingleOrNull();
      if (sale == null) {
        throw ArgumentError('Penjualan tidak ditemukan: $saleId');
      }
      if (sale.voided == 1) {
        throw PenjualanSudahDibatalkan(saleId);
      }
      // Guard atomik (temuan ensemble): hanya berhasil bila masih voided=0.
      final affected = await (db.update(db.sales)
            ..where((s) => s.id.equals(saleId) & s.voided.equals(0)))
          .write(
            SalesCompanion(
              voided: const Value(1),
              voidedAt: Value(now),
              updatedAt: Value(now),
            ),
          );
      if (affected != 1) {
        throw PenjualanSudahDibatalkan(saleId);
      }

      // Jurnal pembalik untuk tiap jurnal asal (refType berbeda supaya
      // UNIQUE(refType, refId) tetap terpenuhi).
      const pairs = {'sale': 'sale-void', 'sale-hpp': 'sale-hpp-void'};
      final reversalJournalIds = <String>[];
      for (final entry in pairs.entries) {
        final original = await (db.select(db.journals)
              ..where(
                (j) =>
                    j.refType.equals(entry.key) & j.refId.equals(saleId),
              ))
            .getSingleOrNull();
        if (original == null) continue;
        final originalLines = await (db.select(db.journalLines)
              ..where((l) => l.journalId.equals(original.id)))
            .get();
        final reversed = originalLines
            .map(
              (l) => JournalLineInput(
                accountCode: l.accountCode,
                debit: l.credit,
                credit: l.debit,
              ),
            )
            .toList();
        final reversalId = await Ledger.postJournal(
          db,
          date: DateTime.now(),
          memo: 'Void: ${original.memo}',
          refType: entry.value,
          refId: saleId,
          lines: reversed,
          reversesJournalId: original.id,
          isReversal: true,
        );
        reversalJournalIds.add(reversalId);
      }

      // Kembalikan stok dari stockMoves ASLI (bukan resep saat ini).
      final moves = await (db.select(db.stockMoves)
            ..where(
              (m) =>
                  m.refType.equals('sale') &
                  m.refId.equals(saleId) &
                  m.type.equals('konsumsi'),
            ))
          .get();
      final changedIngredients = <String>{};
      for (final move in moves) {
        changedIngredients.add(move.ingredientId);
        await Bom.adjustStock(
          db,
          ingredientId: move.ingredientId,
          qtyDelta: -move.qty, // qty konsumsi negatif -> kembali positif
          type: 'void-kembali',
          refType: 'void',
          refId: saleId,
          unitCostMilliOverride: move.unitCostMilli,
        );
      }

      // Kembalikan products.stock untuk produk tanpa BOM.
      final lines = await (db.select(db.saleLines)
            ..where((l) => l.saleId.equals(saleId)))
          .get();
      final changedProducts = <String>{};
      for (final line in lines) {
        if (await Bom.hasRecipe(db, line.productId)) continue;
        changedProducts.add(line.productId);
        final product = await (db.select(db.products)
              ..where((p) => p.id.equals(line.productId)))
            .getSingle();
        await (db.update(db.products)
              ..where((p) => p.id.equals(line.productId)))
            .write(
              ProductsCompanion(
                stock: Value(product.stock + line.qty),
                updatedAt: Value(now),
              ),
            );
      }

      // Balik poin pelanggan yang diakrual penjualan ini
      // (floor(total/10000), clamp >= 0). Tanpa ini, jual-dapat-poin
      // lalu void akan menyimpan poin dari penjualan yang batal —
      // temuan ensemble Fase 3. Eksak karena akrual adalah fungsi
      // deterministik dari total penjualan (tidak ada penukaran poin
      // di v1); satu-satunya pengecualian adalah penjualan yang
      // dipanggil dengan accruePoints: false — tidak ada pemanggil
      // seperti itu saat ini.
      var pointsReversed = 0;
      var newCustomerPoints = 0;
      if (sale.customerId != null) {
        final earned = sale.total ~/ 10000;
        if (earned > 0) {
          final customer = await (db.select(db.customers)
                ..where((c) => c.id.equals(sale.customerId!)))
              .getSingleOrNull();
          if (customer != null && customer.points > 0) {
            pointsReversed =
                earned > customer.points ? customer.points : earned;
            newCustomerPoints = customer.points - pointsReversed;
            await (db.update(db.customers)
                  ..where((c) => c.id.equals(sale.customerId!)))
                .write(
                  CustomersCompanion(
                    points: Value(newCustomerPoints),
                    updatedAt: Value(now),
                  ),
                );
          }
        }
      }

      // Outbox — paling akhir.
      await Outbox.write(
        db,
        table: 'sales',
        rowId: saleId,
        operation: 'update',
        payload: {'id': saleId, 'voided': 1, 'voidedAt': now},
      );
      if (pointsReversed > 0) {
        await Outbox.write(
          db,
          table: 'customers',
          rowId: sale.customerId!,
          operation: 'update',
          payload: {'id': sale.customerId, 'points': newCustomerPoints},
        );
      }
      for (final id in reversalJournalIds) {
        await Outbox.writeJournal(db, id);
      }
      final voidMoves = await (db.select(db.stockMoves)
            ..where(
              (m) => m.refType.equals('void') & m.refId.equals(saleId),
            ))
          .get();
      for (final row in voidMoves) {
        await Outbox.write(
          db,
          table: 'stock_moves',
          rowId: row.id,
          operation: 'insert',
          payload: {
            'id': row.id,
            'ingredientId': row.ingredientId,
            'qty': row.qty,
            'unitCostMilli': row.unitCostMilli,
            'refType': row.refType,
            'refId': row.refId,
          },
        );
      }
      for (final ingredientId in changedIngredients) {
        final ing = await (db.select(db.ingredients)
              ..where((i) => i.id.equals(ingredientId)))
            .getSingle();
        await Outbox.write(
          db,
          table: 'ingredients',
          rowId: ing.id,
          operation: 'update',
          payload: {
            'id': ing.id,
            'stockQty': ing.stockQty,
            'avgCostMilli': ing.avgCostMilli,
            'totalValue': ing.totalValue,
          },
        );
      }
      for (final productId in changedProducts) {
        final prod = await (db.select(db.products)
              ..where((p) => p.id.equals(productId)))
            .getSingle();
        await Outbox.write(
          db,
          table: 'products',
          rowId: prod.id,
          operation: 'update',
          payload: {'id': prod.id, 'stock': prod.stock},
        );
      }
    });
  }

  /// Kode struk 'CSZ-YYYYMMDD-XXXX' dari counter harian di dalam
  /// transaksi yang sama (dua kasir tidak dapat nomor sama).
  static Future<String> _nextSaleCode(AppDatabase db, DateTime date) async {
    final day =
        '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';
    final prefix = 'CSZ-$day-';
    final rows = await (db.select(db.sales)
          ..where((s) => s.code.like('$prefix%')))
        .get();
    var max = 0;
    for (final row in rows) {
      final suffix = int.tryParse(row.code.substring(prefix.length)) ?? 0;
      if (suffix > max) max = suffix;
    }
    return '$prefix${(max + 1).toString().padLeft(4, '0')}';
  }
}

class _ResolvedLine {
  _ResolvedLine({
    required this.product,
    required this.qty,
    required this.price,
  });
  final Product product;
  final int qty;
  final int price;
}
