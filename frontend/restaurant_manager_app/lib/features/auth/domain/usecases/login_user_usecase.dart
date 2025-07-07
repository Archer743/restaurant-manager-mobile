import 'package:dartz/dartz.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/core/domain/usecases/usecase.dart';
import 'package:restaurant_manager_app/features/auth/domain/entities/user_login.dart';
import 'package:restaurant_manager_app/features/auth/domain/repository/auth_repository.dart';

class LoginUserUseCase implements UseCase<Either<Failure, void>, UserLogin> {
  final AuthRepository _authRepo;

  LoginUserUseCase(this._authRepo);

  @override
  Future<Either<Failure, void>> call(UserLogin userLogin) async {
    return await _authRepo.login(userLogin);
  }
}
