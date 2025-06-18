import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/constants/input_constraints.dart';

class CommentField extends StatelessWidget {
  final TextEditingController controller;
  final bool isEditable;

  const CommentField({
    super.key,
    required this.controller,
    required this.isEditable,
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
        suffixIcon: isEditable ? const Icon(Icons.edit) : null,
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
