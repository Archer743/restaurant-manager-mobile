import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/core/presentation/widgets/fields/readonly_field.dart';

class EmailField extends StatelessWidget {
  final String email;

  const EmailField({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return ReadOnlyField(
      label: 'Имейл',
      icon: Icons.email,
      value: email,
    );
  }
}
