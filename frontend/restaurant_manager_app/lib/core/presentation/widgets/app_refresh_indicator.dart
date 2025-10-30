import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/config/theme/theme.dart';

class AppRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const AppRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: actionColor, // Spinner color
      backgroundColor: actionColor.withOpacity(0.3),
      strokeWidth: 3.0,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
