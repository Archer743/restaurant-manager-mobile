import 'package:flutter/cupertino.dart';
import 'package:restaurant_manager_app/core/presentation/widgets/dialogs/confirmation_dialog.dart';

void showCloseConfirmationDialog({
  required BuildContext context,
  required VoidCallback onClose,
}) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return ConfirmationDialog(
        title: 'Приключване на резервация',
        content:
            'След приключване на резервацията, масите ще бъдат освободени. Сигурни ли сте, че искате да продължите?',
        confirmButtonText: 'Приключи',
        onConfirm: onClose,
      );
    },
  );
}
