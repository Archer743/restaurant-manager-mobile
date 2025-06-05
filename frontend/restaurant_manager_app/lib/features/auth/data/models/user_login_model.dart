import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_manager_app/features/auth/domain/entities/user_login.dart';

part 'user_login_model.g.dart';

@JsonSerializable()
class UserLoginModel extends UserLogin {
  const UserLoginModel({
    required super.username,
    required super.password,
  });

  factory UserLoginModel.fromEntity(UserLogin entity) {
    return UserLoginModel(
      username: entity.username,
      password: entity.password,
    );
  }

  Map<String, dynamic> toJson() => _$UserLoginModelToJson(this);
}
