import '../typedefs.dart';

/// A simple in-memory cache for confirmed reservations, grouped by month.
///
/// The cache stores reservations per month (`monthKey`) where each month's
/// value is a `CalendarConfirmedReservations` map. That inner map is itself
/// keyed by `dayKey`, and contains the list of reservations for that day.
///
/// Key concepts:
/// - `monthKey`: the first day of a month in local time (date-only).
///   Example: February 2026 -> DateTime(2026, 2, 1)
///
/// - `dayKey`: a normalized local date representing a specific day within
///   a month. Example: February 15, 2026 -> DateTime(2026, 2, 15)
///   Used inside the `CalendarConfirmedReservations` map to group reservations
///   per day.

class MonthReservationsCache {
  /// How long a month's cached data is considered fresh - ttl (Time-To-Live)
  final Duration ttl;

  final Map<DateTime, CalendarConfirmedReservations> _data = {};

  /// Tracks expiry per monthKey.
  final Map<DateTime, DateTime> _expiry = {};

  MonthReservationsCache({required this.ttl});

  CalendarConfirmedReservations? get(DateTime monthKey) {
    return _data[monthKey];
  }

  bool isFresh(DateTime monthKey) {
    final expiry = _expiry[monthKey];
    if (expiry == null) return false;
    return DateTime.now().isBefore(expiry);
  }

  void put(
    DateTime monthKey,
    CalendarConfirmedReservations reservations,
  ) {
    _data[monthKey] = reservations;
    _expiry[monthKey] = DateTime.now().add(ttl);
  }

  bool expire(DateTime monthKey) {
    if (_expiry.containsKey(monthKey)) {
      _expiry[monthKey] = DateTime.now();
      return true;
    }

    return false;
  }
}
