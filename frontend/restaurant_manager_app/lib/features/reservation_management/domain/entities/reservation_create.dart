class ReservationCreate {
  final String phone;
  final String email;
  final String date;
  final String time;
  final int peopleCount;
  final String name;
  final String? comment;

  ReservationCreate({
    required this.phone,
    required this.email,
    required this.date,
    required this.time,
    required this.peopleCount,
    required this.name,
    required this.comment,
  });
}
