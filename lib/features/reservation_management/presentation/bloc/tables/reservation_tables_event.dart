abstract class ReservationTablesEvent {}

class GetTablesAvailability extends ReservationTablesEvent {
  final String reservationId;
  GetTablesAvailability(this.reservationId);
}

class ToggleTableSelection extends ReservationTablesEvent {
  final String tableId;
  ToggleTableSelection(this.tableId);
}

class SaveTableSelection extends ReservationTablesEvent {
  final String reservationId;
  SaveTableSelection(this.reservationId);
}

class ReservationClosedEvent extends ReservationTablesEvent {}
