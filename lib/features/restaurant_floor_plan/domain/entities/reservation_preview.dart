import 'package:flutter/material.dart';

class ReservationPreview {
  final String id;
  final String tag;
  final String name;
  final TimeOfDay time; // Local time
  final int peopleCount;
  final int tableCount;

  ReservationPreview({
    required this.id,
    required this.tag,
    required this.name,
    required this.time,
    required this.peopleCount,
    required this.tableCount,
  });
}
