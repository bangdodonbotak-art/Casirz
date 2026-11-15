// Casirz ERP — Fase 1 Core Engine.
// Service akuntansi & stok (BLUEPRINT-FLUTTER.md §7.2).
//
// Setiap fungsi membuka SATU `db.transaction()` yang berisi mutasi
// + jurnal + outbox. `Ledger`/`Bom` tidak pernah membuka transaksi
// sendiri (lihat catatan adaptasi di ledger.dart).
//
// Aturan posting (PERSIS §7.2):
// - Stock-in tunai: D 1100 / K 1000; utang supplier: D 1100 / K 2000;
//   bank: D 1100 / K 1010.
// - Wastage: D 5210 / K 1100.
// - Opname susut: D 5200 / K 1100; surplus: D 1100 / K 5200.
// - OPEX: D 51xx / K 1000 (tunai) atau K 1010 (bank).
// - Gaji: D 5130 / K 1000 atau 1010.
// - Penyusutan: D 5180 / K 1310, garis lurus, bulan terakhir sisa
//   pembulatan, idempotent refId 'asset:<id>:<yyyy-MM>'.
// - Amortisasi sewa: D 5190 / K 1200, idempotent refId 'rent:<yyyy-MM>'.
// - Modal: D 1010/1200/1300/1100 (sesuai bentuk) / K 3000.
// - Settlement ojol: D 1010 / K 1020.
// - Isi petty: D 1030 / K 1000; belanja petty: D 51xx / K 1030.
// - Selisih kas kurang: D 5220 / K 1000; lebih: D 1000 / K 5220.
import 'package:drift/drift.dart';

import 'accounts.dart';
import 'bom.dart';
import 'db.dart';
import 'ledger.dart';
import 'money.dart';
import 'sync.dart';

class AccountingService {
  /// Kategori OPEX -> kode akun Beban (BLUEPRINT §7.1). Satu sumber
  /// kebenaran untuk form beban (UI) dan test.
  static const Map<String, String> opexAccounts = {
    'Listrik': '5100',
    'Air': '5110',
    'Internet/WiFi': '5120',
    'Gaji Staf': '5130',
    'Sewa Tempat': '5140',
    'Kebersihan/Keamanan': '5150',
    'Marketing': '5160',
    'Lain-lain': '5170',
  };

  /// Kode akun Beban untuk satu kategori OPEX. Throw bila kategori
  /// tidak dikenal.
  static String expenseAccountForCategory(String category) {
    final code = opexAccounts[category];
    if (code == null) {
      throw ArgumentError('Kategori beban tidak dikenal: $category');
    }
    return code;
  }

  /// True bila modal awal sudah pernah dicatat (jurnal refType 'modal'
  /// apa pun — termasuk 'seed-modal' dari seed demo). Modal awal hanya
  /// bisa diisi sekali; reset hanya lewat reset demo/seed.
  static Future<bool> hasCapitalRecorded(AppDatabase db) async {
    final row = await (db.select(db.journals)
          ..where((j) => j.refType.equals('modal'))
          ..limit(1))
        .getSingleOrNull();
    return row != null;
  }

  /// Jurnal modal awal pertama (untuk tampilan "sudah tercatat"), null
  /// bila belum ada.
  static Future<Journal?> firstCapitalJournal(AppDatabase db) async {
    return (db.select(db.journals)
          ..where((j) => j.refType.equals('modal'))
          ..orderBy([(j) => OrderingTerm.asc(j.date)])
          ..limit(1))
        .getSingleOrNull();
  }
  static Future<String> recordStockIn(
    AppDatabase db, {
    required String ingredientId,
    required double qty,
    required int totalCost,
    String payFrom = 'tunai',
    String? supplier,
  }) async {
    if (payFrom != 'tunai' && payFrom != 'bank' && payFrom != 'utang') {
      throw ArgumentError('payFrom harus tunai/bank/utang.');
    }
    return db.transaction(() async {
      final moveId = await Bom.stockIn(
        db,
        ingredientId: ingredientId,
        qty: qty,
        totalCost: totalCost,
      );
      final creditAccount = payFrom == 'utang'
          ? '2000'
          : payFrom == 'bank'
              ? '1010'
              : '1000';
      final journalId = await Ledger.postJournal(
        db,
        date: DateTime.now(),
        memo: 'Stock-in ${supplier != null ? '$supplier: ' : ''}'
            'Rp${fmt(totalCost)}',
        refType: 'stock-in',
        refId: moveId,
        lines: [
          JournalLineInput(accountCode: '1100', debit: totalCost, credit: 0),
          JournalLineInput(
            accountCode: creditAccount,
            debit: 0,
            credit: totalCost,
          ),
        ],
      );
      await Outbox.write(
        db,
        table: 'stock_moves',
        rowId: moveId,
        operation: 'insert',
        payload: {
          'id': moveId,
          'ingredientId': ingredientId,
          'qty': qty,
          'totalCost': totalCost,
        },
      );
      await Outbox.writeJournal(db, journalId);
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
      return moveId;
    });
  }

  /// Catat wastage + jurnal D 5210 / K 1100.
  /// Mengembalikan nilai Rp wastage.
  static Future<int> recordWastage(
    AppDatabase db, {
    required String ingredientId,
    required double qty,
    required String reason,
  }) async {
    return db.transaction(() async {
      final result = await Bom.logWastage(
        db,
        ingredientId: ingredientId,
        qty: qty,
        reason: reason,
      );
      final amount = result.amount;
      final move = result.moveId;
      final journalId = await Ledger.postJournal(
        db,
        date: DateTime.now(),
        memo: 'Wastage: $reason',
        refType: 'wastage',
        refId: move,
        lines: [
          JournalLineInput(accountCode: '5210', debit: amount, credit: 0),
          JournalLineInput(accountCode: '1100', debit: 0, credit: amount),
        ],
      );
      await Outbox.write(
        db,
        table: 'stock_moves',
        rowId: move,
        operation: 'insert',
        payload: {
          'id': move,
          'ingredientId': ingredientId,
          'qty': -qty,
          'reason': reason,
        },
      );
      await Outbox.writeJournal(db, journalId);
      return amount;
    });
  }

  /// Buat sesi opname draft. [actualByIngredient] = stok aktual per bahan.
  /// Mengembalikan id opname.
  static Future<String> createOpnameDraft(
    AppDatabase db, {
    required String employeeId,
    required Map<String, double> actualByIngredient,
    String? note,
  }) async {
    final deviceId = await db.deviceId();
    return db.transaction(() async {
      final now = nowMs();
      final opnameId = newId();
      await db.into(db.stockOpnames).insert(
            StockOpnamesCompanion.insert(
              id: opnameId,
              date: now,
              employeeId: employeeId,
              status: 'draft',
              note: Value(note),
              updatedAt: now,
              deviceId: deviceId,
            ),
          );
      for (final entry in actualByIngredient.entries) {
        final ing = await (db.select(db.ingredients)
              ..where((i) => i.id.equals(entry.key)))
            .getSingleOrNull();
        if (ing == null) {
          throw ArgumentError('Bahan tidak ditemukan: ${entry.key}');
        }
        final actual = round3(entry.value);
        await db.into(db.stockOpnameLines).insert(
              StockOpnameLinesCompanion.insert(
                id: newId(),
                opnameId: opnameId,
                ingredientId: ing.id,
                systemQty: ing.stockQty,
                actualQty: actual,
                diffQty: round3(actual - ing.stockQty),
                updatedAt: now,
                deviceId: deviceId,
              ),
            );
      }
      return opnameId;
    });
  }

  /// Posting opname draft: sesuaikan stok ke aktual + jurnal selisih.
  /// Susut (diff < 0): D 5200 / K 1100. Surplus (diff > 0): D 1100 / K 5200.
  /// Hanya sekali — opname 'posted' tidak bisa diposting ulang.
  static Future<void> postOpname(AppDatabase db, String opnameId) async {
    await db.transaction(() async {
      final now = nowMs();
      final opname = await (db.select(db.stockOpnames)
            ..where((o) => o.id.equals(opnameId)))
          .getSingleOrNull();
      if (opname == null) {
        throw ArgumentError('Opname tidak ditemukan: $opnameId');
      }
      if (opname.status == 'posted') {
        throw StateError('Opname sudah diposting — tidak bisa diubah.');
      }
      final lines = await (db.select(db.stockOpnameLines)
            ..where((l) => l.opnameId.equals(opnameId)))
          .get();
      var totalSusut = 0;
      var totalSurplus = 0;
      final changedIngredients = <String>{};
      for (final line in lines) {
        if (line.diffQty == 0) continue;
        changedIngredients.add(line.ingredientId);
        final valueDelta = await Bom.adjustStock(
          db,
          ingredientId: line.ingredientId,
          qtyDelta: line.diffQty,
          type: 'opname',
          refType: 'opname',
          refId: opnameId,
        );
        if (valueDelta < 0) {
          totalSusut += -valueDelta;
        } else {
          totalSurplus += valueDelta;
        }
      }
      if (totalSusut > 0 || totalSurplus > 0) {
        final journalLines = <JournalLineInput>[];
        if (totalSusut > 0) {
          journalLines.add(
            JournalLineInput(accountCode: '5200', debit: totalSusut, credit: 0),
          );
          journalLines.add(
            JournalLineInput(accountCode: '1100', debit: 0, credit: totalSusut),
          );
        }
        if (totalSurplus > 0) {
          journalLines.add(
            JournalLineInput(accountCode: '1100', debit: totalSurplus, credit: 0),
          );
          journalLines.add(
            JournalLineInput(accountCode: '5200', debit: 0, credit: totalSurplus),
          );
        }
        final journalId = await Ledger.postJournal(
          db,
          date: DateTime.fromMillisecondsSinceEpoch(opname.date),
          memo: 'Stok opname ${opname.id.substring(0, 8)}',
          refType: 'opname',
          refId: opnameId,
          lines: journalLines,
        );
        await Outbox.writeJournal(db, journalId);
      }
      await (db.update(db.stockOpnames)
            ..where((o) => o.id.equals(opnameId)))
          .write(
            StockOpnamesCompanion(
              status: const Value('posted'),
              updatedAt: Value(now),
            ),
          );
      await Outbox.write(
        db,
        table: 'stock_opnames',
        rowId: opnameId,
        operation: 'update',
        payload: {'id': opnameId, 'status': 'posted'},
      );
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
            'totalValue': ing.totalValue,
          },
        );
      }
    });
  }

  /// Catat beban OPEX + jurnal D [accountCode] / K 1000 (tunai) atau
  /// K 1010 (bank). [accountCode] harus akun Beban yang ada di bagan.
  static Future<String> recordExpense(
    AppDatabase db, {
    required DateTime date,
    required String category,
    required int amount,
    required String accountCode,
    required String note,
    String payFrom = 'tunai',
    String? employeeId,
  }) async {
    if (amount <= 0) {
      throw ArgumentError('Jumlah beban harus > 0.');
    }
    final def = ChartOfAccounts.byCode(accountCode);
    if (def.type != AccountType.beban) {
      throw ArgumentError(
        'Akun $accountCode bukan akun Beban (tipe: ${def.type.name}).',
      );
    }
    if (payFrom != 'tunai' && payFrom != 'bank') {
      throw ArgumentError('payFrom harus tunai/bank.');
    }
    final deviceId = await db.deviceId();
    return db.transaction(() async {
      final now = nowMs();
      final expenseId = newId();
      await db.into(db.expenses).insert(
            ExpensesCompanion.insert(
              id: expenseId,
              date: date.millisecondsSinceEpoch,
              category: category,
              amount: amount,
              accountCode: accountCode,
              note: note,
              employeeId: Value(employeeId),
              updatedAt: now,
              deviceId: deviceId,
            ),
          );
      final journalId = await Ledger.postJournal(
        db,
        date: date,
        memo: 'Beban $category: $note',
        refType: 'expense',
        refId: expenseId,
        lines: [
          JournalLineInput(accountCode: accountCode, debit: amount, credit: 0),
          JournalLineInput(
            accountCode: payFrom == 'bank' ? '1010' : '1000',
            debit: 0,
            credit: amount,
          ),
        ],
      );
      await Outbox.write(
        db,
        table: 'expenses',
        rowId: expenseId,
        operation: 'insert',
        payload: {
          'id': expenseId,
          'category': category,
          'amount': amount,
          'accountCode': accountCode,
        },
      );
      await Outbox.writeJournal(db, journalId);
      return expenseId;
    });
  }

  /// Bayar gaji satu periode + jurnal D 5130 / K 1000 atau 1010.
  /// Idempotent per (employeeId, period) — UNIQUE di tabel payrolls.
  static Future<String> paySalary(
    AppDatabase db, {
    required String employeeId,
    required String period, // 'yyyy-MM'
    required int baseSalary,
    int deductions = 0,
    String payFrom = 'tunai',
  }) async {
    if (baseSalary < 0 || deductions < 0) {
      throw ArgumentError('Gaji/potongan tidak boleh negatif.');
    }
    final netPay = baseSalary - deductions;
    if (netPay < 0) {
      throw ArgumentError('Gaji bersih negatif — potongan melebihi gaji.');
    }
    if (payFrom != 'tunai' && payFrom != 'bank') {
      throw ArgumentError('payFrom harus tunai/bank.');
    }
    final deviceId = await db.deviceId();
    return db.transaction(() async {
      final now = nowMs();
      final payrollId = newId();
      await db.into(db.payrolls).insert(
            PayrollsCompanion.insert(
              id: payrollId,
              employeeId: employeeId,
              period: period,
              baseSalary: baseSalary,
              deductions: deductions,
              netPay: netPay,
              paidAt: Value(now),
              updatedAt: now,
              deviceId: deviceId,
            ),
          );
      final journalId = await Ledger.postJournal(
        db,
        date: DateTime.now(),
        memo: 'Gaji $period',
        refType: 'payroll',
        refId: payrollId,
        lines: [
          JournalLineInput(accountCode: '5130', debit: netPay, credit: 0),
          JournalLineInput(
            accountCode: payFrom == 'bank' ? '1010' : '1000',
            debit: 0,
            credit: netPay,
          ),
        ],
      );
      await Outbox.write(
        db,
        table: 'payrolls',
        rowId: payrollId,
        operation: 'insert',
        payload: {
          'id': payrollId,
          'employeeId': employeeId,
          'period': period,
          'netPay': netPay,
        },
      );
      await Outbox.writeJournal(db, journalId);
      return payrollId;
    });
  }

  /// Tambah aset tetap + jurnal D 1300 / K 1000 (tunai) atau K 1010
  /// (bank). Mengembalikan id aset. Penyusutan diproses bulanan via
  /// [processDepreciation] (garis lurus, idempotent per bulan).
  static Future<String> recordAsset(
    AppDatabase db, {
    required String name,
    required DateTime purchaseDate,
    required int cost,
    int residualValue = 0,
    required int usefulLifeMonths,
    String payFrom = 'tunai',
  }) async {
    if (name.trim().isEmpty) {
      throw ArgumentError('Nama aset wajib diisi.');
    }
    if (cost <= 0) {
      throw ArgumentError('Biaya perolehan aset harus > 0.');
    }
    if (residualValue < 0 || residualValue >= cost) {
      throw ArgumentError(
        'Nilai residu harus >= 0 dan < biaya perolehan.',
      );
    }
    if (usefulLifeMonths <= 0) {
      throw ArgumentError('Masa manfaat harus > 0 bulan.');
    }
    if (payFrom != 'tunai' && payFrom != 'bank') {
      throw ArgumentError('payFrom harus tunai/bank.');
    }
    final deviceId = await db.deviceId();
    return db.transaction(() async {
      final now = nowMs();
      final assetId = newId();
      await db.into(db.assets).insert(
            AssetsCompanion.insert(
              id: assetId,
              name: name.trim(),
              purchaseDate: purchaseDate.millisecondsSinceEpoch,
              cost: cost,
              residualValue: residualValue,
              usefulLifeMonths: usefulLifeMonths,
              updatedAt: now,
              deviceId: deviceId,
            ),
          );
      final journalId = await Ledger.postJournal(
        db,
        date: purchaseDate,
        memo: 'Beli aset tetap: ${name.trim()}',
        refType: 'aset',
        refId: assetId,
        lines: [
          JournalLineInput(accountCode: '1300', debit: cost, credit: 0),
          JournalLineInput(
            accountCode: payFrom == 'bank' ? '1010' : '1000',
            debit: 0,
            credit: cost,
          ),
        ],
      );
      await Outbox.write(
        db,
        table: 'assets',
        rowId: assetId,
        operation: 'insert',
        payload: {
          'id': assetId,
          'name': name.trim(),
          'cost': cost,
          'usefulLifeMonths': usefulLifeMonths,
        },
      );
      await Outbox.writeJournal(db, journalId);
      return assetId;
    });
  }

  /// Penyusutan garis lurus per bulan (Rp, dibulatkan):
  /// (cost - residualValue) / usefulLifeMonths.
  static int monthlyDepreciationAmount({
    required int cost,
    required int residualValue,
    required int usefulLifeMonths,
  }) {
    if (usefulLifeMonths <= 0) {
      throw ArgumentError('Masa manfaat harus > 0 bulan.');
    }
    return ((cost - residualValue) / usefulLifeMonths).round();
  }

  /// Jadwal penyusutan per bulan (Rp) — satu angka per bulan masa
  /// manfaat. Bulan terakhir = sisa pembulatan (jadi total jadwal =
  /// cost - residualValue persis, tanpa selisih sen).
  /// Contoh: 10jt / 60 bln, residu 0 -> 59 x 166.667 + 166.647.
  static List<int> depreciationScheduleAmounts({
    required int cost,
    required int residualValue,
    required int usefulLifeMonths,
  }) {
    final monthly = monthlyDepreciationAmount(
      cost: cost,
      residualValue: residualValue,
      usefulLifeMonths: usefulLifeMonths,
    );
    final depreciable = cost - residualValue;
    return List<int>.generate(usefulLifeMonths, (i) {
      if (i == usefulLifeMonths - 1) {
        return depreciable - monthly * (usefulLifeMonths - 1);
      }
      return monthly;
    });
  }

  /// Nilai buku aset = biaya perolehan - akumulasi penyusutan.
  static int bookValue(Asset asset) =>
      asset.cost - asset.accumulatedDepreciation;

  /// Proses penyusutan SEMUA aset untuk bulan [month] ('yyyy-MM').
  /// Garis lurus: (cost - residual) / usefulLifeMonths per bulan
  /// (dibulatkan); bulan terakhir = sisa pembulatan.
  /// Idempotent: jurnal memakai refId 'asset:{id}:{yyyy-MM}' — memanggil
  /// 2x di bulan yang sama tidak menggandakan jurnal maupun akumulasi.
  /// Mengembalikan total penyusutan bulan itu (Rp).
  static Future<int> processDepreciation(
    AppDatabase db,
    String month, {
    DateTime? date,
  }) async {
    final effectiveDate = date ?? DateTime.now();
    final assets = await db.select(db.assets).get();
    var total = 0;
    for (final asset in assets) {
      if (asset.isDeleted == 1) continue;
      final refId = 'asset:${asset.id}:$month';
      if (await Ledger.journalExists(
        db,
        refType: 'penyusutan',
        refId: refId,
      )) {
        continue; // sudah diproses bulan ini — idempotent
      }
      final depreciable = asset.cost - asset.residualValue;
      final remaining = depreciable - asset.accumulatedDepreciation;
      if (remaining <= 0) continue;
      final monthly = monthlyDepreciationAmount(
        cost: asset.cost,
        residualValue: asset.residualValue,
        usefulLifeMonths: asset.usefulLifeMonths,
      );
      final amount = monthly >= remaining ? remaining : monthly;
      if (amount <= 0) continue;
      // SATU transaksi: jurnal + update aset + outbox atomik.
      // (Dua transaksi terpisah berisiko jurnal ada tapi aset tidak
      // ter-update, dan retry akan mengira bulan itu sudah diproses.)
      await db.transaction(() async {
        final journalId = await Ledger.postJournal(
          db,
          date: effectiveDate,
          memo: 'Penyusutan ${asset.name} $month',
          refType: 'penyusutan',
          refId: refId,
          lines: [
            JournalLineInput(accountCode: '5180', debit: amount, credit: 0),
            JournalLineInput(accountCode: '1310', debit: 0, credit: amount),
          ],
        );
        await (db.update(db.assets)
              ..where((a) => a.id.equals(asset.id)))
            .write(
              AssetsCompanion(
                accumulatedDepreciation:
                    Value(asset.accumulatedDepreciation + amount),
                lastDepreciationMonth: Value(month),
                updatedAt: Value(nowMs()),
              ),
            );
        await Outbox.writeJournal(db, journalId);
        await Outbox.write(
          db,
          table: 'assets',
          rowId: asset.id,
          operation: 'update',
          payload: {
            'id': asset.id,
            'accumulatedDepreciation':
                asset.accumulatedDepreciation + amount,
            'lastDepreciationMonth': month,
          },
        );
      });
      total += amount;
    }
    return total;
  }

  /// Amortisasi sewa satu bulan [month] ('yyyy-MM') dari settings
  /// rentTotal / rentMonths / rentStartMonth.
  /// Idempotent: refId 'rent:{yyyy-MM}'. Bulan terakhir = sisa pembulatan.
  /// Mengembalikan jumlah yang diamortisasi (Rp, 0 bila di luar masa sewa).
  static Future<int> processRentAmortization(
    AppDatabase db,
    String month, {
    DateTime? date,
  }) async {
    final rentTotal = int.tryParse(await db.getSetting('rentTotal') ?? '') ?? 0;
    final rentMonths =
        int.tryParse(await db.getSetting('rentMonths') ?? '') ?? 0;
    final rentStart = await db.getSetting('rentStartMonth') ?? '';
    if (rentTotal <= 0 || rentMonths <= 0 || rentStart.isEmpty) {
      return 0; // sewa belum diatur — bukan error, tidak ada yang diamortisasi
    }
    final monthIndex = _monthDiff(rentStart, month);
    if (monthIndex < 0 || monthIndex >= rentMonths) {
      return 0; // di luar masa sewa
    }
    final refId = 'rent:$month';
    if (await Ledger.journalExists(
      db,
      refType: 'amortisasi-sewa',
      refId: refId,
    )) {
      return 0; // sudah diproses bulan ini — idempotent
    }
    final monthly = (rentTotal / rentMonths).round();
    final amount = monthIndex == rentMonths - 1
        ? rentTotal - monthly * (rentMonths - 1) // bulan terakhir: sisa
        : monthly;
    if (amount <= 0) return 0;
    await Ledger.postJournalStandalone(
      db,
      date: date ?? DateTime.now(),
      memo: 'Amortisasi sewa $month',
      refType: 'amortisasi-sewa',
      refId: refId,
      lines: [
        JournalLineInput(accountCode: '5190', debit: amount, credit: 0),
        JournalLineInput(accountCode: '1200', debit: 0, credit: amount),
      ],
    );
    return amount;
  }

  /// Selisih bulan 'yyyy-MM': month - start (bisa negatif).
  static int _monthDiff(String start, String month) {
    int parse(String s) {
      final parts = s.split('-');
      return int.parse(parts[0]) * 12 + int.parse(parts[1]);
    }

    return parse(month) - parse(start);
  }

  /// Modal awal disetor. Hanya baris > 0 yang dijurnal.
  /// D 1000 kas tunai + D 1010 bank + D 1200 sewa muka + D 1300 aset
  /// + D 1100 persediaan / K 3000 Modal Disetor.
  /// Catatan: sewa (1200) diamortisasi bulanan via
  /// [processRentAmortization] dari settings rentTotal/rentMonths/
  /// rentStartMonth — pengaturan settings itu urusan pemanggil (UI Modal
  /// Awal menulisnya setelah jurnal berhasil).
  static Future<String> recordCapital(
    AppDatabase db, {
    required DateTime date,
    int cash = 0,
    int bank = 0,
    int rentPrepaid = 0,
    int assets = 0,
    int inventory = 0,
    String refId = 'modal-awal',
    String memo = 'Modal awal disetor',
  }) async {
    final total = cash + bank + rentPrepaid + assets + inventory;
    if (total <= 0) {
      throw ArgumentError('Modal awal harus > 0.');
    }
    final lines = <JournalLineInput>[];
    if (cash > 0) {
      lines.add(JournalLineInput(accountCode: '1000', debit: cash, credit: 0));
    }
    if (bank > 0) {
      lines.add(JournalLineInput(accountCode: '1010', debit: bank, credit: 0));
    }
    if (rentPrepaid > 0) {
      lines.add(
        JournalLineInput(accountCode: '1200', debit: rentPrepaid, credit: 0),
      );
    }
    if (assets > 0) {
      lines.add(
        JournalLineInput(accountCode: '1300', debit: assets, credit: 0),
      );
    }
    if (inventory > 0) {
      lines.add(
        JournalLineInput(accountCode: '1100', debit: inventory, credit: 0),
      );
    }
    lines.add(
      JournalLineInput(accountCode: '3000', debit: 0, credit: total),
    );
    return Ledger.postJournalStandalone(
      db,
      date: date,
      memo: memo,
      refType: 'modal',
      refId: refId,
      lines: lines,
    );
  }

  /// Settlement ojol/QRIS masuk bank: D 1010 / K 1020.
  static Future<String> recordSettlement(
    AppDatabase db, {
    required DateTime date,
    required int amount,
    String memo = 'Settlement ojol/QRIS masuk bank',
  }) async {
    if (amount <= 0) {
      throw ArgumentError('Jumlah settlement harus > 0.');
    }
    return Ledger.postJournalStandalone(
      db,
      date: date,
      memo: memo,
      refType: 'settlement',
      refId: newId(),
      lines: [
        JournalLineInput(accountCode: '1010', debit: amount, credit: 0),
        JournalLineInput(accountCode: '1020', debit: 0, credit: amount),
      ],
    );
  }

  /// Isi petty cash dari laci: D 1030 / K 1000.
  static Future<String> fillPettyCash(
    AppDatabase db, {
    required DateTime date,
    required int amount,
    required String employeeId,
    String? shiftId,
    String note = 'Isi petty cash',
  }) async {
    if (amount <= 0) {
      throw ArgumentError('Jumlah isi petty harus > 0.');
    }
    final deviceId = await db.deviceId();
    return db.transaction(() async {
      final now = nowMs();
      final pettyId = newId();
      await db.into(db.pettyCash).insert(
            PettyCashCompanion.insert(
              id: pettyId,
              shiftId: Value(shiftId),
              date: date.millisecondsSinceEpoch,
              amount: amount,
              note: note,
              employeeId: employeeId,
              updatedAt: now,
              deviceId: deviceId,
            ),
          );
      final journalId = await Ledger.postJournal(
        db,
        date: date,
        memo: note,
        refType: 'petty-isi',
        refId: pettyId,
        lines: [
          JournalLineInput(accountCode: '1030', debit: amount, credit: 0),
          JournalLineInput(accountCode: '1000', debit: 0, credit: amount),
        ],
      );
      await Outbox.write(
        db,
        table: 'petty_cash',
        rowId: pettyId,
        operation: 'insert',
        payload: {'id': pettyId, 'amount': amount, 'note': note},
      );
      await Outbox.writeJournal(db, journalId);
      return pettyId;
    });
  }

  /// Tutup shift — selisih kas: kurang D 5220 / K 1000; lebih D 1000 / K 5220.
  /// [cashDiff] bertanda: negatif = kurang, positif = lebih.
  static Future<String?> recordCashDifference(
    AppDatabase db, {
    required DateTime date,
    required int cashDiff,
    String memo = 'Selisih kas tutup shift',
  }) async {
    if (cashDiff == 0) return null;
    final amount = cashDiff.abs();
    final kurang = cashDiff < 0;
    return Ledger.postJournalStandalone(
      db,
      date: date,
      memo: memo,
      refType: 'selisih-kas',
      refId: newId(),
      lines: kurang
          ? [
              JournalLineInput(accountCode: '5220', debit: amount, credit: 0),
              JournalLineInput(accountCode: '1000', debit: 0, credit: amount),
            ]
          : [
              JournalLineInput(accountCode: '1000', debit: amount, credit: 0),
              JournalLineInput(accountCode: '5220', debit: 0, credit: amount),
            ],
    );
  }
}
