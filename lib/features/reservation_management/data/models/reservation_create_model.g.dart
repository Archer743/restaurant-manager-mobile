// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_create_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationCreateModel _$ReservationCreateModelFromJson(
        Map<String, dynamic> json) =>
    ReservationCreateModel(
      name: json['name'] as String,
      startUtc:
          const AppDateTimeUtcConverter().fromJson(json['startUtc'] as String),
      peopleCount: (json['peopleCount'] as num).toInt(),
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$ReservationCreateModelToJson(
        ReservationCreateModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'peopleCount': instance.peopleCount,
      'email': instance.email,
      'phone': instance.phone,
      'comment': instance.comment,
      'startUtc': const AppDateTimeUtcConverter().toJson(instance.startUtc),
    };
