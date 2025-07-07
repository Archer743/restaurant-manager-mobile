import 'package:dartz/dartz.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';

abstract class SessionRepository {
  Future<Either<Failure, void>> validateSession();
}
