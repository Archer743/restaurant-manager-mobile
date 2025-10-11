import 'package:dartz/dartz.dart';
import 'package:restaurant_manager_app/core/domain/usecases/usecase.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/features/user_profile/domain/repository/user_profile_repository.dart';

class LogoutUseCase extends UseCase<Either<Failure, void>, NoParams> {
  final UserProfileRepository _userProfileRepository;

  LogoutUseCase(this._userProfileRepository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await _userProfileRepository.logout();
  }
}
