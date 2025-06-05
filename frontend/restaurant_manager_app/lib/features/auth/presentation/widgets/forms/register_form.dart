import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_manager_app/core/utils/spacing.dart';
import 'package:restaurant_manager_app/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:restaurant_manager_app/features/auth/presentation/bloc/register/register_event.dart';
import 'package:restaurant_manager_app/features/auth/presentation/widgets/buttons/action_button.dart';
import 'package:restaurant_manager_app/features/auth/presentation/widgets/fields/conf_password_field.dart';
import 'package:restaurant_manager_app/features/auth/presentation/widgets/fields/name_field.dart';
import 'package:restaurant_manager_app/features/auth/presentation/widgets/fields/password_field.dart';
import 'package:restaurant_manager_app/features/auth/presentation/widgets/fields/username_field.dart';

class RegisterForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController passwordController;
  final TextEditingController confPasswordController;
  final bool isLoading;

  const RegisterForm({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.firstNameController,
    required this.lastNameController,
    required this.passwordController,
    required this.confPasswordController,
    required this.isLoading,
  });

  void _submit(BuildContext context) {
    if (!isLoading && (formKey.currentState?.validate() ?? false)) {
      context.read<RegisterBloc>().add(
            RegisterSubmitted(
              username: usernameController.text,
              firstName: firstNameController.text,
              lastName: lastNameController.text,
              password: passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          SizedBox(height: spacingByHeight(context, 0.02)),
          UsernameField(controller: usernameController),
          SizedBox(height: spacingByHeight(context, 0.035)),
          NameField(
            controller: firstNameController,
            nameType: NameType.firstName,
          ),
          SizedBox(height: spacingByHeight(context, 0.035)),
          NameField(
            controller: lastNameController,
            nameType: NameType.lastName,
          ),
          SizedBox(height: spacingByHeight(context, 0.035)),
          PasswordField(controller: passwordController, validatePassword: true),
          SizedBox(height: spacingByHeight(context, 0.035)),
          ConfPasswordField(
            mainController: confPasswordController,
            passwordController: passwordController,
          ),
          SizedBox(height: spacingByHeight(context, 0.06)),
          ActionButton(
            label: 'Регистрация',
            onPressed: () => _submit(context),
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}
