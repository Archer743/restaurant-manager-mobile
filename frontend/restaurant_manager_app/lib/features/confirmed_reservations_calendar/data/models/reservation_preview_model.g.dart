// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_preview_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationPreviewModel _$ReservationPreviewModelFromJson(
        Map<String, dynamic> json) =>
    ReservationPreviewModel(
      id: json['id'] as String,
      name: json['name'] as String,
      time: const AppTimeOfDayConverter().fromJson(json['time'] as String),
      peopleCount: (json['peopleCount'] as num).toInt(),
      isCreatedByStaff: json['isCreatedByStaff'] as bool,
      isClosed: json['isClosed'] as bool,
    );

Map<String, dynamic> _$ReservationPreviewModelToJson(
        ReservationPreviewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'peopleCount': instance.peopleCount,
      'isCreatedByStaff': instance.isCreatedByStaff,
      'isClosed': instance.isClosed,
      'time': const AppTimeOfDayConverter().toJson(instance.time),
    };
