import 'package:dartz/dartz.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';

abstract class AuthSharedRepository {
  Future<Either<Failure, void>> refresh();
}
