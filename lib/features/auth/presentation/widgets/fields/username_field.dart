import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/features/auth/presentation/constants/input_constraints.dart';

class UsernameField extends StatelessWidget {
  final TextEditingController controller;

  const UsernameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.person),
        label: Text('Потребителско име'),
        hintText: 'Въведете потребителско име',
      ),
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return 'Въведете потребителско име';
        } else if (value.length < minUsernameLength) {
          return 'Потребителското име е твърде кратко';
        } else if (value.length > maxUsernameLength) {
          return 'Потребителското име e твърде дълго';
        }

        return null;
      },
    );
  }
}
