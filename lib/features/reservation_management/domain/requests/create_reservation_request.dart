import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/core/utils/datetime_utils.dart';
import 'package:restaurant_manager_app/core/utils/timeofday_utils.dart';
import '../entities/reservation_create.dart';

class CreateReservationRequest {
  final String name;
  final String dateString;
  final String timeString;
  final String peopleCountString;
  final String email;
  final String phone;
  final String comment;

  CreateReservationRequest({
    required this.name,
    required this.dateString,
    required this.timeString,
    required this.peopleCountString,
    required this.email,
    required this.phone,
    required this.comment,
  });

  ReservationCreate toEntity() {
    final DateTime date = DateTime.parse(dateString);
    final TimeOfDay time = parseTimeOfDay(timeString);

    final email = this.email.isEmpty ? null : this.email;
    final phone = this.phone.isEmpty ? null : this.phone;

    final normalizedComment = this.comment.trim();
    final comment = normalizedComment.isEmpty ? null : normalizedComment;

    return ReservationCreate(
      name: name,
      startUtc: buildUtcDateTimeFromLocalComponents(date, time),
      peopleCount: int.parse(peopleCountString),
      email: email,
      phone: phone,
      comment: comment,
    );
  }
}
