abstract class CalendarEvent {}

class GetReservationsForMonth extends CalendarEvent {
  final DateTime focusedDay;

  GetReservationsForMonth(this.focusedDay);
}

class RefreshCalendarForReservationUpdate extends CalendarEvent {}
