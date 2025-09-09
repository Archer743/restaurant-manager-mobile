// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_create_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationCreateModel _$ReservationCreateModelFromJson(
        Map<String, dynamic> json) =>
    ReservationCreateModel(
      name: json['name'] as String,
      startTimeUtc: const AppDateTimeUtcConverter()
          .fromJson(json['startTimeUtc'] as String),
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
      'startTimeUtc':
          const AppDateTimeUtcConverter().toJson(instance.startTimeUtc),
    };
