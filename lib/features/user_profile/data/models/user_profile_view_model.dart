import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_manager_app/features/user_profile/domain/entities/user_profile_view.dart';

part 'user_profile_view_model.g.dart';

@JsonSerializable()
class UserProfileViewModel extends UserProfileView {
  UserProfileViewModel({
    required super.username,
    required super.roleName,
    required super.firstName,
    required super.lastName,
  });

  factory UserProfileViewModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileViewModelFromJson(json);
}
