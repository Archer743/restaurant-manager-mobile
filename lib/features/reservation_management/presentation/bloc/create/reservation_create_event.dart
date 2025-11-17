abstract class ReservationCreateEvent {}

class CreateReservation extends ReservationCreateEvent {
  final String name;
  final String email;
  final String phone;
  final String dateString;
  final String timeString;
  final String peopleCountString;
  final String comment;

  CreateReservation({
    required this.name,
    required this.email,
    required this.phone,
    required this.dateString,
    required this.timeString,
    required this.peopleCountString,
    required this.comment,
  });
}
