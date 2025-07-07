import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/config/theme/theme.dart';
import 'package:restaurant_manager_app/core/presentation/services/snackbar_service.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/fields/base_form_field.dart';
import 'package:restaurant_manager_app/core/utils/validators.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_form_mode.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneNumberField extends BaseFormField {
  const PhoneNumberField({
    super.key,
    required super.controller,
    required super.displayMode,
  });

  // https://pub.dev/packages/url_launcher#configuration
  Future<void> _makePhoneCall(BuildContext context, String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else if (context.mounted) {
      SnackBarService.showFailureMessage(
          context, 'Не може да се осъществи обаждане.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: !isEditable,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.phone),
        suffixIcon: _buildSuffixIcon(context),
        labelText: 'Телефон',
        hintText: 'Въведете телефон',
      ),
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return 'Въведете телефон';
        } else if (!Validators.isValidPhone(value)) {
          return 'Въведете валиден телефонен номер';
        }

        return null;
      },
    );
  }

  Widget? _buildSuffixIcon(BuildContext context) {
    if (displayMode == ReservationFormMode.edit) {
      return const Icon(Icons.edit);
    } else if (!isEditable && controller.text.isNotEmpty) {
      return GestureDetector(
        child: const Icon(Icons.phone_in_talk, color: accentColor),
        onTap: () => _makePhoneCall(context, controller.text),
      );
    }

    return null;
  }
}
