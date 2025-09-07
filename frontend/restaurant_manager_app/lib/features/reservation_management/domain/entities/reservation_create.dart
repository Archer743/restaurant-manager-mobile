class ReservationCreate {
  final String name;
  final DateTime startTimeUtc;
  final int peopleCount;
  final String? email;
  final String? phone;
  final String? comment;

  ReservationCreate({
    required this.name,
    required this.startTimeUtc,
    required this.peopleCount,
    required this.email,
    required this.phone,
    required this.comment,
  });
}
