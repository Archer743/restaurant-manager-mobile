// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_preview_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationPreviewModel _$ReservationPreviewModelFromJson(
        Map<String, dynamic> json) =>
    ReservationPreviewModel(
      id: json['id'] as String,
      tag: json['tag'] as String,
      name: json['name'] as String,
      startUtc:
          const AppDateTimeUtcConverter().fromJson(json['startUtc'] as String),
      peopleCount: (json['peopleCount'] as num).toInt(),
      isClosed: json['isClosed'] as bool,
    );

Map<String, dynamic> _$ReservationPreviewModelToJson(
        ReservationPreviewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tag': instance.tag,
      'name': instance.name,
      'peopleCount': instance.peopleCount,
      'isClosed': instance.isClosed,
      'startUtc': const AppDateTimeUtcConverter().toJson(instance.startUtc),
    };
