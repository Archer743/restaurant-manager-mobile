import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:restaurant_manager_app/core/constants/api_urls.dart';
import 'package:restaurant_manager_app/features/auth/data/data_sources/local/token_storage_service.dart';
import 'package:restaurant_manager_app/features/auth/data/data_sources/remote/auth_api_service.dart';
import 'package:restaurant_manager_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:restaurant_manager_app/features/auth/domain/repository/auth_repository.dart';
import 'package:restaurant_manager_app/features/auth/domain/usecases/login_user.dart';
import 'package:restaurant_manager_app/features/auth/domain/usecases/register_user.dart';
import 'package:restaurant_manager_app/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:restaurant_manager_app/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:restaurant_manager_app/features/splash/domain/usecases/check_auth_status.dart';
import 'package:restaurant_manager_app/features/splash/presentation/bloc/splash_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Dio
  sl.registerSingleton<Dio>(Dio(
    BaseOptions(
      baseUrl: apiBaseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  ));

  // Flutter Secure Storage
  sl.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());

  // Dependencies
  /*
   * singleton -> creates one instance for the rest of app's lifetime
   * factory   -> creates new instance every time it's needed
   */

  // Data Sources
  sl.registerSingleton<AuthApiService>(
      AuthApiService(sl<Dio>(), baseUrl: authBaseUrl));

  sl.registerSingleton<TokenStorageService>(TokenStorageService(sl()));

  // Repositories
  sl.registerSingleton<AuthRepository>(
      AuthRepositoryImpl(sl<AuthApiService>(), sl<TokenStorageService>()));

  // UseCases
  sl.registerSingleton<LoginUserUseCase>(LoginUserUseCase(sl()));
  sl.registerSingleton<RegisterUserUseCase>(RegisterUserUseCase(sl()));
  sl.registerSingleton<CheckAuthStatusUseCase>(CheckAuthStatusUseCase(sl()));

  // Blocs
  sl.registerFactory<LoginBloc>(() => LoginBloc(sl()));
  sl.registerFactory<RegisterBloc>(() => RegisterBloc(sl()));
  sl.registerFactory<SplashBloc>(() => SplashBloc(sl()));
}
