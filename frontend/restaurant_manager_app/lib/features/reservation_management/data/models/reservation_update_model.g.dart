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
      date: json['date'] as String?,
      time: json['time'] as String?,
      peopleCount: (json['peopleCount'] as num?)?.toInt(),
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$ReservationUpdateModelToJson(
        ReservationUpdateModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'date': instance.date,
      'time': instance.time,
      'peopleCount': instance.peopleCount,
      'comment': instance.comment,
    };
