import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/fields/base_form_field.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/constants/input_constraints.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_form_mode.dart';

class PeopleCountField extends BaseFormField {
  const PeopleCountField({
    super.key,
    required super.controller,
    required super.displayMode,
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
        suffixIcon: displayMode == ReservationFormMode.edit
            ? const Icon(Icons.edit)
            : null,
        labelText: 'Брой гости',
        hintText: 'Въведете броя на гостите',
      ),
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return 'Въведете броя на гостите';
        }

        int? count = int.tryParse(value);

        if (count == null) {
          return 'Въведете валиден брой гости';
        } else if (count < minPeopleCount) {
          return 'Минималният брой гости е $minPeopleCount';
        } else if (count > maxPeopleCount) {
          return 'Максималният брой гости е $maxPeopleCount';
        }

        return null;
      },
    );
  }
}
