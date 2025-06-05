import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/features/auth/domain/repository/auth_repository.dart';

class AuthStateNotifier extends ChangeNotifier {
  final AuthRepository authRepository;
  bool _initialCheckDone = false;
  bool _isAuthenticated = false;

  AuthStateNotifier(this.authRepository) : super();

  bool get isAuthenticated => _isAuthenticated;

  /// Validates if the user's session is active on start
  /// Used in GoRoute redirect function to redirect the user to auth if needed
  Future<void> validateSessionOnce() async {
    if (_initialCheckDone) return;

    // Verify if the session is still active
    final result = await authRepository.validateSession();
    _isAuthenticated = result.isRight();
    _initialCheckDone = true;

    notifyListeners(); // Triggers GoRouter to re-evaluate redirect
  }
}
