// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_view_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftViewModel _$ShiftViewModelFromJson(Map<String, dynamic> json) =>
    ShiftViewModel(
      name: json['name'] as String,
      startTime:
          const AppTimeOfDayConverter().fromJson(json['startTime'] as String),
      endTime:
          const AppTimeOfDayConverter().fromJson(json['endTime'] as String),
      tables: (json['tables'] as List<dynamic>)
          .map(
              (e) => TableAvailabilityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ShiftViewModelToJson(ShiftViewModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'startTime': const AppTimeOfDayConverter().toJson(instance.startTime),
      'endTime': const AppTimeOfDayConverter().toJson(instance.endTime),
      'tables': instance.tables,
    };
