import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_manager_app/config/routing/app_routes.dart';
import 'package:restaurant_manager_app/config/theme/theme.dart';
import 'package:restaurant_manager_app/core/constants/error_codes.dart';
import 'package:restaurant_manager_app/core/errors/error_mapper.dart';
import 'package:restaurant_manager_app/core/utils/spacing.dart';
import 'package:restaurant_manager_app/features/splash/domain/entities/auth_status.dart';
import 'package:restaurant_manager_app/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:restaurant_manager_app/features/splash/presentation/bloc/splash_event.dart';
import 'package:restaurant_manager_app/features/splash/presentation/bloc/splash_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashBloc, SplashState>(
      listener: (context, state) {
        if (mounted && state is SplashLoaded) {
          if (state.status == AuthStatus.authenticated) {
            context.go(AppRoutes.home);
          } else if (state.status == AuthStatus.unauthenticated) {
            context.go(AppRoutes.welcome);
          }
        }
      },
      builder: (context, state) {
        // If the user is not navigated to another page - retry option
        if (state is SplashLoaded && state.authCheckFailed) {
          final errorCode = state.status == AuthStatus.networkError
              ? ErrorCodes.network
              : ErrorCodes.unknown;

          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      getErrorMessage(errorCode),
                      textAlign: TextAlign.center,
                      style: defaultTextStyle,
                    ),
                    SizedBox(height: spacingByHeight(context, 0.03)),
                    ElevatedButton(
                      onPressed: () {
                        context.read<SplashBloc>().add(CheckAuth());
                      },
                      child: const Text('Опитай пак'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
