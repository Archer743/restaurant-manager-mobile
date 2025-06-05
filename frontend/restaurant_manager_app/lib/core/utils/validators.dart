import 'package:restaurant_manager_app/features/auth/presentation/constants/input_constraints.dart';

class Validators {
  static final _passwordRegex = RegExp(validPasswordRegex);

  static bool isValidPassword(String password) {
    return _passwordRegex.hasMatch(password);
  }
}
