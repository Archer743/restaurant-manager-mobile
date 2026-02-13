class ReservationUpdate {
  final String? name;
  final String? email;
  final String? phone;
  final DateTime? startUtc;
  final int? peopleCount;
  final String? comment;

  ReservationUpdate({
    this.name,
    this.email,
    this.phone,
    this.startUtc,
    this.peopleCount,
    this.comment,
  });
}
