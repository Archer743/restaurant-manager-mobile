import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_view.dart';

abstract class ReservationDetailsState {}

class ReservationDetailsInitial extends ReservationDetailsState {}

class ReservationDetailsLoading extends ReservationDetailsState {}

class ReservationDetailsLoaded extends ReservationDetailsState {
  final ReservationView reservation;
  ReservationDetailsLoaded(this.reservation);
}

class ReservationDetailsUpdated extends ReservationDetailsLoaded {
  final DateTime originalStartTimeUtc;

  ReservationDetailsUpdated(super.reservation, this.originalStartTimeUtc);
}

class ReservationRemoved extends ReservationDetailsState {}

class ReservationDetailsError extends ReservationDetailsState {
  final Failure failure;
  final ReservationView? originalReservation;

  bool get hasReservation {
    return originalReservation != null;
  }

  ReservationDetailsError(this.failure, [this.originalReservation]);
}
