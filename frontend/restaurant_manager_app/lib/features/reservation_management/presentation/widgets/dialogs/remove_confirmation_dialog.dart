import 'package:flutter/cupertino.dart';

void showRemoveConfirmationDialog({
  required BuildContext context,
  required VoidCallback onRemove,
}) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: const Text('Потвърдете изтриването'),
        content: const Text(
            'Сигурни ли сте, че искате да изтриете тази резервация?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            child: const Text('Отказ'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Изтриване'),
            onPressed: () {
              Navigator.of(context).pop();
              onRemove();
            },
          ),
        ],
      );
    },
  );
}
