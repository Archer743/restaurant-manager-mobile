// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_update_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationUpdateModel _$ReservationUpdateModelFromJson(
        Map<String, dynamic> json) =>
    ReservationUpdateModel(
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      startTimeUtc: _$JsonConverterFromJson<String, DateTime>(
          json['startTimeUtc'], const AppDateTimeUtcConverter().fromJson),
      peopleCount: (json['peopleCount'] as num?)?.toInt(),
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$ReservationUpdateModelToJson(
        ReservationUpdateModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'peopleCount': instance.peopleCount,
      'comment': instance.comment,
      'startTimeUtc': _$JsonConverterToJson<String, DateTime>(
          instance.startTimeUtc, const AppDateTimeUtcConverter().toJson),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
