// Casirz ERP — Rework premium netral (15 Nov 2026).
// Foto menu produk seed — digenerate khusus untuk Casirz (bukan dari
// web lain), 1600x1600 webp, cahaya hangat warkop, tanpa teks/harga.
// Dipetakan dengan NAMA PRODUK PERSIS seperti di lib/core/seed.dart —
// jangan dipetakan asal-asalan (foto produk yang salah lebih buruk
// daripada tanpa foto). Produk buatan user yang tidak ada di map
// memakai placeholder elegan (lihat _PhotoPlaceholder di pos_page.dart),
// BUKAN gambar rusak.
const Map<String, String> productPhotos = {
  'Kopi Susu Gula Aren': 'assets/menu/kopi-susu-gula-aren.webp',
  'Es Kopi Hitam': 'assets/menu/es-kopi-hitam.webp',
  'Es Teh Tubruk': 'assets/menu/es-teh-tubruk.webp',
  'Susu Cokelat Meses': 'assets/menu/susu-coklat-meses.webp',
  'Roti Bakar Meses': 'assets/menu/roti-bakar-meses.webp',
  'Indomie Goreng Telur': 'assets/menu/indomie-goreng-telur.webp',
  'Indomie Goreng Spesial': 'assets/menu/indomie-goreng-spesial.webp',
  'Es Kopi Susu SKM': 'assets/menu/es-kopi-susu-skm.webp',
  'Teh Susu Gula Aren': 'assets/menu/teh-susu-gula-aren.webp',
  'Air Mineral': 'assets/menu/air-mineral.webp',
};

/// Path aset foto untuk [productName] (nama persis seed), atau null
/// bila produk itu tidak punya foto.
String? productPhotoPath(String productName) => productPhotos[productName];
