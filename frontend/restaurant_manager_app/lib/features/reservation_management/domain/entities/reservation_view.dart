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
  final bool isClosed;

  ReservationView({
    required this.id,
    required this.tag,
    required this.name,
    required this.email,
    required this.phone,
    required this.startTimeUtc,
    required this.peopleCount,
    required this.isCreatedByStaff,
    required this.isClosed,
    this.comment,
  });

  ReservationView copyWith({
    String? id,
    String? tag,
    String? name,
    String? email,
    String? phone,
    DateTime? startTimeUtc,
    int? peopleCount,
    String? comment,
    bool? isCreatedByStaff,
    bool? isClosed,
  }) {
    return ReservationView(
      id: id ?? this.id,
      tag: tag ?? this.tag,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      startTimeUtc: startTimeUtc ?? this.startTimeUtc,
      peopleCount: peopleCount ?? this.peopleCount,
      comment: comment ?? this.comment,
      isCreatedByStaff: isCreatedByStaff ?? this.isCreatedByStaff,
      isClosed: isClosed ?? this.isClosed,
    );
  }
}
