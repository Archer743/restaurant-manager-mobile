// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_reservation_preview_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PendingReservationPreviewModel _$PendingReservationPreviewModelFromJson(
        Map<String, dynamic> json) =>
    PendingReservationPreviewModel(
      id: json['id'] as String,
      name: json['name'] as String,
      startUtc:
          const AppDateTimeUtcConverter().fromJson(json['startUtc'] as String),
      createdAtUtc: const AppDateTimeUtcConverter()
          .fromJson(json['createdAtUtc'] as String),
      peopleCount: (json['peopleCount'] as num).toInt(),
    );

Map<String, dynamic> _$PendingReservationPreviewModelToJson(
        PendingReservationPreviewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'peopleCount': instance.peopleCount,
      'startUtc': const AppDateTimeUtcConverter().toJson(instance.startUtc),
      'createdAtUtc':
          const AppDateTimeUtcConverter().toJson(instance.createdAtUtc),
    };
