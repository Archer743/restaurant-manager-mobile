import "../entities/utc_range.dart";

class CalendarDateUtils {
  static DateTime normalizeDate(DateTime date) {
    return DateTime.utc(date.year, date.month, date.day);
  }

  static DateTime getMonthKey(DateTime date) {
    return DateTime.utc(date.year, date.month, 1);
  }

  static UtcRange getUtcMonthRange(DateTime focusedDay) {
    final year = focusedDay.year;
    final month = focusedDay.month;

    final startLocal = DateTime(year, month, 1);
    final endLocal = DateTime(year, month + 1, 1);

    return UtcRange(
      startUtc: startLocal.toUtc(),
      endUtc: endLocal.toUtc(),
    );
  }
}
