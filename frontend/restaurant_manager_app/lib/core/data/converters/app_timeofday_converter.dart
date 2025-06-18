import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class AppTimeOfDayConverter implements JsonConverter<TimeOfDay, String> {
  const AppTimeOfDayConverter();

  @override
  TimeOfDay fromJson(String json) {
    // Format: hh:mm:ss
    final parts = json.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  @override
  String toJson(TimeOfDay object) {
    final h = object.hour.toString().padLeft(2, '0');
    final m = object.minute.toString().padLeft(2, '0');
    return '$h:$m:00';
  }

  String formatTime(String time) {
    return time.split(':').sublist(0, 2).join(':');
  }
}
