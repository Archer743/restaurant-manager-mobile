import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/shift_view.dart';

abstract class ReservationTablesState {}

class ReservationTablesInitial extends ReservationTablesState {}

class ReservationTablesLoading extends ReservationTablesState {}

class ReservationTablesLoaded extends ReservationTablesState {
  final ShiftView shiftView;
  ReservationTablesLoaded(this.shiftView);
}

class ReservationTablesError extends ReservationTablesState {
  final Failure failure;
  ReservationTablesError(this.failure);
}
