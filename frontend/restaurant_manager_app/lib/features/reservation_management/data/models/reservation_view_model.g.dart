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
      startTimeUtc: const AppDateTimeUtcConverter()
          .fromJson(json['startTimeUtc'] as String),
      peopleCount: (json['peopleCount'] as num).toInt(),
      name: json['name'] as String,
      isCreatedByStaff: json['isCreatedByStaff'] as bool,
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$ReservationViewModelToJson(
        ReservationViewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'peopleCount': instance.peopleCount,
      'comment': instance.comment,
      'isCreatedByStaff': instance.isCreatedByStaff,
      'startTimeUtc':
          const AppDateTimeUtcConverter().toJson(instance.startTimeUtc),
    };
