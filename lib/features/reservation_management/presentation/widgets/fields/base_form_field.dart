import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_form_mode.dart';

abstract class BaseFormField extends StatelessWidget {
  final TextEditingController controller;
  final ReservationFormMode displayMode;

  const BaseFormField({
    super.key,
    required this.controller,
    required this.displayMode,
  });

  bool get isEditable {
    return displayMode == ReservationFormMode.create ||
        displayMode == ReservationFormMode.edit;
  }
}
