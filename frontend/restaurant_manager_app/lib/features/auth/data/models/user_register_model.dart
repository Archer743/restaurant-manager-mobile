import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_manager_app/features/auth/domain/entities/user_register.dart';

part 'user_register_model.g.dart';

@JsonSerializable()
class UserRegisterModel extends UserRegister {
  UserRegisterModel({
    required super.username,
    required super.firstName,
    required super.lastName,
    required super.password,
  });

  factory UserRegisterModel.fromEntity(UserRegister entity) {
    return UserRegisterModel(
      username: entity.username,
      firstName: entity.firstName,
      lastName: entity.lastName,
      password: entity.password,
    );
  }

  Map<String, dynamic> toJson() => _$UserRegisterModelToJson(this);
}
