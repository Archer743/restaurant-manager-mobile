import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_shift_view.dart';

abstract class ReservationTablesState {}

class ReservationTablesInitial extends ReservationTablesState {}

class ReservationTablesLoading extends ReservationTablesState {}

class ReservationTablesLoaded extends ReservationTablesState {
  final ReservationShiftView shiftView;
  final Set<String> selectedTableIds;

  ReservationTablesLoaded(this.shiftView, {this.selectedTableIds = const {}});

  ReservationTablesLoaded copyWith({
    ReservationShiftView? shiftView,
    Set<String>? selectedTableIds,
  }) {
    return ReservationTablesLoaded(
      shiftView ?? this.shiftView,
      selectedTableIds: selectedTableIds ?? this.selectedTableIds,
    );
  }
}

class ReservationTablesUpdated extends ReservationTablesLoaded {
  ReservationTablesUpdated(
    super.shiftView, {
    super.selectedTableIds = const {},
  });
}

class ReservationTablesClosed extends ReservationTablesState {}

class ReservationTablesError extends ReservationTablesState {
  final Failure failure;
  ReservationTablesError(this.failure);
}
