import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/domain/typedefs.dart';

abstract class CalendarState {}

class CalendarInitial extends CalendarState {}

class CalendarLoading extends CalendarState {}

class CalendarLoaded extends CalendarState {
  final CalendarConfirmedReservations reservations;

  CalendarLoaded(this.reservations);
}

class CalendarReload extends CalendarState {}

class CalendarError extends CalendarState {
  final Failure failure;

  CalendarError(this.failure);
}
