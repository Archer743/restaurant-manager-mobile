import 'package:restaurant_manager_app/features/splash/domain/entities/auth_status.dart';

abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashLoaded extends SplashState {
  final AuthStatus status;

  /// True if refresh request failed due to network or unknown error
  late final bool authCheckFailed;

  SplashLoaded(this.status) {
    authCheckFailed =
        status == AuthStatus.networkError || status == AuthStatus.unknown;
  }
}
