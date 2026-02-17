import '../../domain/entities/utc_range.dart';
import '../../domain/utils/calendar_date_utils.dart';

abstract class CalendarEvent {}

class GetReservationsForMonth extends CalendarEvent {
  late final DateTime monthKey;
  late final UtcRange utcRange;

  GetReservationsForMonth(DateTime focusedDay) {
    monthKey = CalendarDateUtils.normalizeDate(
      DateTime(focusedDay.year, focusedDay.month, 1),
    );

    utcRange = CalendarDateUtils.getUtcMonthRange(focusedDay);
  }
}

// TODO: Fix the calendar refresh workflow - is this event even needed?
class RefreshCalendar extends CalendarEvent {
  // This list will store the month keys that need refreshing.
  final List<DateTime> affectedMonthKeys;

  // Constructor that takes a list of raw dates (e.g., original and updated reservation dates)
  // and processes them to get unique month start dates.
  RefreshCalendar({required List<DateTime> rawDatesAffected})
      : affectedMonthKeys = _getMonthKeys(rawDatesAffected);

  static List<DateTime> _getMonthKeys(List<DateTime> dates) {
    final Set<DateTime> uniqueMonthsSet = {};

    for (final date in dates) {
      uniqueMonthsSet.add(CalendarDateUtils.normalizeDate(
        DateTime(date.year, date.month, 1),
      ));
    }

    return uniqueMonthsSet.toList();
  }
}
