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
}
