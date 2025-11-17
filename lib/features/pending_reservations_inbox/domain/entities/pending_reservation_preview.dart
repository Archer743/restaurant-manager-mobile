class PendingReservationPreview {
  final String id;
  final String name;
  final DateTime startTimeUtc;
  final DateTime createdAtUtc;
  final int peopleCount;

  PendingReservationPreview({
    required this.id,
    required this.name,
    required this.startTimeUtc,
    required this.createdAtUtc,
    required this.peopleCount,
  });
}
