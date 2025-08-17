import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/config/theme/theme.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/dialogs/remove_confirmation_dialog.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/dialogs/close_confirmation_dialog.dart';

enum _ReservationAction { close, edit, remove }

class ReservationActionsMenu extends StatelessWidget {
  final bool isReservationClosed;
  final VoidCallback onClose;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const ReservationActionsMenu({
    super.key,
    required this.isReservationClosed,
    required this.onClose,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_ReservationAction>(
      icon: const Icon(Icons.settings),
      onSelected: (value) {
        switch (value) {
          case _ReservationAction.close:
            showCloseConfirmationDialog(context: context, onClose: onClose);
            break;
          case _ReservationAction.edit:
            onEdit();
            break;
          case _ReservationAction.remove:
            showRemoveConfirmationDialog(context: context, onRemove: onRemove);
            break;
        }
      },
      itemBuilder: (context) => [
        if (!isReservationClosed)
          const PopupMenuItem(
            value: _ReservationAction.close,
            child: Row(
              children: [
                Icon(Icons.done, color: successColor),
                SizedBox(width: 8),
                Text('Приключи'),
              ],
            ),
          ),
        const PopupMenuItem(
          value: _ReservationAction.edit,
          child: Row(
            children: [
              Icon(Icons.edit, color: actionColor),
              SizedBox(width: 8),
              Text('Редактирай'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: _ReservationAction.remove,
          child: Row(
            children: [
              Icon(Icons.delete, color: warningColor),
              SizedBox(width: 8),
              Text('Изтрий'),
            ],
          ),
        ),
      ],
    );
  }
}
