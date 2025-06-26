class ReservationCreate {
  final String name;
  final String email;
  final String phone;
  final DateTime startTimeUtc;
  final int peopleCount;
  final String? comment;

  ReservationCreate({
    required this.phone,
    required this.email,
    required this.startTimeUtc,
    required this.peopleCount,
    required this.name,
    required this.comment,
  });
}
