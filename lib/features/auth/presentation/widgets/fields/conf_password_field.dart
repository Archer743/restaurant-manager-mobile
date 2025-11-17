import 'package:flutter/material.dart';

class ConfPasswordField extends StatefulWidget {
  final TextEditingController mainController;
  final TextEditingController passwordController;

  const ConfPasswordField({
    super.key,
    required this.mainController,
    required this.passwordController,
  });

  @override
  State<ConfPasswordField> createState() => _ConfPasswordFieldState();
}

class _ConfPasswordFieldState extends State<ConfPasswordField> {
  bool _isPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() => _isPasswordVisible = !_isPasswordVisible);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.mainController,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Потвърдете парола',
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
          return 'Потвръдете парола';
        } else if (value != widget.passwordController.text) {
          return 'Паролите не съвпадат';
        }

        return null;
      },
    );
  }
}
