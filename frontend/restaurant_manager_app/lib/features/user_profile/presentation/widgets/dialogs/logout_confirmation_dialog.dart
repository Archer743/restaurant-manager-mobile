import 'package:flutter/cupertino.dart';
import 'package:restaurant_manager_app/core/presentation/widgets/dialogs/confirmation_dialog.dart';

void showLogoutConfirmationDialog({
  required BuildContext context,
  required VoidCallback onLogout,
}) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return ConfirmationDialog(
        title: 'Изход от системата',
        content:
            'Сигурни ли сте, че искате да прекратите сесията си и да излезете?',
        confirmButtonText: 'Изход',
        onConfirm: onLogout,
      );
    },
  );
}
