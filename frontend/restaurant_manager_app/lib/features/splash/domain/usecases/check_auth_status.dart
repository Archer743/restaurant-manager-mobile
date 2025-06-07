import 'package:restaurant_manager_app/core/constants/error_codes.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/core/usecase/usecase.dart';
import 'package:restaurant_manager_app/features/auth/domain/repository/auth_repository.dart';
import 'package:restaurant_manager_app/features/splash/domain/entities/auth_status.dart';

class CheckAuthStatusUseCase implements UseCase<AuthStatus, NoParams> {
  final AuthRepository repository;

  CheckAuthStatusUseCase(this.repository);

  @override
  Future<AuthStatus> call(NoParams params) async {
    final result = await repository.validateSession();

    return result.fold(
      (failure) {
        if (failure is AuthTokenFailure) {
          return AuthStatus.unauthenticated;
        }

        if (failure is ServerFailure &&
            failure.errorCode == ErrorCodes.invalidSession) {
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
