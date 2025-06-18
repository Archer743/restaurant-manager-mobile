import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_manager_app/config/routing/app_routes.dart';
import 'package:restaurant_manager_app/core/presentation/services/snackbar_service.dart';
import 'package:restaurant_manager_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:restaurant_manager_app/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:restaurant_manager_app/core/presentation/widgets/back_leading_app_bar.dart';
import 'package:restaurant_manager_app/features/auth/presentation/widgets/forms/register_form.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _confPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackLeadingAppBar(title: 'Регистрация'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45),
          child: BlocConsumer<RegisterBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                SnackBarService.showSuccess(context, 'Успешна регистрация');
                context.go(AppRoutes.home);
              } else if (state is AuthFailure) {
                SnackBarService.showFailure(context, state.failure);
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: RegisterForm(
                  formKey: _formKey,
                  usernameController: _usernameController,
                  firstNameController: _firstNameController,
                  lastNameController: _lastNameController,
                  passwordController: _passwordController,
                  confPasswordController: _confPasswordController,
                  isLoading: state is AuthLoading,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
