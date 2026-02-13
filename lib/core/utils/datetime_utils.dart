import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Converts a local [DateTime] object to a UTC [DateTime] object,
/// and then formats it as an ISO 8601 string, suitable for API submission.
String convertLocalToUtcIsoString(DateTime localDateTime) {
  DateTime utcDateTime = localDateTime.toUtc();
  return utcDateTime.toIso8601String();
}

/// Extract local date and time components from a UTC DateTime object
(DateTime date, TimeOfDay time) extractLocalComponentsFromUtc(
  DateTime utcDateTime,
) {
  // Convert the UTC DateTime to the device's local time
  final DateTime localDateTime = utcDateTime.toLocal();

  // Extract just the date part (year, month, day, with time set to 00:00:00).
  DateTime datePart = DateTime(
    localDateTime.year,
    localDateTime.month,
    localDateTime.day,
  );

  // Extract just the time part as a TimeOfDay object.
  TimeOfDay timePart = TimeOfDay.fromDateTime(localDateTime);

  return (datePart, timePart);
}

/// Combine local date and time components into a single UTC DateTime object
DateTime buildUtcDateTimeFromLocalComponents(
    DateTime localDate, TimeOfDay localTime) {
  // 1. Combine local date and time into a single local DateTime object
  DateTime localCombinedDateTime = DateTime(
    localDate.year,
    localDate.month,
    localDate.day,
    localTime.hour,
    localTime.minute,
  );

  // 2. Convert the combined local DateTime to UTC
  return localCombinedDateTime.toUtc();
}

extension DateTimeFormatter on DateTime {
  String toBulgarianDateString() {
    return DateFormat.yMMMMd('bg').format(this); // e.g., 17 юни 2025
  }

  /// Format a DateTime object to a 'yyyy-MM-dd' string
  String toYYYYMMDDString() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  /// Format a DateTime object to a 'dd.MM.yyyy' string
  String toDDMMYYYYString() {
    return DateFormat('dd.MM.yyyy').format(this);
  }

  /// Used for local time
  String toSmartBulgarianDateString() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    final localDateTime = toLocal();
    final objectDate =
        DateTime(localDateTime.year, localDateTime.month, localDateTime.day);

    if (objectDate == today) {
      return 'Днес';
    } else if (objectDate == tomorrow) {
      return 'Утре';
    } else {
      final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
      final endOfWeek = startOfWeek.add(const Duration(days: 6));

      if (objectDate.isAfter(today) &&
          objectDate.isBefore(endOfWeek.add(const Duration(days: 1)))) {
        // This week
        return DateFormat.E('bg_BG').format(this);
      } else if (objectDate.year == today.year) {
        // This year
        return DateFormat('dd MMM', 'bg_BG').format(this);
      } else {
        // Different year
        return DateFormat('dd.MM.yyyy', 'bg').format(this);
      }
    }
  }
}
