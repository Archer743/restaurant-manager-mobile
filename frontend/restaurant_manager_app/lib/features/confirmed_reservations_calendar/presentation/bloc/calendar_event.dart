import 'package:restaurant_manager_app/core/utils/datetime_utils.dart';

abstract class CalendarEvent {}

class GetReservationsForMonth extends CalendarEvent {
  final DateTime focusedDay;

  GetReservationsForMonth(this.focusedDay);
}

class RefreshCalendar extends CalendarEvent {
  // This list will store the unique first days of the months that need refreshing.
  final List<DateTime> affectedMonths;

  // Constructor that takes a list of raw dates (e.g., original and updated reservation dates)
  // and processes them to get unique month start dates.
  RefreshCalendar({required List<DateTime> rawDatesAffected})
      : affectedMonths = _processDatesToUniqueMonths(rawDatesAffected);

  static List<DateTime> _processDatesToUniqueMonths(List<DateTime> dates) {
    final Set<DateTime> uniqueMonthsSet = {};

    for (final date in dates) {
      uniqueMonthsSet.add(getFirstDayOfMonth(date));
    }

    return uniqueMonthsSet.toList();
  }
}
