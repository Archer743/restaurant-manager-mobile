import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_manager_app/core/data/converters/app_timeofday_converter.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/domain/entities/shift_view.dart';

part 'shift_view_model.g.dart';

@JsonSerializable()
class ShiftViewModel extends ShiftView {
  @override
  @AppTimeOfDayConverter()
  final TimeOfDay startTime; // Local time

  @override
  @AppTimeOfDayConverter()
  final TimeOfDay endTime; // Local time

  ShiftViewModel({
    required super.id,
    required super.name,
    required this.startTime,
    required this.endTime,
  }) : super(startTime: startTime, endTime: endTime);

  factory ShiftViewModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftViewModelFromJson(json);
}
