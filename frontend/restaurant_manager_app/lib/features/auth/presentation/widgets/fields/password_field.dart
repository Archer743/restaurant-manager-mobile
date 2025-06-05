import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/core/utils/validators.dart';
import 'package:restaurant_manager_app/features/auth/presentation/constants/input_constraints.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final bool validatePassword;

  const PasswordField({
    super.key,
    required this.controller,
    this.validatePassword = false,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() => _isPasswordVisible = !_isPasswordVisible);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Парола',
        hintText: 'Въведете парола',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: _togglePasswordVisibility,
        ),
      ),
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return 'Въведете парола';
        }

        if (!widget.validatePassword) {
          return null;
        } else if (value.length < minPasswordLength) {
          return 'Паролата е твърде кратка';
        } else if (value.length > maxPasswordLength) {
          return 'Паролата e твърде дълга';
        } else if (!Validators.isValidPassword(value)) {
          return 'Паролата трябва да съдържа малка и главна буква, цифра и специален символ';
        }

        return null;
      },
    );
  }
}
