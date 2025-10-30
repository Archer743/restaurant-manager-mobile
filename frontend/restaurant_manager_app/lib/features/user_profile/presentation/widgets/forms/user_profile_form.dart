import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/core/utils/spacing.dart';

enum UserProfileFormMode { view }

class UserProfileForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final UserProfileFormMode displayMode;

  final TextEditingController usernameController;
  final TextEditingController roleNameController;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;

  const UserProfileForm({
    super.key,
    required this.formKey,
    required this.displayMode,
    required this.usernameController,
    required this.roleNameController,
    required this.firstNameController,
    required this.lastNameController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          SizedBox(height: spacingByHeight(context, 0.04)),
          _getReadOnlyFormField('Потребител', usernameController),
          SizedBox(height: spacingByHeight(context, 0.02)),
          _getReadOnlyFormField('Роля в системата', roleNameController),
          SizedBox(height: spacingByHeight(context, 0.02)),
          _getReadOnlyFormField('Име', firstNameController),
          SizedBox(height: spacingByHeight(context, 0.02)),
          _getReadOnlyFormField('Фамилия', lastNameController),
          SizedBox(height: spacingByHeight(context, 0.04)),
        ],
      ),
    );
  }

  Widget _getReadOnlyFormField(
      String labelText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(labelText: labelText),
    );
  }
}
