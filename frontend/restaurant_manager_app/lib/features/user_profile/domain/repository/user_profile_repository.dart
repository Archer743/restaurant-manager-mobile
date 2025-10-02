import 'package:dartz/dartz.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/features/user_profile/domain/entities/user_profile_view.dart';

abstract class UserProfileRepository {
  Future<Either<Failure, UserProfileView>> getCurrUserProfile();
}
