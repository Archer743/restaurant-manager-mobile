import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:restaurant_manager_app/core/constants/api_urls.dart';
import 'package:restaurant_manager_app/core/data/data_sources/local/token_storage_service.dart';
import 'package:restaurant_manager_app/core/data/data_sources/remote/auth_shared_api_service.dart';
import 'package:restaurant_manager_app/core/data/repository/auth_shared_repository_impl.dart';
import 'package:restaurant_manager_app/core/domain/repository/auth_shared_repository.dart';
import 'package:restaurant_manager_app/features/auth/data/data_sources/auth_api_service.dart';
import 'package:restaurant_manager_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:restaurant_manager_app/features/auth/domain/repository/auth_repository.dart';
import 'package:restaurant_manager_app/features/auth/domain/usecases/login_user_usecase.dart';
import 'package:restaurant_manager_app/features/auth/domain/usecases/register_user_usecase.dart';
import 'package:restaurant_manager_app/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:restaurant_manager_app/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/data/data_sources/confirmed_reservations_api_service.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/data/repository/confirmed_reservations_repository_impl.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/domain/repository/confirmed_reservations_repository.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/domain/usecases/get_confirmed_reservations_usecase.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/presentation/bloc/calendar_bloc.dart';
import 'package:restaurant_manager_app/features/reservation_management/data/data_sources/reservation_api_service.dart';
import 'package:restaurant_manager_app/features/reservation_management/data/repository/reservation_repository._impl.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/repository/reservation_repository.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/usecases/create_reservation_usecase.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/usecases/get_reservation_details_usecase.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/usecases/update_reservation_usecase.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/reservation_bloc.dart';
import 'package:restaurant_manager_app/features/splash/data/repository/session_repository_impl.dart';
import 'package:restaurant_manager_app/features/splash/domain/repository/session_repository.dart';
import 'package:restaurant_manager_app/features/splash/domain/usecases/check_auth_status_usecase.dart';
import 'package:restaurant_manager_app/features/splash/presentation/bloc/splash_bloc.dart';

final sl = GetIt.instance;

// Dependencies
/*
* singleton -> creates one instance for the rest of app's lifetime
* factory   -> creates new instance every time it's needed
*/
Future<void> initDependencies() async {
  // ================ Dio ================
  sl.registerSingleton<Dio>(Dio(
    BaseOptions(
      baseUrl: apiBaseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  ));

  // ================ Flutter Secure Storage ================
  sl.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());

  // ================ Shared ================

  // [Data Sources]
  sl.registerSingleton<TokenStorageService>(TokenStorageService(sl()));
  sl.registerSingleton<AuthSharedApiService>(
      AuthSharedApiService(sl<Dio>(), baseUrl: authBaseUrl));

  // [Repositories]
  sl.registerSingleton<AuthSharedRepository>(AuthSharedRepositoryImpl(
      sl<AuthSharedApiService>(), sl<TokenStorageService>()));

  // ================ Features ================

  // ---------------- Auth Feature ----------------
  // [Data Sources]
  sl.registerSingleton<AuthApiService>(
      AuthApiService(sl<Dio>(), baseUrl: authBaseUrl));

  // [Repositories]
  sl.registerSingleton<AuthRepository>(
      AuthRepositoryImpl(sl<AuthApiService>(), sl<TokenStorageService>()));

  // [UseCases]
  sl.registerSingleton<LoginUserUseCase>(LoginUserUseCase(sl()));
  sl.registerSingleton<RegisterUserUseCase>(RegisterUserUseCase(sl()));

  // [Blocs]
  sl.registerFactory<LoginBloc>(() => LoginBloc(sl()));
  sl.registerFactory<RegisterBloc>(() => RegisterBloc(sl()));

  // ---------------- Splash Feature ----------------
  // [Repositories]
  sl.registerSingleton<SessionRepository>(SessionRepositoryImpl(
      sl<AuthSharedRepository>(), sl<TokenStorageService>()));

  // [UseCases]
  sl.registerSingleton<CheckAuthStatusUseCase>(CheckAuthStatusUseCase(sl()));

  // [Blocs]
  sl.registerFactory<SplashBloc>(() => SplashBloc(sl()));

  // ---------------- Confirmed Reservations Calendar Feature ----------------
  // [Data Sources]
  sl.registerSingleton<ConfirmedReservationsApiService>(
      ConfirmedReservationsApiService(sl<Dio>(), baseUrl: reservationsBaseUrl));

  // [Repositories]
  sl.registerSingleton<ConfirmedReservationsRepository>(
    ConfirmedReservationsRepositoryImpl(
      sl<AuthSharedRepository>(),
      sl<TokenStorageService>(),
      sl<ConfirmedReservationsApiService>(),
    ),
  );

  // [UseCases]
  sl.registerSingleton<GetConfirmedReservationsUsecase>(
      GetConfirmedReservationsUsecase(sl()));

  // [Blocs]
  sl.registerFactory<CalendarBloc>(() => CalendarBloc(sl()));

  // ---------------- Reservation Management Feature ----------------
  // [Data Sources]
  sl.registerSingleton<ReservationApiService>(
      ReservationApiService(sl<Dio>(), baseUrl: reservationsBaseUrl));

  // [Repositories]
  sl.registerSingleton<ReservationRepository>(
    ReservationRepositoryImpl(
      sl<AuthSharedRepository>(),
      sl<TokenStorageService>(),
      sl<ReservationApiService>(),
    ),
  );

  // [UseCases]
  sl.registerSingleton<GetReservationDetailsUseCase>(
      GetReservationDetailsUseCase(sl()));

  sl.registerSingleton<CreateReservationUseCase>(
      CreateReservationUseCase(sl()));

  sl.registerSingleton<UpdateReservationUseCase>(
      UpdateReservationUseCase(sl()));

  // [Blocs]
  sl.registerFactory<ReservationBloc>(
    () => ReservationBloc(
      sl<GetReservationDetailsUseCase>(),
      sl<CreateReservationUseCase>(),
      sl<UpdateReservationUseCase>(),
    ),
  );
}
