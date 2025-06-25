import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/fields/base_form_field.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/constants/input_constraints.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_form_mode.dart';

class ReservationNameField extends BaseFormField {
  const ReservationNameField({
    super.key,
    required super.controller,
    required super.displayMode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: !isEditable,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person),
        suffixIcon: displayMode == ReservationFormMode.edit
            ? const Icon(Icons.edit)
            : null,
        labelText: 'Име',
        hintText: 'Въведете име',
      ),
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return 'Въведете име';
        } else if (value.length > maxReservationNameLength) {
          return 'Името e твърде дълго';
        }

        return null;
      },
    );
  }
}
