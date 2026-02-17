import '../typedefs.dart';

/// A simple in-memory cache for confirmed reservations, grouped by month.
///
/// **Structure:**
/// `Map<MonthKey, Map<DayKey, List<Reservation>>>`
///
/// **The Strategy: "Normalized UTC" Keys**
/// The calendar widget uses UTC internally (e.g., `2026-02-17 00:00Z`) to ensure
/// grid stability. However, users perceive the calendar in **Local Time**.
/// To align the data with the UI, we use "Normalized UTC" keys—UTC objects that
/// act as containers for the user's Local Date components.
///
/// **Key Definitions:**
/// - `monthKey`: The 1st day of the month (Normalized UTC).
/// - `dayKey`: A specific day within that month (Normalized UTC).
///
/// We must determine which "Day Bucket" a reservation belongs to based on the
/// user's wall clock, not the raw server timestamp.
/// 1. **Convert to Local:** Take the UTC event (e.g., `Feb 16, 22:00 UTC`) and
///    convert it to the user's time (e.g., `Feb 17, 00:00 Local`).
/// 2. **Normalize:** Strip the time and force it back to UTC Midnight (`Feb 17, 00:00Z`).
///
/// **Problems Solved:**
/// **The "Midnight Shift":** Without step #1, an event at 11:00 PM Local Time
///     might physically be "Tomorrow" in UTC. Converting to local first ensures
///     the dot appears on "Today", where the user expects it.
///

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
