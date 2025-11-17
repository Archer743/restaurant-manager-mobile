import 'package:flutter/material.dart';

/// Formats a [TimeOfDay] object into an "hh:mm" string (e.g., "09:05", "14:30").
extension TimeOfDayFormatter on TimeOfDay {
  String toHHMMString() {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  /// Formats the TimeOfDay into an "hh:mm:ss" string, with seconds fixed at "00"
  /// (e.g., "09:30:00"). This format is often used for API communication.
  String toHHMMSSString() {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m:00';
  }
}

TimeOfDay parseTimeOfDay(String? timeString) {
  if (timeString == null || timeString.isEmpty) {
    throw const FormatException("TimeOfDay string cannot be null or empty.");
  }

  final parts = timeString.split(':');

  if (parts.length < 2) {
    throw FormatException(
        "Invalid TimeOfDay format: '$timeString'. Expected 'hh:mm' or 'hh:mm:ss'.");
  }

  // Use tryParse for safer integer conversion
  final int? hour = int.tryParse(parts[0]);
  final int? minute = int.tryParse(parts[1]);

  // Validate parsed values and their range
  if (hour == null ||
      minute == null ||
      hour < 0 ||
      hour > 23 ||
      minute < 0 ||
      minute > 59) {
    throw FormatException(
        "Invalid TimeOfDay values: '$timeString'. Hour or minute out of valid range or not a number.");
  }

  return TimeOfDay(hour: hour, minute: minute);
}
