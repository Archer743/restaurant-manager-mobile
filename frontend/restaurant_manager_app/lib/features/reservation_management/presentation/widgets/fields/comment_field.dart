import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/fields/base_form_field.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/constants/input_constraints.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_form_mode.dart';

class CommentField extends BaseFormField {
  const CommentField({
    super.key,
    required super.controller,
    required super.displayMode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      minLines: 1,
      maxLines: null,
      readOnly: !isEditable,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.comment),
        suffixIcon: displayMode == ReservationFormMode.edit
            ? const Icon(Icons.edit)
            : null,
        labelText: 'Коментар',
        hintText: isEditable ? 'Въведете коментар' : 'Няма коментар',
      ),
      validator: (String? value) {
        if (value != null && value.length > maxCommentLength) {
          return 'Коментарът e твърде дълъг';
        }

        return null;
      },
    );
  }
}
