class ReservationView {
  final String id;
  final String tag;
  final String name;
  final String email;
  final String phone;
  final DateTime startTimeUtc;
  final int peopleCount;
  final String? comment;
  final bool isCreatedByStaff;

  ReservationView({
    required this.id,
    required this.tag,
    required this.name,
    required this.email,
    required this.phone,
    required this.startTimeUtc,
    required this.peopleCount,
    required this.isCreatedByStaff,
    this.comment,
  });
}
