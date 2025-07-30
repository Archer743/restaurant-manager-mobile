class ReservationUpdate {
  final String? name;
  final String? email;
  final String? phone;
  final DateTime? startTimeUtc;
  final int? peopleCount;
  final String? comment;

  ReservationUpdate({
    this.name,
    this.email,
    this.phone,
    this.startTimeUtc,
    this.peopleCount,
    this.comment,
  });

  /// Returns true if there is at least one field being changed.
  bool get hasChanges {
    return name != null ||
        email != null ||
        phone != null ||
        startTimeUtc != null ||
        peopleCount != null ||
        comment != null;
  }
}
