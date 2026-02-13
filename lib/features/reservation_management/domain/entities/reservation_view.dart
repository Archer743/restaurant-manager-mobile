class ReservationView {
  final String id;
  final String tag;
  final String name;
  final DateTime startUtc;
  final int peopleCount;
  final String? email;
  final String? phone;
  final String? comment;
  final bool isCreatedByStaff;
  final bool isClosed;

  ReservationView({
    required this.id,
    required this.tag,
    required this.name,
    required this.startUtc,
    required this.peopleCount,
    required this.isCreatedByStaff,
    required this.isClosed,
    this.email,
    this.phone,
    this.comment,
  });

  ReservationView copyWith({
    String? id,
    String? tag,
    String? name,
    String? email,
    String? phone,
    DateTime? startUtc,
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
      startUtc: startUtc ?? this.startUtc,
      peopleCount: peopleCount ?? this.peopleCount,
      comment: comment ?? this.comment,
      isCreatedByStaff: isCreatedByStaff ?? this.isCreatedByStaff,
      isClosed: isClosed ?? this.isClosed,
    );
  }
}
