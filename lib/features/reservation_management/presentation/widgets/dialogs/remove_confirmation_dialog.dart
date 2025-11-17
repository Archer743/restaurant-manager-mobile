import 'package:flutter/cupertino.dart';
import 'package:restaurant_manager_app/core/presentation/widgets/dialogs/confirmation_dialog.dart';

void showRemoveConfirmationDialog({
  required BuildContext context,
  required VoidCallback onRemove,
}) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return ConfirmationDialog(
        title: 'Изтриване на резервация',
        content: 'Сигурни ли сте, че искате да изтриете тази резервация?',
        confirmButtonText: 'Изтриване',
        onConfirm: onRemove,
      );
    },
  );
}
