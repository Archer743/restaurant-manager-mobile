// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_view_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftViewModel _$ShiftViewModelFromJson(Map<String, dynamic> json) =>
    ShiftViewModel(
      tables: (json['tables'] as List<dynamic>)
          .map(
              (e) => TableAvailabilityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ShiftViewModelToJson(ShiftViewModel instance) =>
    <String, dynamic>{
      'tables': instance.tables,
    };
