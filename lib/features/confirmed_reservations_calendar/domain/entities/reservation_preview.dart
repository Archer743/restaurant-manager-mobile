import 'package:flutter/material.dart';

class ReservationPreview {
  final String id;
  final String tag;
  final String name;
  final DateTime startUtc;
  final int peopleCount;
  final bool isClosed;

  ReservationPreview({
    required this.id,
    required this.tag,
    required this.name,
    required this.startUtc,
    required this.peopleCount,
    required this.isClosed,
  });

  DateTime get startLocal => startUtc.toLocal();

  TimeOfDay get startTimeLocal => TimeOfDay.fromDateTime(startLocal);

  DateTime get startDateLocal =>
      DateTime(startLocal.year, startLocal.month, startLocal.day);
}
