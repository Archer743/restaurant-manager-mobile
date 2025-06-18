// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_view_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationViewModel _$ReservationViewModelFromJson(
        Map<String, dynamic> json) =>
    ReservationViewModel(
      id: json['id'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      date: const AppDateOnlyConverter().fromJson(json['date'] as String),
      time: json['time'] as String,
      peopleCount: (json['peopleCount'] as num).toInt(),
      name: json['name'] as String,
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$ReservationViewModelToJson(
        ReservationViewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'email': instance.email,
      'date': const AppDateOnlyConverter().toJson(instance.date),
      'time': instance.time,
      'peopleCount': instance.peopleCount,
      'name': instance.name,
      'comment': instance.comment,
    };
