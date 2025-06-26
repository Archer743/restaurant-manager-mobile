import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/core/utils/datetime_utils.dart';
import 'package:restaurant_manager_app/core/utils/timeofday_utils.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_create.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_update.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_view.dart';

abstract class ReservationEvent {}

class GetReservation extends ReservationEvent {
  final String id;

  GetReservation(this.id);
}

class CreateReservation extends ReservationEvent {
  late final ReservationCreate data;

  CreateReservation({
    required String name,
    required String email,
    required String phone,
    required String dateString,
    required String timeString,
    required String peopleCountString,
    required String comment,
  }) {
    final DateTime date = DateTime.parse(dateString);
    final TimeOfDay time = parseTimeOfDay(timeString);

    data = ReservationCreate(
      name: name,
      email: email,
      phone: phone,
      startTimeUtc: buildUtcDateTimeFromLocalComponents(date, time),
      peopleCount: int.parse(peopleCountString),
      comment: comment,
    );
  }
}

class UpdateReservation extends ReservationEvent {
  late final String id;
  // Used for updating the calendar
  late final DateTime originalStartTimeUtc;
  late final ReservationUpdate update;

  UpdateReservation({
    required ReservationView originalReservation,
    required String name,
    required String email,
    required String phone,
    required String dateString,
    required String timeString,
    required String peopleCountString,
    required String commentString,
  }) {
    id = originalReservation.id;
    originalStartTimeUtc = originalReservation.startTimeUtc;
    update = _buildUpdate(
      originalReservation,
      name,
      email,
      phone,
      dateString,
      timeString,
      peopleCountString,
      commentString,
    );
  }

  /// Returns true if there is at least one field being changed.
  bool get hasChanges {
    return update.name != null ||
        update.email != null ||
        update.phone != null ||
        update.startTimeUtc != null ||
        update.peopleCount != null ||
        update.comment != null;
  }

  static ReservationUpdate _buildUpdate(
    ReservationView original,
    String name,
    String email,
    String phone,
    String dateString,
    String timeString,
    String peopleCountString,
    String commentString,
  ) {
    final String? newName = name != original.name ? name : null;
    final String? newEmail = email != original.email ? email : null;
    final String? newPhone = phone != original.phone ? phone : null;

    final DateTime localDate = DateTime.parse(dateString);
    final TimeOfDay localTime = parseTimeOfDay(timeString);
    final DateTime startTimeUtc =
        buildUtcDateTimeFromLocalComponents(localDate, localTime);

    final DateTime? newStartTimeUtc =
        startTimeUtc != original.startTimeUtc ? startTimeUtc : null;

    final int? peopleCountInt = int.tryParse(peopleCountString);
    final int? newPeopleCount =
        (peopleCountInt != null && peopleCountInt != original.peopleCount)
            ? peopleCountInt
            : null;

    final String normalizedComment = commentString.trim();
    final String? newComment =
        (normalizedComment != (original.comment ?? '').trim())
            ? normalizedComment
            : null;

    return ReservationUpdate(
      name: newName,
      email: newEmail,
      phone: newPhone,
      startTimeUtc: newStartTimeUtc,
      peopleCount: newPeopleCount,
      comment: newComment,
    );
  }
}
