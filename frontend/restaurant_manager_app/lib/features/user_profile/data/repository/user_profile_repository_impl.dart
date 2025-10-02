import 'package:dartz/dartz.dart';
import 'package:restaurant_manager_app/core/data/data_sources/local/token_storage_service.dart';
import 'package:restaurant_manager_app/core/domain/repository/auth_shared_repository.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/core/network/auth_request_handler.dart';
import 'package:restaurant_manager_app/features/user_profile/data/data_sources/user_profile_api_service.dart';
import 'package:restaurant_manager_app/features/user_profile/domain/entities/user_profile_view.dart';
import 'package:restaurant_manager_app/features/user_profile/domain/repository/user_profile_repository.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final AuthSharedRepository _authSharedRepo;
  final TokenStorageService _tokenService;
  final UserProfileApiService _userProfileApiService;

  UserProfileRepositoryImpl(
    this._authSharedRepo,
    this._tokenService,
    this._userProfileApiService,
  );

  @override
  Future<Either<Failure, UserProfileView>> getCurrUserProfile() async {
    return await handleAuthRequest(
      _tokenService,
      _authSharedRepo,
      (authorization) async {
        final response =
            await _userProfileApiService.getCurrUserProfile(authorization);

        return response.data;
      },
    );
  }
}
