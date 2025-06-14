// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_preview_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationPreviewModel _$ReservationPreviewModelFromJson(
        Map<String, dynamic> json) =>
    ReservationPreviewModel(
      id: json['id'] as String,
      time: json['time'] as String,
      peopleCount: (json['peopleCount'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$ReservationPreviewModelToJson(
        ReservationPreviewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'time': instance.time,
      'peopleCount': instance.peopleCount,
      'name': instance.name,
    };
