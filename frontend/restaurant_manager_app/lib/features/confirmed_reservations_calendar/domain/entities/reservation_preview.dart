class ReservationPreview {
  final String id;
  final String time;
  final int peopleCount;
  final String name;
  final bool isCreatedByStaff;

  ReservationPreview({
    required this.id,
    required this.time,
    required this.peopleCount,
    required this.name,
    required this.isCreatedByStaff,
  });
}
