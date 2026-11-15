// Casirz ERP — Fase 2 (Modul A Kasir+).
// Logika keranjang + hitung total — KODE MURNI (tanpa Flutter, tanpa DB).
// Semua aturan uang di sini, supaya bisa diuji unit test tanpa database:
// - Uang integer Rupiah; diskon TIDAK BOLEH membuat total 0/negatif
//   (engine menolak penjualan total Rp0 — Adendum blueprint no. 5).
// - PPN 11% toggle manual; service charge + PB1 editable (persen).
// - Promo persen / potongan; komisi ojol configurable (default 0).
// - Poin pelanggan: 1 poin per Rp10.000 (floor(total/10000)).
// - Split bill: total split HARUS = total asli (sisa bagi ke depan).
// - Modifier menambah harga satuan; harga efektif = harga dasar +
//   modifier, lalu markup ojol (bila ada) di atasnya.
import '../../core/money.dart';

/// Satu pilihan modifier/varian. [priceDelta] Rp (0 = gratis).
class CartModifier {
  const CartModifier({required this.name, this.priceDelta = 0});
  final String name;
  final int priceDelta;
}

/// Katalog modifier/varian kasir (harga TETAP, bukan karangan acak):
/// - Level Gula & Es: gratis (pilihan rasa, bukan harga).
/// - Extra Topping: +Rp3.000 (contoh di brief Fase 2).
class Modifiers {
  static const List<CartModifier> levelGula = [
    CartModifier(name: 'Gula Normal'),
    CartModifier(name: 'Kurang Manis'),
    CartModifier(name: 'Tanpa Gula'),
  ];
  static const List<CartModifier> es = [
    CartModifier(name: 'Es Normal'),
    CartModifier(name: 'Es Sedikit'),
    CartModifier(name: 'Tanpa Es'),
  ];
  static const List<CartModifier> extra = [
    CartModifier(name: 'Extra Topping', priceDelta: 3000),
    CartModifier(name: 'Extra Susu', priceDelta: 3000),
  ];

  /// Modifier yang ditawarkan untuk satu kategori produk.
  static List<List<CartModifier>> forCategory(String category) {
    if (category.toLowerCase() == 'minuman') {
      return [levelGula, es, extra];
    }
    return [extra];
  }
}

/// Satu baris keranjang.
class CartLine {
  CartLine({
    required this.productId,
    required this.name,
    required this.basePrice,
    this.qty = 1,
    this.modifiers = const [],
    this.note = '',
    this.hppPerUnit = 0,
  });
  final String productId;
  final String name;
  final int basePrice; // harga dasar produk, Rp
  int qty;
  List<CartModifier> modifiers;
  String note;
  final int hppPerUnit; // estimasi HPP per unit (tampil saja)

  /// Harga satuan efektif (dasar + modifier), SEBELUM markup ojol.
  int get unitPrice =>
      basePrice + modifiers.fold<int>(0, (s, m) => s + m.priceDelta);

  int get lineTotal => unitPrice * qty;

  /// Label modifier untuk struk, mis. "Kurang Manis, Extra Topping".
  String get modifierLabel => modifiers.map((m) => m.name).join(', ');

  CartLine copy() => CartLine(
        productId: productId,
        name: name,
        basePrice: basePrice,
        qty: qty,
        modifiers: List.of(modifiers),
        note: note,
        hppPerUnit: hppPerUnit,
      );
}

/// Hasil hitung total keranjang.
class CartTotals {
  const CartTotals({
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.serviceCharge,
    required this.ojolFee,
    required this.total,
    required this.totalHpp,
    required this.pointsEarned,
  });
  final int subtotal; // setelah markup ojol, sebelum diskon
  final int discount;
  final int tax; // PPN
  final int serviceCharge; // service + PB1 digabung (engine 1 kolom)
  final int ojolFee; // komisi ojol (Rp)
  final int total; // yang harus dibayar pelanggan
  final int totalHpp; // estimasi HPP (tampil saja, bukan angka final)
  final int pointsEarned; // floor(total/10000)
}

/// Hitung total keranjang. [markupPercent] = markup harga ojol (%).
/// [ojolFeePercent] = komisi ojol (%) dari (subtotal - diskon).
CartTotals computeTotals({
  required List<CartLine> lines,
  int discountRp = 0,
  int promoPercent = 0, // 0 = tidak ada promo persen
  int promoFixedRp = 0, // 0 = tidak ada promo potongan
  bool ppnEnabled = false,
  int ppnRate = 11,
  int serviceRate = 0, // persen
  int pb1Rate = 0, // persen
  int markupPercent = 0, // persen (ojol)
  int ojolFeePercent = 0, // persen (ojol)
}) {
  var subtotal = 0;
  var totalHpp = 0;
  for (final line in lines) {
    final unit = markupPercent > 0
        ? toIntRp(line.unitPrice * (100 + markupPercent) / 100)
        : line.unitPrice;
    subtotal += unit * line.qty;
    totalHpp += line.hppPerUnit * line.qty;
  }

  // Diskon: manual + promo (persen dihitung dari subtotal).
  var discount = discountRp;
  if (promoPercent > 0) {
    discount += toIntRp(subtotal * promoPercent / 100);
  }
  discount += promoFixedRp;
  if (discount < 0) discount = 0;
  // ATURAN BEKU (Adendum no. 5): diskon TIDAK BOLEH membuat total 0.
  // Clamp supaya subtotal - diskon minimal Rp1 (pajak/service >= 0
  // sehingga total selalu >= 1).
  if (subtotal > 0 && discount >= subtotal) {
    discount = subtotal - 1;
  }
  if (subtotal == 0) discount = 0;

  final afterDiscount = subtotal - discount;
  final tax = ppnEnabled ? toIntRp(afterDiscount * ppnRate / 100) : 0;
  final serviceCharge = toIntRp(
    afterDiscount * (serviceRate + pb1Rate) / 100,
  );
  final ojolFee = ojolFeePercent > 0
      ? toIntRp(afterDiscount * ojolFeePercent / 100)
      : 0;
  final total = afterDiscount + tax + serviceCharge;
  final points = total > 0 ? total ~/ 10000 : 0;
  return CartTotals(
    subtotal: subtotal,
    discount: discount,
    tax: tax,
    serviceCharge: serviceCharge,
    ojolFee: ojolFee,
    total: total,
    totalHpp: totalHpp,
    pointsEarned: points,
  );
}

/// Poin pelanggan: 1 poin per Rp10.000 belanja (floor).
int pointsForTotal(int total) => total > 0 ? total ~/ 10000 : 0;

/// Kembalian tunai. [paid] = uang diterima, [total] = tagihan.
/// Mengembalikan (kembalian, sisaKurang): bila paid >= total, sisa 0.
({int change, int remaining}) calcChange({
  required int paid,
  required int total,
}) {
  if (paid >= total) return (change: paid - total, remaining: 0);
  return (change: 0, remaining: total - paid);
}

/// Split rata: bagi [total] ke [parts] orang. Sisa pembagian jatuh ke
/// orang pertama, supaya jumlah split SELALU = total asli.
List<int> splitEvenly(int total, int parts) {
  if (parts <= 0) throw ArgumentError('Jumlah orang harus > 0.');
  if (total < 0) throw ArgumentError('Total tidak boleh negatif.');
  final base = total ~/ parts;
  final remainder = total % parts;
  return List<int>.generate(
    parts,
    (i) => base + (i < remainder ? 1 : 0),
  );
}

/// Split per item: bagi baris keranjang ke dua kelompok.
/// Mengembalikan subtotal tiap kelompok (harga satuan efektif).
({int groupA, int groupB}) splitByItems(
  List<CartLine> groupA,
  List<CartLine> groupB,
) {
  int sum(List<CartLine> ls) =>
      ls.fold<int>(0, (s, l) => s + l.lineTotal);
  return (groupA: sum(groupA), groupB: sum(groupB));
}

/// Denominasi cepat tunai di checkout.
const List<int> cashDenominations = [10000, 20000, 50000, 100000];

/// Label metode bayar untuk tampil. Engine (SaleService.paymentMethods)
/// kenal 'tunai' | 'qris' | 'ojol' | 'transfer' | 'debit' (Fase 3,
/// Adendum pasca-Fase 2 butir 3): transfer/debit -> akun 1010 Bank,
/// QRIS & E-Wallet -> akun 1020 QRIS/E-Wallet, ojol netto -> 1020.
String engineMethodFor(String displayMethod) {
  switch (displayMethod) {
    case 'Tunai':
      return 'tunai';
    case 'QRIS':
      return 'qris';
    case 'Debit':
      return 'debit';
    case 'Transfer':
      return 'transfer';
    case 'E-Wallet':
      return 'qris';
    case 'Ojol':
      return 'ojol';
    default:
      throw ArgumentError('Metode bayar tidak dikenal: $displayMethod');
  }
}

const List<String> displayPaymentMethods = [
  'Tunai',
  'QRIS',
  'Debit',
  'Transfer',
  'E-Wallet',
];
