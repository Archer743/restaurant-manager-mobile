// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_view_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftViewModel _$ShiftViewModelFromJson(Map<String, dynamic> json) =>
    ShiftViewModel(
      id: json['id'] as String,
      name: json['name'] as String,
      startTime:
          const AppTimeOfDayConverter().fromJson(json['startTime'] as String),
      endTime:
          const AppTimeOfDayConverter().fromJson(json['endTime'] as String),
    );

Map<String, dynamic> _$ShiftViewModelToJson(ShiftViewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'startTime': const AppTimeOfDayConverter().toJson(instance.startTime),
      'endTime': const AppTimeOfDayConverter().toJson(instance.endTime),
    };
