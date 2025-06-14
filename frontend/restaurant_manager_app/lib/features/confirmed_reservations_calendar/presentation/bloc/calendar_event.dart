abstract class CalendarEvent {}

class FetchReservationsForMonth extends CalendarEvent {
  final DateTime focusedDay;

  FetchReservationsForMonth(this.focusedDay);
}
