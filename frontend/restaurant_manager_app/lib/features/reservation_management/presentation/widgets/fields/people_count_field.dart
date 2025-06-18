import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/constants/input_constraints.dart';

class PeopleCountField extends StatelessWidget {
  final TextEditingController controller;
  final bool isEditable;

  const PeopleCountField({
    super.key,
    required this.controller,
    required this.isEditable,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      readOnly: !isEditable,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.group),
        suffixIcon: isEditable ? const Icon(Icons.edit) : null,
        labelText: 'Брой гости',
        hintText: 'Въведете броя гости',
      ),
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return 'Въведете броя гости';
        }

        int count = int.parse(value);

        if (count < minPeopleCount) {
          return 'Минималният брой гости е $minPeopleCount';
        } else if (count > maxPeopleCount) {
          return 'Максималният брой гости е $maxPeopleCount';
        }

        return null;
      },
    );
  }
}
