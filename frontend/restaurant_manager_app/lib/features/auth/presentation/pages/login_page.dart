import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_manager_app/config/routing/app_routes.dart';
import 'package:restaurant_manager_app/core/presentation/services/snackbar_service.dart';
import 'package:restaurant_manager_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:restaurant_manager_app/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:restaurant_manager_app/features/auth/presentation/widgets/back_leading_app_bar.dart';
import 'package:restaurant_manager_app/features/auth/presentation/widgets/forms/login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackLeadingAppBar(title: 'Вход'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45),
          child: BlocConsumer<LoginBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                SnackBarService.showSuccess(context, 'Успешен вход');
                context.go(AppRoutes.home);
              } else if (state is AuthFailure) {
                SnackBarService.showFailure(context, state.failure);
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: LoginForm(
                  formKey: _formKey,
                  usernameController: _usernameController,
                  passwordController: _passwordController,
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
