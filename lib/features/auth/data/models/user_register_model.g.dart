// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_register_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRegisterModel _$UserRegisterModelFromJson(Map<String, dynamic> json) =>
    UserRegisterModel(
      username: json['username'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$UserRegisterModelToJson(UserRegisterModel instance) =>
    <String, dynamic>{
      'username': instance.username,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'password': instance.password,
    };
