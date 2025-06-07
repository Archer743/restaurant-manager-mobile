import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_manager_app/config/routing/app_routes.dart';
import 'package:restaurant_manager_app/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:restaurant_manager_app/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:restaurant_manager_app/features/auth/presentation/pages/login_page.dart';
import 'package:restaurant_manager_app/features/auth/presentation/pages/register_page.dart';
import 'package:restaurant_manager_app/features/auth/presentation/pages/welcome_page.dart';
import 'package:restaurant_manager_app/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:restaurant_manager_app/features/splash/presentation/bloc/splash_event.dart';
import 'package:restaurant_manager_app/features/splash/presentation/splash_page.dart';
import 'package:restaurant_manager_app/injection_container.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (_, __) {
        return BlocProvider<SplashBloc>(
          create: (_) => sl()..add(CheckAuthEvent()),
          child: const SplashPage(),
        );
      },
    ),
    // GoRoute(
    //   path: AppRoutes.home,
    //   builder: (_, __) => const HomePage(),
    // ),
    GoRoute(
      path: AppRoutes.welcome,
      builder: (_, __) => const WelcomePage(),
      routes: [
        GoRoute(
          path: 'login',
          builder: (_, __) {
            return BlocProvider<LoginBloc>(
              create: (_) => sl(),
              child: const LoginPage(),
            );
          },
        ),
        GoRoute(
          path: 'register',
          builder: (_, __) {
            return BlocProvider<RegisterBloc>(
              create: (_) => sl(),
              child: const RegisterPage(),
            );
          },
        ),
      ],
    ),
  ],
);
