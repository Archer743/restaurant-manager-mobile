// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_view_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationViewModel _$ReservationViewModelFromJson(
        Map<String, dynamic> json) =>
    ReservationViewModel(
      id: json['id'] as String,
      tag: json['tag'] as String,
      name: json['name'] as String,
      startUtc:
          const AppDateTimeUtcConverter().fromJson(json['startUtc'] as String),
      peopleCount: (json['peopleCount'] as num).toInt(),
      isCreatedByStaff: json['isCreatedByStaff'] as bool,
      isClosed: json['isClosed'] as bool,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$ReservationViewModelToJson(
        ReservationViewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tag': instance.tag,
      'name': instance.name,
      'peopleCount': instance.peopleCount,
      'email': instance.email,
      'phone': instance.phone,
      'comment': instance.comment,
      'isCreatedByStaff': instance.isCreatedByStaff,
      'isClosed': instance.isClosed,
      'startUtc': const AppDateTimeUtcConverter().toJson(instance.startUtc),
    };
