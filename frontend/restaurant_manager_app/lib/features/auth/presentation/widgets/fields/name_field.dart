import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/features/auth/presentation/constants/input_constraints.dart';

class NameField extends StatelessWidget {
  final TextEditingController controller;
  final NameType nameType;

  const NameField({
    super.key,
    required this.controller,
    required this.nameType,
  });

  @override
  Widget build(BuildContext context) {
    final labelText = nameType == NameType.firstName ? 'Име' : 'Фамилия';

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person),
        label: Text(labelText),
        hintText: 'Въведете ${labelText.toLowerCase()}',
      ),
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return 'Въведете ${labelText.toLowerCase()}';
        } else if (value.length > maxNameLength) {
          return nameType == NameType.firstName
              ? 'Името e твърде дълго'
              : 'Фамилията е твърде дълга';
        }

        return null;
      },
    );
  }
}

enum NameType {
  firstName,
  lastName,
}
