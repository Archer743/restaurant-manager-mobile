import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/core/domain/entities/table_availability.dart';

class ReservationShiftView {
  final String name;
  final TimeOfDay startTime; // Local time
  final TimeOfDay endTime; // Local time
  final List<TableAvailability> tables;

  ReservationShiftView({
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.tables,
  });
}
