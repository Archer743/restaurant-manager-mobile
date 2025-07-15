import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_manager_app/core/utils/future_utils.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/usecases/get_tables_availability_for_reservation_usecase.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/tables/reservation_tables_event.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/tables/reservation_tables_state.dart';

class ReservationTablesBloc
    extends Bloc<ReservationTablesEvent, ReservationTablesState> {
  final GetTablesAvailabilityForReservationUseCase
      _getTablesAvailabilityUseCase;

  ReservationTablesBloc(this._getTablesAvailabilityUseCase)
      : super(ReservationTablesInitial()) {
    on<GetTablesAvailability>(_onGetTablesAvailability);
  }

  Future<void> _onGetTablesAvailability(
    GetTablesAvailability event,
    Emitter<ReservationTablesState> emit,
  ) async {
    emit(ReservationTablesLoading());

    final result =
        await minDelayRun(_getTablesAvailabilityUseCase(event.reservationId));

    result.fold(
      (failure) => emit(ReservationTablesError(failure)),
      (shiftView) => emit(ReservationTablesLoaded(shiftView)),
    );
  }
}
