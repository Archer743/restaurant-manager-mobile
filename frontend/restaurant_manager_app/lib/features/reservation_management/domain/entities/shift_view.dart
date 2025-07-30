import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/table_availability.dart';

class ShiftView {
  final String name;
  final TimeOfDay startTime; // Local time
  final TimeOfDay endTime; // Local time
  final List<TableAvailability> tables;

  ShiftView({
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.tables,
  });
}
