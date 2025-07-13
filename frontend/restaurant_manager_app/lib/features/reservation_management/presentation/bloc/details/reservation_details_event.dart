abstract class ReservationDetailsEvent {}

class GetReservationDetails extends ReservationDetailsEvent {
  final String id;
  GetReservationDetails(this.id);
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
