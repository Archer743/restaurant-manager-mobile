import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/core/presentation/widgets/fields/readonly_field.dart';

class ReservationNameField extends StatelessWidget {
  final String name;

  const ReservationNameField({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return ReadOnlyField(
      label: 'Име',
      icon: Icons.person,
      value: name,
    );
  }
}
