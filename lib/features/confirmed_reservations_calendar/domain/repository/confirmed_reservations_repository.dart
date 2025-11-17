import 'package:dartz/dartz.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/domain/entities/date_range.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/domain/typedefs.dart';

abstract class ConfirmedReservationsRepository {
  /// Returns confirmed reservations for the user's restaurant within the specified date range
  Future<Either<Failure, CalendarConfirmedReservations>>
      getConfirmedReservations(DateRange dateRange);
}
