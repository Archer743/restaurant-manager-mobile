// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_create_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationCreateModel _$ReservationCreateModelFromJson(
        Map<String, dynamic> json) =>
    ReservationCreateModel(
      phone: json['phone'] as String,
      email: json['email'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      peopleCount: (json['peopleCount'] as num).toInt(),
      name: json['name'] as String,
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$ReservationCreateModelToJson(
        ReservationCreateModel instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'email': instance.email,
      'date': instance.date,
      'time': instance.time,
      'peopleCount': instance.peopleCount,
      'name': instance.name,
      'comment': instance.comment,
    };
