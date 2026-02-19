import '../../domain/entities/utc_range.dart';
import '../../domain/utils/calendar_date_utils.dart';

abstract class CalendarEvent {}

class GetReservationsForMonth extends CalendarEvent {
  final DateTime focusedDay;
  late final DateTime monthKey;
  late final UtcRange utcRange;

  GetReservationsForMonth(this.focusedDay)
      : monthKey = CalendarDateUtils.getMonthKey(focusedDay),
        utcRange = CalendarDateUtils.getUtcMonthRange(focusedDay);
}

class RefreshCalendar extends CalendarEvent {
  final Set<DateTime> affectedMonthKeys;

  RefreshCalendar({required List<DateTime> rawDatesAffected})
      : affectedMonthKeys = _getMonthKeys(rawDatesAffected);

  static Set<DateTime> _getMonthKeys(List<DateTime> dates) {
    final Set<DateTime> uniqueMonthKeys = {};

    for (var date in dates) {
      if (date.isUtc) date = date.toLocal();
      final monthKey = CalendarDateUtils.getMonthKey(date);
      uniqueMonthKeys.add(monthKey);
    }

    return uniqueMonthKeys;
  }
}
