// Casirz ERP — Fase 2. Widget bantu: empty state + dialog konfirmasi.
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.message, this.action});
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (action != null) ...[
              const SizedBox(height: 16),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

/// Dialog konfirmasi generik. Mengembalikan true bila pengguna menekan
/// tombol aksi (bukan "Batal").
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String actionLabel = 'Ya, lanjutkan',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(actionLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// Input angka Rupiah: hanya digit, diformat dengan pemisah ribuan.
/// Mengembalikan int (0 bila kosong).
class RpInput extends StatefulWidget {
  const RpInput({
    super.key,
    required this.controller,
    this.label,
    this.onChanged,
  });
  final TextEditingController controller;
  final String? label;
  final void Function(int value)? onChanged;

  @override
  State<RpInput> createState() => _RpInputState();
}

class _RpInputState extends State<RpInput> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: widget.label,
        prefixText: 'Rp ',
        border: const OutlineInputBorder(),
      ),
      onChanged: (v) {
        final digits = v.replaceAll(RegExp(r'[^0-9]'), '');
        widget.onChanged?.call(int.tryParse(digits) ?? 0);
      },
    );
  }
}
