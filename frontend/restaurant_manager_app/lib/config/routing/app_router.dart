import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_manager_app/config/routing/app_route_redirect.dart';
import 'package:restaurant_manager_app/config/routing/auth_state_notifier.dart';
import 'package:restaurant_manager_app/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:restaurant_manager_app/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:restaurant_manager_app/features/auth/presentation/pages/login_page.dart';
import 'package:restaurant_manager_app/features/auth/presentation/pages/register_page.dart';
import 'package:restaurant_manager_app/features/auth/presentation/pages/welcome_page.dart';
import 'package:restaurant_manager_app/injection_container.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  refreshListenable: sl<AuthStateNotifier>(),
  redirect: appRouteRedirect,
  routes: [
    GoRoute(
      path: '/auth',
      builder: (context, state) => const WelcomePage(),
      routes: [
        GoRoute(
          path: 'login',
          builder: (context, state) {
            return BlocProvider<LoginBloc>(
              create: (context) => sl(),
              child: const LoginPage(),
            );
          },
        ),
        GoRoute(
          path: 'register',
          builder: (context, state) {
            return BlocProvider<RegisterBloc>(
              create: (context) => sl(),
              child: const RegisterPage(),
            );
          },
        ),
      ],
    ),
  ],
);
