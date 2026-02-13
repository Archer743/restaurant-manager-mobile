class ReservationCreate {
  final String name;
  final DateTime startUtc;
  final int peopleCount;
  final String? email;
  final String? phone;
  final String? comment;

  ReservationCreate({
    required this.name,
    required this.startUtc,
    required this.peopleCount,
    required this.email,
    required this.phone,
    required this.comment,
  });
}
