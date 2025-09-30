import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_manager_app/core/data/converters/app_timeofday_converter.dart';
import 'package:restaurant_manager_app/core/data/models/table_availability_model.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_shift_view.dart';

part 'reservation_shift_view_model.g.dart';

@JsonSerializable()
class ReservationShiftViewModel {
  final String name;

  @AppTimeOfDayConverter()
  final TimeOfDay startTime; // Local time

  @AppTimeOfDayConverter()
  final TimeOfDay endTime; // Local time

  final List<TableAvailabilityModel> tables;

  ReservationShiftViewModel({
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.tables,
  });

  ReservationShiftView getEntity() {
    return ReservationShiftView(
      name: name,
      startTime: startTime,
      endTime: endTime,
      tables: tables,
    );
  }

  factory ReservationShiftViewModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationShiftViewModelFromJson(json);
}
