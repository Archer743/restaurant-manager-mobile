import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/config/theme/theme.dart';
import 'package:restaurant_manager_app/features/user_profile/presentation/widgets/dialogs/logout_confirmation_dialog.dart';

enum _ProfileAction { logout }

class ProfileActionsMenu extends StatelessWidget {
  final VoidCallback onLogout;

  const ProfileActionsMenu({
    super.key,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_ProfileAction>(
      icon: const Icon(Icons.settings),
      onSelected: (value) {
        switch (value) {
          case _ProfileAction.logout:
            showLogoutConfirmationDialog(context: context, onLogout: onLogout);
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: _ProfileAction.logout,
          child: Row(
            children: [
              Icon(Icons.logout_outlined, color: warningColor),
              SizedBox(width: 8),
              Text('Изход'),
            ],
          ),
        ),
      ],
    );
  }
}
