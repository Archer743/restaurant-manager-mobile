import 'package:restaurant_manager_app/core/constants/error_codes.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/core/domain/usecases/usecase.dart';
import 'package:restaurant_manager_app/features/splash/domain/entities/auth_status.dart';
import 'package:restaurant_manager_app/features/splash/domain/repository/session_repository.dart';

class CheckAuthStatusUseCase implements UseCase<AuthStatus, NoParams> {
  final SessionRepository _sessionRepo;

  CheckAuthStatusUseCase(this._sessionRepo);

  @override
  Future<AuthStatus> call(NoParams params) async {
    final result = await _sessionRepo.validateSession();

    return result.fold(
      (failure) {
        if (failure is AuthTokenFailure || failure is InvalidSessionFailure) {
          return AuthStatus.unauthenticated;
        }

        if (failure is NetworkFailure) {
          return AuthStatus.networkError;
        }

        return AuthStatus.unknown;
      },
      (_) => AuthStatus.authenticated,
    );
  }
}
