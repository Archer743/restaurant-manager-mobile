abstract class ReservationTablesEvent {}

class GetTablesAvailability extends ReservationTablesEvent {
  final String reservationId;
  GetTablesAvailability(this.reservationId);
}

class ToggleTableSelection extends ReservationTablesEvent {
  final String tableId;
  ToggleTableSelection(this.tableId);
}

class SaveTablesSelection extends ReservationTablesEvent {
  final String reservationId;
  SaveTablesSelection(this.reservationId);
}
