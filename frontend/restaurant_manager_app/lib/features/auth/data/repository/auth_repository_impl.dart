import 'package:dartz/dartz.dart';
import 'package:restaurant_manager_app/core/errors/exceptions.dart';
import 'package:restaurant_manager_app/features/auth/data/models/auth_refresh_model.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/core/network/request_handler.dart';
import 'package:restaurant_manager_app/features/auth/data/data_sources/local/token_storage_service.dart';
import 'package:restaurant_manager_app/features/auth/data/data_sources/remote/auth_api_service.dart';
import 'package:restaurant_manager_app/features/auth/data/models/user_login_model.dart';
import 'package:restaurant_manager_app/features/auth/data/models/user_register_model.dart';
import 'package:restaurant_manager_app/features/auth/domain/entities/user_login.dart';
import 'package:restaurant_manager_app/features/auth/domain/entities/user_register.dart';
import 'package:restaurant_manager_app/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _authApiService;
  final TokenStorageService _tokenService;

  AuthRepositoryImpl(this._authApiService, this._tokenService);

  @override
  Future<Either<Failure, void>> login(UserLogin userLogin) async {
    return await handleRequest<Null>(() async {
      final model = UserLoginModel.fromEntity(userLogin);
      final result = await _authApiService.login(model);
      await _tokenService.saveTokens(result.data); // Save tokens locally
      return null;
    });
  }

  @override
  Future<Either<Failure, void>> register(UserRegister userRegister) async {
    return await handleRequest<Null>(() async {
      final model = UserRegisterModel.fromEntity(userRegister);
      final result = await _authApiService.register(model);
      await _tokenService.saveTokens(result.data); // Save tokens locally
      return null;
    });
  }

  @override
  Future<Either<Failure, void>> refresh() async {
    return await handleRequest<Null>(() async {
      // Get refresh token
      final refreshToken = await _tokenService.getRefreshToken();

      // User should login / register
      if (refreshToken == null || refreshToken.isEmpty) {
        throw AuthTokenException();
      }

      final model = AuthRefreshModel(refreshToken);
      final result = await _authApiService.refresh(model);

      await _tokenService.saveTokens(result.data); // Save new tokens locally
      return null;
    });
  }

  @override
  Future<Either<Failure, void>> validateSession() async {
    try {
      if (await _tokenService.isAccessTokenExpired()) {
        return await refresh();
      }

      return const Right(null);
    } on AuthTokenException {
      return Left(AuthTokenFailure());
    }
  }
}
