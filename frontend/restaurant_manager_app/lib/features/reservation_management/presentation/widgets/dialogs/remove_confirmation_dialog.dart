import 'package:flutter/cupertino.dart';
import 'package:restaurant_manager_app/config/theme/theme.dart';

void showRemoveConfirmationDialog({
  required BuildContext context,
  required VoidCallback onRemove,
}) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoTheme(
        data: darkCupertinoDialogTheme,
        child: CupertinoAlertDialog(
          title: const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              'Потвърдете изтриването',
              style: TextStyle(fontSize: 18),
            ),
          ),
          content: const Text(
            'Сигурни ли сте, че искате да изтриете тази резервация?',
            style: TextStyle(fontSize: 14),
          ),
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
        ),
      );
    },
  );
}
