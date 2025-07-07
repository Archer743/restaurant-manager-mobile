import 'package:flutter/material.dart';

class ReservationPreview {
  final String id;
  final String name;
  final TimeOfDay time; // Local time
  final int peopleCount;
  final bool isCreatedByStaff;

  ReservationPreview({
    required this.id,
    required this.name,
    required this.time,
    required this.peopleCount,
    required this.isCreatedByStaff,
  });
}
