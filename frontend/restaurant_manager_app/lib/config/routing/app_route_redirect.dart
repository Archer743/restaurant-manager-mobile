import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_manager_app/config/routing/auth_state_notifier.dart';
import 'package:restaurant_manager_app/injection_container.dart';

FutureOr<String?> appRouteRedirect(
    BuildContext context, GoRouterState state) async {
  final authNotifier = sl<AuthStateNotifier>();

  // If user is in auth route, let them go
  if (state.matchedLocation.startsWith('/auth')) return null;

  // Trigger initial session validation once if user is logged in
  await authNotifier.validateSessionOnce();

  // Only redirect if session is confirmed invalid
  if (!authNotifier.isAuthenticated) return '/auth';

  return null;
}
