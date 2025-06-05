import 'package:dartz/dartz.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/features/auth/domain/entities/user_login.dart';
import 'package:restaurant_manager_app/features/auth/domain/entities/user_register.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> login(UserLogin userLogin);
  Future<Either<Failure, void>> register(UserRegister userRegister);
  Future<Either<Failure, void>> refresh();
  Future<Either<Failure, void>> validateSession();
}
