import 'package:restaurant_manager_app/features/auth/domain/entities/user_login.dart';

abstract class LoginEvent {}

class LoginSubmitted extends LoginEvent {
  final String username;
  final String password;

  LoginSubmitted({required this.username, required this.password});

  UserLogin getEntity() {
    return UserLogin(username: username, password: password);
  }
}
