import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/config/theme/theme.dart';
import 'package:restaurant_manager_app/core/errors/error_mapper.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/core/utils/spacing.dart';

class SnackBarService {
  static void showSuccess(BuildContext context, String message) {
    _showSnackbar(context, Icons.check, message, successColor);
  }

  static void showFailure(BuildContext context, Failure failure) {
    final message = getFailureMessage(failure);
    _showSnackbar(context, Icons.close, message, warningColor);
  }

  static void _showSnackbar(
      BuildContext context, IconData icon, String message, Color color) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon),
          SizedBox(width: spacingByWidth(context, 0.04)),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(20),
    );

    ScaffoldMessenger.of(context).clearSnackBars(); // avoid stacking
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
