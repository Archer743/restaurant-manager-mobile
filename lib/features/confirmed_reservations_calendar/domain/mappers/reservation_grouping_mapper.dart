import '../entities/reservation_preview.dart';
import '../typedefs.dart';
import '../utils/calendar_date_utils.dart';

class ReservationGroupingMapper {
  static CalendarConfirmedReservations groupByLocalDay(
    List<ReservationPreview> reservations,
  ) {
    final CalendarConfirmedReservations grouped = {};

    for (final r in reservations) {
      final dayKey = CalendarDateUtils.localDayKey(r.startLocal);

      grouped.putIfAbsent(dayKey, () => []);
      grouped[dayKey]!.add(r);
    }

    return grouped;
  }
}
