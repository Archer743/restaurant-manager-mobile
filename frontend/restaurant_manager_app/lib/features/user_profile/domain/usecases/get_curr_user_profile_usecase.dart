import 'package:dartz/dartz.dart';
import 'package:restaurant_manager_app/core/domain/usecases/usecase.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/features/user_profile/domain/entities/user_profile_view.dart';
import 'package:restaurant_manager_app/features/user_profile/domain/repository/user_profile_repository.dart';

class GetCurrUserProfileUseCase
    extends UseCase<Either<Failure, UserProfileView>, NoParams> {
  final UserProfileRepository _userProfileRepository;

  GetCurrUserProfileUseCase(this._userProfileRepository);

  @override
  Future<Either<Failure, UserProfileView>> call(NoParams params) async {
    return await _userProfileRepository.getCurrUserProfile();
  }
}
