import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/core/utils/datetime_utils.dart';
import 'package:restaurant_manager_app/core/utils/timeofday_utils.dart';
import '../entities/reservation_view.dart';
import '../entities/reservation_create.dart';
import '../entities/reservation_update.dart';

class ReservationRequest {
  final String name;
  final String dateString;
  final String timeString;
  final String peopleCountString;
  final String email;
  final String phone;
  final String comment;

  ReservationRequest({
    required this.name,
    required this.dateString,
    required this.timeString,
    required this.peopleCountString,
    required this.email,
    required this.phone,
    required this.comment,
  });

  ReservationCreate toCreateEntity() {
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

  ReservationUpdate toUpdateEntity(ReservationView original) {
    final String? newName = name != original.name ? name : null;

    final DateTime localDate = DateTime.parse(dateString);
    final TimeOfDay localTime = parseTimeOfDay(timeString);
    final DateTime startUtc =
        buildUtcDateTimeFromLocalComponents(localDate, localTime);

    final DateTime? newStartUtc =
        startUtc != original.startUtc ? startUtc : null;

    final int? peopleCountInt = int.tryParse(peopleCountString);
    final int? newPeopleCount =
        (peopleCountInt != null && peopleCountInt != original.peopleCount)
            ? peopleCountInt
            : null;

    final String? newEmail = email != original.email ? email : null;
    final String? newPhone = phone != original.phone ? phone : null;

    final String normalizedComment = comment.trim();
    final String? newComment =
        (normalizedComment != (original.comment ?? '').trim())
            ? normalizedComment
            : null;

    return ReservationUpdate(
      name: newName,
      startUtc: newStartUtc,
      peopleCount: newPeopleCount,
      email: newEmail,
      phone: newPhone,
      comment: newComment,
    );
  }
}
