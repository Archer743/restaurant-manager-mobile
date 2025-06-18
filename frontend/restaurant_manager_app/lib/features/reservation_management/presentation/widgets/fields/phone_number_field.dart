import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/core/presentation/widgets/fields/readonly_field.dart';

class PhoneNumberField extends StatelessWidget {
  final String phone;

  const PhoneNumberField({super.key, required this.phone});

  @override
  Widget build(BuildContext context) {
    return ReadOnlyField(
      label: 'Телефон',
      icon: Icons.phone,
      value: phone,
    );
  }
}
