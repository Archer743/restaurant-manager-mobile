import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/fields/base_form_field.dart';
import 'package:restaurant_manager_app/core/utils/validators.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_form_mode.dart';

class EmailField extends BaseFormField {
  const EmailField({
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
        prefixIcon: const Icon(Icons.email),
        suffixIcon: displayMode == ReservationFormMode.edit
            ? const Icon(Icons.edit)
            : null,
        labelText: 'Имейл',
        hintText: 'Въведете имейл',
      ),
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return 'Въведете имейл';
        } else if (!Validators.isValidEmail(value)) {
          return 'Въведете валиден имейл адрес';
        }

        return null;
      },
    );
  }
}
