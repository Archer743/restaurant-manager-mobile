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
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/forms/controllers/reservation_form_controller.dart';

class ReservationForm extends StatelessWidget {
  final GlobalKey<FormState> _formKey;
  final ReservationFormController _formController;
  final ReservationFormMode _displayMode;
  final bool _isCreatedByStaff;

  const ReservationForm({
    super.key,
    required GlobalKey<FormState> formKey,
    required ReservationFormController formController,
    required ReservationFormMode displayMode,
    bool isCreatedByStaff = true,
  })  : _formKey = formKey,
        _formController = formController,
        _displayMode = displayMode,
        _isCreatedByStaff = isCreatedByStaff;

  ReservationFormMode get _getContactInfoDisplayMode {
    if (_displayMode == ReservationFormMode.edit && !_isCreatedByStaff) {
      // Force view mode for client-created contact info in edit mode
      return ReservationFormMode.view;
    }

    return _displayMode;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: spacingByHeight(context, 0.04)),
          _buildRequiredFields(context),
          SizedBox(height: spacingByHeight(context, 0.02)),
          _buildOptionalFields(context),
          SizedBox(height: spacingByHeight(context, 0.04)),
        ],
      ),
    );
  }

  Widget _buildRequiredFields(BuildContext context) {
    return Column(
      children: [
        ReservationNameField(
            controller: _formController.name,
            displayMode: _getContactInfoDisplayMode),
        SizedBox(height: spacingByHeight(context, 0.035)),
        DateField(
            rawController: _formController.date, displayMode: _displayMode),
        SizedBox(height: spacingByHeight(context, 0.035)),
        TimeField(
            rawController: _formController.time, displayMode: _displayMode),
        SizedBox(height: spacingByHeight(context, 0.035)),
        PeopleCountField(
            controller: _formController.peopleCount, displayMode: _displayMode),
      ],
    );
  }

  Widget _buildOptionalFields(BuildContext context) {
    final bool hasOptionalData = _formController.email.text.isNotEmpty ||
        _formController.phone.text.isNotEmpty ||
        _formController.comment.text.isNotEmpty;

    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ExpansionTile(
        initiallyExpanded:
            _displayMode == ReservationFormMode.view ? hasOptionalData : false,
        leading: const Icon(Icons.info_outline, size: 23),
        title: const Text('Допълнителни детайли'),
        children: [
          SizedBox(height: spacingByHeight(context, 0.02)),
          EmailField(
              controller: _formController.email,
              displayMode: _getContactInfoDisplayMode),
          SizedBox(height: spacingByHeight(context, 0.035)),
          PhoneNumberField(
              controller: _formController.phone,
              displayMode: _getContactInfoDisplayMode),
          SizedBox(height: spacingByHeight(context, 0.035)),
          CommentField(
              controller: _formController.comment, displayMode: _displayMode),
        ],
      ),
    );
  }
}
