import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/features/user_profile/domain/entities/user_profile_view.dart';

abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final UserProfileView profile;

  UserProfileLoaded(this.profile);
}

class LogoutSuccess extends UserProfileState {}

class UserProfileError extends UserProfileState {
  final Failure failure;
  final UserProfileView? profile;

  UserProfileError({
    required this.failure,
    this.profile,
  });

  bool hasProfile() => profile != null;
}
