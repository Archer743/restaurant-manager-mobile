import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/data/models/reservation_preview_model.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/domain/entities/reservation_preview.dart';

/// Represents the raw API response structure for confirmed reservations,
/// where date strings are the keys.
typedef ApiConfirmedReservationsMap
    = Map<String, List<ReservationPreviewModel>>;

/// Represents confirmed reservations structured for the calendar display,
/// with DateTime objects as keys and domain entities as values.
typedef CalendarConfirmedReservations = Map<DateTime, List<ReservationPreview>>;

/// Represents cached confirmed reservations where the key is first day of month
typedef CachedConfirmedReservations
    = Map<DateTime, CalendarConfirmedReservations>;
