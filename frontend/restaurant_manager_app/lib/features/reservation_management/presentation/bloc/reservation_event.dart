import 'package:restaurant_manager_app/core/data/converters/app_dateonly_converter.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_update.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_view.dart';

abstract class ReservationEvent {}

class GetReservation extends ReservationEvent {
  final String id;

  GetReservation(this.id);
}

class UpdateReservation extends ReservationEvent {
  late final String id;
  late final ReservationUpdate update;

  UpdateReservation({
    required ReservationView originalReservation,
    required String dateString,
    required String timeString,
    required String peopleCountString,
    required String commentString,
  }) {
    id = originalReservation.id;
    update = _buildUpdate(
      originalReservation,
      dateString,
      timeString,
      peopleCountString,
      commentString,
    );
  }

  /// Returns true if there is at least one field being changed.
  bool get hasChanges {
    return update.date != null ||
        update.time != null ||
        update.peopleCount != null ||
        update.comment != null;
  }

  static ReservationUpdate _buildUpdate(
    ReservationView original,
    String dateString,
    String timeString,
    String peopleCountString,
    String commentString,
  ) {
    const dateOnlyConverter = AppDateOnlyConverter();

    final String? date = dateString != dateOnlyConverter.toJson(original.date)
        ? dateString
        : null;

    final String? time = timeString != original.time ? timeString : null;

    final int? peopleCountInt = int.tryParse(peopleCountString);
    final int? peopleCount =
        (peopleCountInt != null && peopleCountInt != original.peopleCount)
            ? peopleCountInt
            : null;

    final String normalizedComment = commentString.trim();
    final String? comment =
        (normalizedComment != (original.comment ?? '').trim())
            ? normalizedComment
            : null;

    return ReservationUpdate(
      date: date,
      time: time,
      peopleCount: peopleCount,
      comment: comment,
    );
  }
}
