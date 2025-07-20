import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_manager_app/core/utils/future_utils.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/table_availability.dart';
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
    on<ToggleTableSelection>(_onToggleTableSelection);
    on<SaveTablesSelection>(_onSaveTablesSelection);
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

  Future<void> _onToggleTableSelection(
    ToggleTableSelection event,
    Emitter<ReservationTablesState> emit,
  ) async {
    final currState = state;
    if (currState is ReservationTablesLoaded) {
      final selected = Set<String>.from(currState.selectedTableIds);

      if (selected.contains(event.tableId)) {
        selected.remove(event.tableId);
      } else {
        selected.add(event.tableId);
      }
      emit(currState.copyWith(selectedTableIds: selected));
    }
  }

  Future<void> _onSaveTablesSelection(
    SaveTablesSelection event,
    Emitter<ReservationTablesState> emit,
  ) async {
    final currState = state;
    if (currState is ReservationTablesLoaded) {
      final reservedTables = currState.shiftView.tables
          .where((t) => t.status == TableStatus.reservedByCurrent)
          .map((t) => t.id)
          .toSet();

      final selectedTables = currState.selectedTableIds;

      final tablesToAdd = selectedTables.difference(reservedTables);
      final tablesToRemove = selectedTables.intersection(reservedTables);
    }
  }
}
