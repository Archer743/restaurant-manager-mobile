abstract class ReservationTablesEvent {}

class GetTablesAvailability extends ReservationTablesEvent {
  final String reservationId;
  GetTablesAvailability(this.reservationId);
}
