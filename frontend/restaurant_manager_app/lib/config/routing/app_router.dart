import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_manager_app/config/routing/app_routes.dart';
import 'package:restaurant_manager_app/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:restaurant_manager_app/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:restaurant_manager_app/features/auth/presentation/pages/login_page.dart';
import 'package:restaurant_manager_app/features/auth/presentation/pages/register_page.dart';
import 'package:restaurant_manager_app/features/auth/presentation/pages/welcome_page.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/presentation/bloc/calendar_bloc.dart';
import 'package:restaurant_manager_app/features/home/presentation/home_page.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/details/reservation_details_bloc.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/details/reservation_details_event.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/create/reservation_create_bloc.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/tables/reservation_tables_bloc.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/tables/reservation_tables_event.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/pages/reservation_create_page.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/pages/reservation_view_page.dart';
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
          create: (_) => sl()..add(CheckAuth()),
          child: const SplashPage(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (_, __) => const HomePage(),
    ),
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
    // Route for creating a new reservation
    GoRoute(
      path: AppRoutes.reservation,
      builder: (context, state) {
        try {
          final extraData = state.extra as Map<String, dynamic>;
          final DateTime initialDateLocal = extraData['initialDateLocal']!;
          final CalendarBloc calendarBloc = extraData['calendarBloc']!;

          return MultiBlocProvider(
            providers: [
              BlocProvider<ReservationCreateBloc>(create: (_) => sl()),
              BlocProvider<CalendarBloc>.value(value: calendarBloc),
            ],
            child: ReservationCreatePage(initialDateLocal: initialDateLocal),
          );
        } catch (_) {
          return const Text('Error: Path ${AppRoutes.reservation}');
        }
      },
      routes: [
        // Sub-route for viewing/editing an existing reservation
        GoRoute(
          path: ':id',
          builder: (context, state) {
            final reservationId = state.pathParameters['id'];
            final calendarBloc = state.extra as CalendarBloc?;

            // TODO: Navigate to an error page
            if (reservationId == null) {
              return const Text('Error: Reservation ID missing');
            }

            return MultiBlocProvider(
              providers: [
                BlocProvider<ReservationDetailsBloc>(
                  create: (_) =>
                      sl()..add(GetReservationDetails(reservationId)),
                ),
                BlocProvider<ReservationTablesBloc>(
                  create: (_) =>
                      sl()..add(GetTablesAvailability(reservationId)),
                ),
                if (calendarBloc != null)
                  BlocProvider<CalendarBloc>.value(value: calendarBloc),
              ],
              child: ReservationViewPage(reservationId: reservationId),
            );
          },
        ),
      ],
    ),
  ],
);
