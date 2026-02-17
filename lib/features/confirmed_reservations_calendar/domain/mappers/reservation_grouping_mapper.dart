import '../entities/reservation_preview.dart';
import '../typedefs.dart';
import '../utils/calendar_date_utils.dart';

class ReservationGroupingMapper {
  static CalendarConfirmedReservations groupByDayKey(
    List<ReservationPreview> reservations,
  ) {
    final CalendarConfirmedReservations grouped = {};

    // The reservations are sorted by StartUtc in the backend
    for (final r in reservations) {
      final dayKey = CalendarDateUtils.normalizeDate(r.startLocal);
      grouped.putIfAbsent(dayKey, () => []);
      grouped[dayKey]!.add(r);
    }

    return grouped;
  }
}
