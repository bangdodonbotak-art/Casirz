// Casirz ERP — Fase 4 (Modul C Akuntansi).
// Hub Akuntansi: menu Modal Awal, Aset Tetap, Beban OPEX,
// Jurnal & Buku Besar, Laporan Keuangan.
import 'package:flutter/material.dart';

import 'assets_page.dart';
import 'capital_page.dart';
import 'expenses_page.dart';
import 'journal_page.dart';
import 'reports_page.dart';

class AccountingPage extends StatelessWidget {
  const AccountingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Akuntansi')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Semua angka di sini dihitung dari jurnal (REA ledger). '
                'Jurnal bersifat append-only — koreksi hanya lewat jurnal '
                'pembalik, bukan dengan mengedit jurnal lama.',
              ),
            ),
          ),
          const SizedBox(height: 8),
          _MenuTile(
            icon: Icons.account_balance_wallet,
            title: 'Modal Awal & Saldo Awal',
            subtitle: 'Kas, bank, sewa muka + amortisasi bulanan',
            page: const CapitalPage(),
          ),
          _MenuTile(
            icon: Icons.precision_manufacturing,
            title: 'Aset Tetap',
            subtitle: 'Daftar aset, nilai buku, penyusutan bulanan',
            page: const AssetsPage(),
          ),
          _MenuTile(
            icon: Icons.receipt_long,
            title: 'Beban OPEX',
            subtitle: 'Listrik, air, internet, gaji, sewa, dan lain-lain',
            page: const ExpensesPage(),
          ),
          _MenuTile(
            icon: Icons.book,
            title: 'Jurnal & Buku Besar',
            subtitle: 'Daftar jurnal, detail D/K, saldo per akun',
            page: const JournalPage(),
          ),
          _MenuTile(
            icon: Icons.assessment,
            title: 'Laporan Keuangan',
            subtitle: 'Laba Rugi, Neraca, Arus Kas + export CSV / print',
            page: const ReportsPage(),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.page,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget page;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        minVerticalPadding: 12,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => page),
        ),
      ),
    );
  }
}
