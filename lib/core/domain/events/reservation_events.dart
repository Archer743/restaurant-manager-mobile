abstract class AppEvent {}

class ReservationsChangedEvent extends AppEvent {
  final List<DateTime> affectedDates;
  ReservationsChangedEvent({required this.affectedDates});
}
