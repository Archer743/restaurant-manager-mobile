import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/core/utils/spacing.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/fields/comment_field.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/fields/date_field.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/fields/email_field.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/fields/people_count_field.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/fields/phone_number_field.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/fields/reservation_name_field.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/fields/time_field.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_form_mode.dart';

class ReservationForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final ReservationFormMode displayMode;
  final bool isCreatedByStaff;

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController dateController;
  final TextEditingController timeController;
  final TextEditingController peopleCountController;
  final TextEditingController commentController;

  const ReservationForm({
    super.key,
    required this.formKey,
    required this.displayMode,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.dateController,
    required this.timeController,
    required this.peopleCountController,
    required this.commentController,
    this.isCreatedByStaff = true,
  });

  ReservationFormMode get _getContactInfoDisplayMode {
    if (displayMode == ReservationFormMode.edit && !isCreatedByStaff) {
      // Force view mode for client-created contact info in edit mode
      return ReservationFormMode.view;
    }

    return displayMode;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          SizedBox(height: spacingByHeight(context, 0.04)),
          ReservationNameField(
              controller: nameController,
              displayMode: _getContactInfoDisplayMode),
          SizedBox(height: spacingByHeight(context, 0.035)),
          EmailField(
              controller: emailController,
              displayMode: _getContactInfoDisplayMode),
          SizedBox(height: spacingByHeight(context, 0.035)),
          PhoneNumberField(
              controller: phoneController,
              displayMode: _getContactInfoDisplayMode),
          SizedBox(height: spacingByHeight(context, 0.035)),
          DateField(rawController: dateController, displayMode: displayMode),
          SizedBox(height: spacingByHeight(context, 0.035)),
          TimeField(rawController: timeController, displayMode: displayMode),
          SizedBox(height: spacingByHeight(context, 0.035)),
          PeopleCountField(
              controller: peopleCountController, displayMode: displayMode),
          SizedBox(height: spacingByHeight(context, 0.035)),
          CommentField(controller: commentController, displayMode: displayMode),
          SizedBox(height: spacingByHeight(context, 0.04)),
        ],
      ),
    );
  }
}
