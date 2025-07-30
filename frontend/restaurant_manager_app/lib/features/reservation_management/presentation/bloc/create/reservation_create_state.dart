import 'package:restaurant_manager_app/core/errors/failure.dart';

abstract class ReservationCreateState {}

class ReservationInitial extends ReservationCreateState {}

class ReservationLoading extends ReservationCreateState {}

class ReservationSaved extends ReservationCreateState {}

class ReservationError extends ReservationCreateState {
  final Failure failure;
  ReservationError(this.failure);
}
