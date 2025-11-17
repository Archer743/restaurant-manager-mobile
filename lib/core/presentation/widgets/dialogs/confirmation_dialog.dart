import 'package:flutter/cupertino.dart';
import 'package:restaurant_manager_app/config/theme/theme.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmButtonText;
  final VoidCallback onConfirm;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    required this.confirmButtonText,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: darkCupertinoDialogTheme,
      child: CupertinoAlertDialog(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        content: Text(
          content,
          style: const TextStyle(fontSize: 14),
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            child: const Text('Отказ'),
            onPressed: () {
              if (!context.mounted) return;
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              if (!context.mounted) return;
              Navigator.of(context).pop();
              onConfirm();
            },
            child: Text(confirmButtonText),
          ),
        ],
      ),
    );
  }
}
