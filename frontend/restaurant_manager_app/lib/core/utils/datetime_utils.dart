import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Returns a new [DateTime] object representing the first day of the month
/// for the given [localDate], with time set to midnight (00:00:00).
/// The returned DateTime will be in the local timezone.
DateTime getFirstDayOfMonth(DateTime localDate) {
  return DateTime(localDate.year, localDate.month, 1);
}

/// Returns a new [DateTime] object representing the last day of the month
/// for the given [localDate], with time set to midnight (00:00:00).
/// The returned DateTime will be in the local timezone.
DateTime getLastDayOfMonth(DateTime localDate) {
  return DateTime(localDate.year, localDate.month + 1, 0);
}

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
}
