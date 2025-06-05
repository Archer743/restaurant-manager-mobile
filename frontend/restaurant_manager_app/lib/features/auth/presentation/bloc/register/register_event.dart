import 'package:restaurant_manager_app/features/auth/domain/entities/user_register.dart';

abstract class RegisterEvent {}

class RegisterSubmitted extends RegisterEvent {
  final String username;
  final String firstName;
  final String lastName;
  final String password;

  RegisterSubmitted({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.password,
  });

  UserRegister getEntity() {
    return UserRegister(
      username: username,
      firstName: firstName,
      lastName: lastName,
      password: password,
    );
  }
}
