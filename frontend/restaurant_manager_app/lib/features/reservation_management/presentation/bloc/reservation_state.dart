import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_view.dart';

abstract class ReservationState {}

class ReservationInitial extends ReservationState {}

class ReservationLoading extends ReservationState {}

class ReservationLoaded extends ReservationState {
  final ReservationView reservation;

  ReservationLoaded(this.reservation);
}

class ReservationUpdated extends ReservationLoaded {
  ReservationUpdated(super.reservation);
}

class ReservationError extends ReservationState {
  final Failure failure;
  late final bool requiresReauthentication;

  ReservationError(this.failure) {
    requiresReauthentication =
        (failure is AuthTokenFailure || failure is InvalidSessionFailure);
  }
}
