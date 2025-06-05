import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_manager_app/core/utils/spacing.dart';
import 'package:restaurant_manager_app/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:restaurant_manager_app/features/auth/presentation/bloc/login/login_event.dart';
import 'package:restaurant_manager_app/features/auth/presentation/widgets/buttons/action_button.dart';
import 'package:restaurant_manager_app/features/auth/presentation/widgets/fields/password_field.dart';
import 'package:restaurant_manager_app/features/auth/presentation/widgets/fields/username_field.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool isLoading;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    required this.isLoading,
  });

  void _submit(BuildContext context) {
    if (!isLoading && (formKey.currentState?.validate() ?? false)) {
      context.read<LoginBloc>().add(LoginSubmitted(
            username: usernameController.text,
            password: passwordController.text,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          UsernameField(controller: usernameController),
          SizedBox(height: spacingByHeight(context, 0.05)),
          PasswordField(controller: passwordController),
          SizedBox(height: spacingByHeight(context, 0.2)),
          ActionButton(
            label: 'Вход',
            onPressed: () => _submit(context),
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}
