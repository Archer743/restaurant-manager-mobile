// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'floor_plan_view_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FloorPlanViewModel _$FloorPlanViewModelFromJson(Map<String, dynamic> json) =>
    FloorPlanViewModel(
      tables: (json['tables'] as List<dynamic>)
          .map(
              (e) => TableAvailabilityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      shifts: (json['shifts'] as List<dynamic>?)
          ?.map((e) => ShiftViewModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      selectedShiftIndex: (json['selectedShiftIndex'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FloorPlanViewModelToJson(FloorPlanViewModel instance) =>
    <String, dynamic>{
      'tables': instance.tables,
      'shifts': instance.shifts,
      'selectedShiftIndex': instance.selectedShiftIndex,
    };
