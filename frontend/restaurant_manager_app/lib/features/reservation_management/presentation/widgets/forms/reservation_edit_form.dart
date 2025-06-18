import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/core/data/converters/app_dateonly_converter.dart';
import 'package:restaurant_manager_app/core/utils/spacing.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_view.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/fields/comment_field.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/fields/date_field.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/fields/email_field.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/fields/people_count_field.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/fields/phone_number_field.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/fields/reservation_name_field.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/fields/time_field.dart';

class ReservationEditForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final ReservationView reservation;
  final bool editModeActivated;

  final TextEditingController dateController;
  final TextEditingController timeController;
  final TextEditingController peopleCountController;
  final TextEditingController commentController;

  const ReservationEditForm({
    super.key,
    required this.formKey,
    required this.reservation,
    required this.editModeActivated,
    required this.dateController,
    required this.timeController,
    required this.peopleCountController,
    required this.commentController,
  });

  @override
  State<ReservationEditForm> createState() => _ReservationEditFormState();
}

class _ReservationEditFormState extends State<ReservationEditForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          SizedBox(height: spacingByHeight(context, 0.04)),
          ReservationNameField(name: widget.reservation.name),
          SizedBox(height: spacingByHeight(context, 0.035)),
          PhoneNumberField(phone: widget.reservation.phone),
          SizedBox(height: spacingByHeight(context, 0.035)),
          EmailField(email: widget.reservation.email),
          SizedBox(height: spacingByHeight(context, 0.035)),
          DateField(
              rawController: widget.dateController,
              isEditable: widget.editModeActivated),
          SizedBox(height: spacingByHeight(context, 0.035)),
          TimeField(
              rawController: widget.timeController,
              isEditable: widget.editModeActivated),
          SizedBox(height: spacingByHeight(context, 0.035)),
          PeopleCountField(
              controller: widget.peopleCountController,
              isEditable: widget.editModeActivated),
          SizedBox(height: spacingByHeight(context, 0.035)),
          CommentField(
              controller: widget.commentController,
              isEditable: widget.editModeActivated),
          SizedBox(height: spacingByHeight(context, 0.04)),
        ],
      ),
    );
  }
}
