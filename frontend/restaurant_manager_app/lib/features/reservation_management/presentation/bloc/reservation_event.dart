import 'package:restaurant_manager_app/core/data/converters/app_dateonly_converter.dart';
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
    data = ReservationCreate(
      name: name,
      email: email,
      phone: phone,
      date: dateString,
      time: timeString,
      peopleCount: int.parse(peopleCountString),
      comment: comment,
    );
  }
}

class UpdateReservation extends ReservationEvent {
  late final String id;
  late final DateTime originalDate; // Used for updating the calendar
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
    originalDate = originalReservation.date;
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
        update.date != null ||
        update.time != null ||
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
    const dateOnlyConverter = AppDateOnlyConverter();

    final String? newName = name != original.name ? name : null;
    final String? newEmail = email != original.email ? email : null;
    final String? newPhone = phone != original.phone ? phone : null;

    final String? newDate =
        dateString != dateOnlyConverter.toJson(original.date)
            ? dateString
            : null;

    final String? newTime = timeString != original.time ? timeString : null;

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
      date: newDate,
      time: newTime,
      peopleCount: newPeopleCount,
      comment: newComment,
    );
  }
}
