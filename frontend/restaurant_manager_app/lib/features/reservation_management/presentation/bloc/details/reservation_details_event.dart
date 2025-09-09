abstract class ReservationDetailsEvent {}

abstract class ReservationActionEvent extends ReservationDetailsEvent {
  final String id;
  ReservationActionEvent(this.id);
}

class GetReservationDetails extends ReservationActionEvent {
  GetReservationDetails(super.id);
}

class RemoveReservation extends ReservationActionEvent {
  RemoveReservation(super.id);
}

class CloseReservation extends ReservationActionEvent {
  CloseReservation(super.id);
}

class ReopenReservation extends ReservationActionEvent {
  ReopenReservation(super.id);
}

class UpdateReservationDetails extends ReservationDetailsEvent {
  final String name;
  final String email;
  final String phone;
  final String dateString;
  final String timeString;
  final String peopleCountString;
  final String commentString;

  UpdateReservationDetails({
    required this.name,
    required this.email,
    required this.phone,
    required this.dateString,
    required this.timeString,
    required this.peopleCountString,
    required this.commentString,
  });
}
