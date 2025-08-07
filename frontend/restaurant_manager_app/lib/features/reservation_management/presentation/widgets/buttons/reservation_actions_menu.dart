import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/config/theme/theme.dart';

enum _ReservationAction { edit, remove }

class ReservationActionsMenu extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const ReservationActionsMenu({
    super.key,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_ReservationAction>(
      icon: const Icon(Icons.settings),
      onSelected: (value) {
        switch (value) {
          case _ReservationAction.edit:
            onEdit();
            break;
          case _ReservationAction.remove:
            onRemove();
            break;
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: _ReservationAction.edit,
          child: Row(
            children: [
              Icon(Icons.edit, color: actionColor),
              SizedBox(width: 8),
              Text('Редактирай'),
            ],
          ),
        ),
        PopupMenuItem(
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
