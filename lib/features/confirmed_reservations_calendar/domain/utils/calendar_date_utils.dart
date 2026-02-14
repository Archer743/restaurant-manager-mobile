import "../entities/utc_range.dart";

class CalendarDateUtils {
  /// Normalizes a local DateTime to a date-only local key.
  static DateTime localDayKey(DateTime local) =>
      DateTime(local.year, local.month, local.day);

  /// Returns first day of month in local time.
  static DateTime localMonthKey(DateTime local) =>
      DateTime(local.year, local.month, 1);

  /// Builds UTC month range from a local focused day.
  static UtcRange utcMonthRangeFromLocal(DateTime focusedLocal) {
    final startLocal = DateTime(focusedLocal.year, focusedLocal.month, 1);
    final endLocal = DateTime(focusedLocal.year, focusedLocal.month + 1, 1);

    return UtcRange(
      startUtc: startLocal.toUtc(),
      endUtc: endLocal.toUtc(),
    );
  }
}
