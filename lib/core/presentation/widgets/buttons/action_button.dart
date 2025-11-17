import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/config/theme/theme.dart';

class ActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String label;

  const ActionButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: accentColor,
                backgroundColor: accentColor.withOpacity(0.45),
                strokeWidth: 3,
              ),
            )
          : Text(label),
    );
  }
}
