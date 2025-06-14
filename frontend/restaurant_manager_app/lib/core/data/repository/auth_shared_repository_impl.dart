import 'package:dartz/dartz.dart';
import 'package:restaurant_manager_app/core/data/data_sources/remote/auth_shared_api_service.dart';
import 'package:restaurant_manager_app/core/data/models/auth_refresh_model.dart';
import 'package:restaurant_manager_app/core/domain/repository/auth_shared_repository.dart';
import 'package:restaurant_manager_app/core/errors/exceptions.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/core/network/request_handler.dart';
import 'package:restaurant_manager_app/core/data/data_sources/local/token_storage_service.dart';

class AuthSharedRepositoryImpl implements AuthSharedRepository {
  final AuthSharedApiService _authSharedApiService;
  final TokenStorageService _tokenService;

  AuthSharedRepositoryImpl(this._authSharedApiService, this._tokenService);

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
      final response = await _authSharedApiService.refresh(model);

      await _tokenService.saveTokens(response.data); // Save new tokens locally
      return null;
    });
  }
}
