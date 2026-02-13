class PendingReservationPreview {
  final String id;
  final String name;
  final DateTime startUtc;
  final DateTime createdAtUtc;
  final int peopleCount;

  PendingReservationPreview({
    required this.id,
    required this.name,
    required this.startUtc,
    required this.createdAtUtc,
    required this.peopleCount,
  });
}
