import 'package:flutter/material.dart';

class ShiftView {
  final String id;
  final String name;
  final TimeOfDay startTime; // Local time
  final TimeOfDay endTime; // Local time

  ShiftView({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
  });
}
