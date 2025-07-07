import 'package:restaurant_manager_app/core/utils/datetime_utils.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/domain/entities/date_range.dart';

abstract class CalendarEvent {}

class GetReservationsForMonth extends CalendarEvent {
  late final DateTime monthStart;
  late final DateTime monthEnd;

  GetReservationsForMonth(DateTime focusedDay) {
    monthStart = getFirstDayOfMonth(focusedDay);
    monthEnd = getLastDayOfMonth(focusedDay);
  }

  DateRange toDateRange() {
    return DateRange(startDate: monthStart, endDate: monthEnd);
  }
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
