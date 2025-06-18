class ReservationView {
  final String id;
  final String phone;
  final String email;
  final DateTime date;
  final String time;
  final int peopleCount;
  final String name;
  final String? comment;

  ReservationView({
    required this.id,
    required this.phone,
    required this.email,
    required this.date,
    required this.time,
    required this.peopleCount,
    required this.name,
    this.comment,
  });
}
