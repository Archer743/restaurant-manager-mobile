import 'package:dartz/dartz.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/core/usecase/usecase.dart';
import 'package:restaurant_manager_app/features/auth/domain/entities/user_register.dart';
import 'package:restaurant_manager_app/features/auth/domain/repository/auth_repository.dart';

class RegisterUserUseCase
    implements UseCase<Either<Failure, void>, UserRegister> {
  final AuthRepository _authRepository;

  RegisterUserUseCase(this._authRepository);

  @override
  Future<Either<Failure, void>> call(UserRegister userRegister) async {
    return await _authRepository.register(userRegister);
  }
}
