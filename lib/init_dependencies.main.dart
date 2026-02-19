part of 'init_dependencies.dart';

final sl = GetIt.instance;

// Dependencies
/*
* singleton -> creates one instance for the rest of app's lifetime immediately
* lazy singleton -> creates one instance only when someone asks for it for the first time
* factory   -> creates new instance every time it's needed
*/

Future<void> initDependencies() async {
  await _initCoreDependencies();

  // Features
  _initAuthFeature();
  _initSplashFeature();
  _initCalendarFeature();
  _initReservationManagementFeature();
  _initFloorPlanFeature();
  _initPendingInboxFeature();
  _initUserProfileFeature();
}

Future<void> _initCoreDependencies() async {
  // ================ Dio ================
  sl.registerSingleton<Dio>(Dio(
    BaseOptions(
      baseUrl: apiBaseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  ));

  // ================ Flutter Secure Storage ================
  // Kept async context due to this dependency
  sl.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());

  // ================ Event Bus ================
  sl.registerLazySingleton<AppEventBus>(() => AppEventBus());

  // ================ Data Sources ================
  sl.registerSingleton<TokenStorageService>(TokenStorageService(sl()));
  sl.registerSingleton<AuthSharedApiService>(
      AuthSharedApiService(sl<Dio>(), baseUrl: authBaseUrl));

  // ================ Repositories ================
  sl.registerSingleton<AuthSharedRepository>(AuthSharedRepositoryImpl(
      sl<AuthSharedApiService>(), sl<TokenStorageService>()));
}

void _initAuthFeature() {
  // [Data Sources]
  sl.registerLazySingleton<AuthApiService>(
      () => AuthApiService(sl<Dio>(), baseUrl: authBaseUrl));

  // [Repositories]
  sl.registerLazySingleton<AuthRepository>(() =>
      AuthRepositoryImpl(sl<AuthApiService>(), sl<TokenStorageService>()));

  // [UseCases]
  sl.registerLazySingleton<LoginUserUseCase>(() => LoginUserUseCase(sl()));
  sl.registerLazySingleton<RegisterUserUseCase>(
    () => RegisterUserUseCase(sl()),
  );

  // [Blocs]
  sl.registerFactory<LoginBloc>(() => LoginBloc(sl()));
  sl.registerFactory<RegisterBloc>(() => RegisterBloc(sl()));
}

void _initSplashFeature() {
  // [Repositories]
  sl.registerSingleton<SessionRepository>(SessionRepositoryImpl(
      sl<AuthSharedRepository>(), sl<TokenStorageService>()));

  // [UseCases]
  sl.registerSingleton<CheckAuthStatusUseCase>(CheckAuthStatusUseCase(sl()));

  // [Blocs]
  sl.registerFactory<SplashBloc>(() => SplashBloc(sl()));
}

void _initCalendarFeature() {
  // [Data Sources]
  sl.registerLazySingleton<ConfirmedReservationsApiService>(() =>
      ConfirmedReservationsApiService(sl<Dio>(), baseUrl: reservationsBaseUrl));

  // [Repositories]
  sl.registerLazySingleton<ConfirmedReservationsRepository>(
    () => ConfirmedReservationsRepositoryImpl(
      sl<AuthSharedRepository>(),
      sl<TokenStorageService>(),
      sl<ConfirmedReservationsApiService>(),
    ),
  );

  // [UseCases]
  sl.registerLazySingleton<GetConfirmedReservationsUsecase>(
      () => GetConfirmedReservationsUsecase(sl()));

  // [Blocs]
  sl.registerFactory<CalendarBloc>(() => CalendarBloc(sl(), sl()));
}

void _initReservationManagementFeature() {
  // [Data Sources]
  sl.registerLazySingleton<ReservationApiService>(
      () => ReservationApiService(sl<Dio>(), baseUrl: reservationsBaseUrl));

  sl.registerLazySingleton<ReservationTableApiService>(() =>
      ReservationTableApiService(sl<Dio>(), baseUrl: reservationsBaseUrl));

  // [Repositories]
  sl.registerLazySingleton<ReservationRepository>(
    () => ReservationRepositoryImpl(
      sl<AppEventBus>(),
      sl<AuthSharedRepository>(),
      sl<TokenStorageService>(),
      sl<ReservationApiService>(),
      sl<ReservationTableApiService>(),
    ),
  );

  // [UseCases]
  sl.registerLazySingleton<CreateReservationUseCase>(
      () => CreateReservationUseCase(sl()));

  sl.registerLazySingleton<GetReservationUseCase>(
      () => GetReservationUseCase(sl()));

  sl.registerLazySingleton<UpdateReservationUseCase>(
      () => UpdateReservationUseCase(sl()));

  sl.registerLazySingleton<RemoveReservationUseCase>(
      () => RemoveReservationUseCase(sl()));

  sl.registerLazySingleton<CloseReservationUseCase>(
      () => CloseReservationUseCase(sl()));

  sl.registerLazySingleton<ReopenReservationUseCase>(
      () => ReopenReservationUseCase(sl()));

  sl.registerLazySingleton<GetTablesAvailabilityForReservationUseCase>(
      () => GetTablesAvailabilityForReservationUseCase(sl()));

  sl.registerLazySingleton<UpdateReservationTablesUseCase>(
      () => UpdateReservationTablesUseCase(sl()));

  // [Blocs]
  sl.registerFactory<ReservationCreateBloc>(
    () => ReservationCreateBloc(sl<CreateReservationUseCase>()),
  );

  sl.registerFactory<ReservationDetailsBloc>(
    () => ReservationDetailsBloc(
      sl<GetReservationUseCase>(),
      sl<UpdateReservationUseCase>(),
      sl<RemoveReservationUseCase>(),
      sl<CloseReservationUseCase>(),
      sl<ReopenReservationUseCase>(),
    ),
  );

  sl.registerFactory<ReservationTablesBloc>(
    () => ReservationTablesBloc(
      sl<GetTablesAvailabilityForReservationUseCase>(),
      sl<UpdateReservationTablesUseCase>(),
    ),
  );
}

void _initFloorPlanFeature() {
  // [Data Sources]
  sl.registerLazySingleton<FloorPlanApiService>(
      () => FloorPlanApiService(sl<Dio>(), baseUrl: apiBaseUrl));

  sl.registerLazySingleton<ReservationPreviewApiService>(() =>
      ReservationPreviewApiService(sl<Dio>(), baseUrl: reservationsBaseUrl));

  // [Repositories]
  sl.registerLazySingleton<FloorPlanRepository>(
    () => FloorPlanRepositoryImpl(
      sl<AuthSharedRepository>(),
      sl<TokenStorageService>(),
      sl<FloorPlanApiService>(),
      sl<ReservationPreviewApiService>(),
    ),
  );

  // [UseCases]
  sl.registerLazySingleton<GetFloorPlanUseCase>(
      () => GetFloorPlanUseCase(sl()));

  sl.registerLazySingleton<GetReservationPreviewUseCase>(
      () => GetReservationPreviewUseCase(sl()));

  // [Blocs]
  sl.registerFactory<FloorPlanBloc>(
    () => FloorPlanBloc(
      sl<GetFloorPlanUseCase>(),
    ),
  );

  sl.registerFactory<ReservationPreviewBloc>(
    () => ReservationPreviewBloc(
      sl<GetReservationPreviewUseCase>(),
    ),
  );
}

void _initPendingInboxFeature() {
  // [Data Sources]
  sl.registerLazySingleton<PendingReservationsApiService>(() =>
      PendingReservationsApiService(sl<Dio>(), baseUrl: reservationsBaseUrl));

  // [Repositories]
  sl.registerLazySingleton<PendingReservationsRepository>(
    () => PendingReservationsRepositoryImpl(
      sl<AuthSharedRepository>(),
      sl<TokenStorageService>(),
      sl<PendingReservationsApiService>(),
    ),
  );

  // [UseCases]
  sl.registerLazySingleton<GetPendingReservationsUsecase>(
      () => GetPendingReservationsUsecase(sl()));

  // [Blocs]
  sl.registerFactory<PendingInboxBloc>(
    () => PendingInboxBloc(sl()),
  );
}

void _initUserProfileFeature() {
  // [Data Sources]
  sl.registerLazySingleton<UserProfileApiService>(
      () => UserProfileApiService(sl<Dio>(), baseUrl: usersBaseUrl));

  sl.registerLazySingleton<LogoutApiService>(
      () => LogoutApiService(sl<Dio>(), baseUrl: authBaseUrl));

  // [Repositories]
  sl.registerLazySingleton<UserProfileRepository>(
    () => UserProfileRepositoryImpl(
      sl<AuthSharedRepository>(),
      sl<TokenStorageService>(),
      sl<UserProfileApiService>(),
      sl<LogoutApiService>(),
    ),
  );

  // [UseCases]
  sl.registerLazySingleton<GetCurrUserProfileUseCase>(
      () => GetCurrUserProfileUseCase(sl()));

  sl.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(sl()));

  // [Blocs]
  sl.registerFactory<UserProfileBloc>(
    () => UserProfileBloc(
      sl<GetCurrUserProfileUseCase>(),
      sl<LogoutUseCase>(),
    ),
  );
}
