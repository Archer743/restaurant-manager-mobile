import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/domain/entities/reservation_preview.dart';

/// Represents confirmed reservations grouped by `dayKey`
typedef CalendarConfirmedReservations = Map<DateTime, List<ReservationPreview>>;
