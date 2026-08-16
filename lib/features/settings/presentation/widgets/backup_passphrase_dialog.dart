import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class BackupPassphraseDialog extends StatefulWidget {
  const BackupPassphraseDialog({super.key});

  @override
  State<BackupPassphraseDialog> createState() => _BackupPassphraseDialogState();
}

class _BackupPassphraseDialogState extends State<BackupPassphraseDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.warmIvory,
      title: const Text('Backup Passphrase', style: TextStyle(color: AppColors.deepInk, fontWeight: FontWeight.bold)),
      content: TextField(
        controller: _controller,
        obscureText: true,
        decoration: const InputDecoration(
          hintText: 'Enter a strong passphrase',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: AppColors.deepInk)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.brandAction, foregroundColor: Colors.white),
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              Navigator.pop(context, _controller.text);
            }
          },
          child: const Text('Export'),
        ),
      ],
    );
  }
}
