// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_view_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileViewModel _$UserProfileViewModelFromJson(
        Map<String, dynamic> json) =>
    UserProfileViewModel(
      username: json['username'] as String,
      roleName: json['roleName'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
    );

Map<String, dynamic> _$UserProfileViewModelToJson(
        UserProfileViewModel instance) =>
    <String, dynamic>{
      'username': instance.username,
      'roleName': instance.roleName,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
    };
