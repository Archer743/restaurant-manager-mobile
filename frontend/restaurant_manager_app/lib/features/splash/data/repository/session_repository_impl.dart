import 'package:dartz/dartz.dart';
import 'package:restaurant_manager_app/core/domain/repository/auth_shared_repository.dart';
import 'package:restaurant_manager_app/core/errors/exceptions.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/core/data/data_sources/local/token_storage_service.dart';
import 'package:restaurant_manager_app/features/splash/domain/repository/session_repository.dart';

class SessionRepositoryImpl implements SessionRepository {
  final AuthSharedRepository _authSharedRepo;
  final TokenStorageService _tokenService;

  SessionRepositoryImpl(this._authSharedRepo, this._tokenService);

  @override
  Future<Either<Failure, void>> validateSession() async {
    try {
      if (await _tokenService.isAccessTokenExpired()) {
        return await _authSharedRepo.refresh();
      }

      return const Right(null);
    } on AuthTokenException {
      return Left(AuthTokenFailure());
    }
  }
}
