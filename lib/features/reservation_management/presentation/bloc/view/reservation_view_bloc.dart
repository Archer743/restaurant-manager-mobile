import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_manager_app/core/constants/error_codes.dart';
import 'package:restaurant_manager_app/core/domain/events/app_event_bus.dart';
import 'package:restaurant_manager_app/core/domain/events/reservation_events.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/core/utils/future_utils.dart';
import '../../../domain/usecases/get_reservation_usecase.dart';
import '../../../domain/usecases/update_reservation_usecase.dart';
import '../../../domain/usecases/remove_reservation_usecase.dart';
import '../../../domain/usecases/close_reservation_usecase.dart';
import '../../../domain/usecases/reopen_reservation_usecase.dart';
import 'reservation_view_event.dart';
import 'reservation_view_state.dart';

class ReservationViewBloc
    extends Bloc<ReservationViewEvent, ReservationViewState> {
  final AppEventBus _eventBus;
  final Set<DateTime> _affectedDates = {};

  final GetReservationUseCase _getReservationUseCase;
  final UpdateReservationUseCase _updateReservationUseCase;
  final RemoveReservationUseCase _removeReservationUseCase;
  final CloseReservationUseCase _closeReservationUseCase;
  final ReopenReservationUseCase _reopenReservationUseCase;

  ReservationViewBloc(
    this._eventBus,
    this._getReservationUseCase,
    this._updateReservationUseCase,
    this._removeReservationUseCase,
    this._closeReservationUseCase,
    this._reopenReservationUseCase,
  ) : super(const ReservationViewState()) {
    on<GetReservation>(_onGetReservation);
    on<UpdateReservation>(_onUpdateReservation);
    on<RemoveReservation>(_onRemoveReservation);
    on<CloseReservation>(_onCloseReservation);
    on<ReopenReservation>(_onReopenReservation);
    on<ChangeDisplayMode>(_onChangeDisplayMode);
    on<CommitReservationChanges>(_onCommitReservationChanges);
  }

  Future<void> _onGetReservation(
      GetReservation event, Emitter<ReservationViewState> emit) async {
    emit(state.copyWith(status: ReservationViewStatus.loading));

    final result = await minDelayRun(
      _getReservationUseCase(event.id),
      minimumDelay: const Duration(milliseconds: 500),
    );

    if (isClosed) return;
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: ReservationViewStatus.error,
          failure: failure,
        ));
      },
      (reservation) {
        emit(state.copyWith(
          status: ReservationViewStatus.loaded,
          reservation: reservation,
          failure: null,
        ));
      },
    );
  }

  Future<void> _onUpdateReservation(
      UpdateReservation event, Emitter<ReservationViewState> emit) async {
    emit(state.copyWith(status: ReservationViewStatus.loading));

    final result = await minDelayRun(
      _updateReservationUseCase(
        UpdateReservationParams(id: event.id, update: event.update),
      ),
      minimumDelay: const Duration(milliseconds: 250),
    );

    if (isClosed) return;
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: ReservationViewStatus.error,
          failure: failure,
        ));
      },
      (reservation) {
        // Add the original startUtc (when this is the first update)
        if (_affectedDates.isEmpty && state.hasReservation) {
          _affectedDates.add(state.reservation!.startUtc);
        }

        _affectedDates.add(reservation.startUtc);

        emit(state.copyWith(
          status: ReservationViewStatus.updated,
          reservation: reservation,
          failure: null,
        ));
      },
    );
  }

  Future<void> _onRemoveReservation(
      RemoveReservation event, Emitter<ReservationViewState> emit) async {
    if (!state.hasReservation) return;

    emit(state.copyWith(status: ReservationViewStatus.loading));

    final result = await minDelayRun(
      _removeReservationUseCase(event.id),
      minimumDelay: const Duration(milliseconds: 500),
    );

    if (isClosed) return;
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: ReservationViewStatus.error,
          failure: failure,
        ));
      },
      (_) {
        _affectedDates.add(state.reservation!.startUtc);

        emit(state.copyWith(
          status: ReservationViewStatus.removed,
          failure: null,
        ));

        add(CommitReservationChanges());
      },
    );
  }

  Future<void> _onCloseReservation(
      CloseReservation event, Emitter<ReservationViewState> emit) async {
    if (!state.hasReservation) return;

    var original = state.reservation!;
    final updated = original.copyWith(isClosed: true);

    emit(state.copyWith(status: ReservationViewStatus.loading));

    final result = await minDelayRun(
      _closeReservationUseCase(event.id),
      minimumDelay: const Duration(milliseconds: 250),
    );

    if (isClosed) return;
    result.fold(
      (failure) {
        final bool shouldSync = failure is ServerFailure &&
            failure.errorCode == ErrorCodes.reservationAlreadyClosed;

        if (shouldSync) {
          _affectedDates.add(original.startUtc);
          // TODO: should inform ReservationTablesBloc
        }

        emit(state.copyWith(
          status: ReservationViewStatus.error,
          reservation: shouldSync ? updated : original,
          failure: failure,
        ));
      },
      (_) {
        _affectedDates.add(original.startUtc);
        // TODO: Should inform ReservationTablesBloc

        emit(state.copyWith(
          status: ReservationViewStatus.closed,
          reservation: updated,
          failure: null,
        ));
      },
    );
  }

  Future<void> _onReopenReservation(
      ReopenReservation event, Emitter<ReservationViewState> emit) async {
    if (!state.hasReservation) return;

    var original = state.reservation!;
    final updated = original.copyWith(isClosed: false);

    emit(state.copyWith(status: ReservationViewStatus.loading));

    final result = await minDelayRun(
      _reopenReservationUseCase(event.id),
      minimumDelay: const Duration(milliseconds: 250),
    );

    if (isClosed) return;
    result.fold(
      (failure) {
        final bool shouldSync = failure is ServerFailure &&
            failure.errorCode == ErrorCodes.reservationAlreadyActive;

        if (shouldSync) {
          _affectedDates.add(original.startUtc);
          // TODO: should inform ReservationTablesBloc
        }

        emit(state.copyWith(
          status: ReservationViewStatus.error,
          reservation: shouldSync ? updated : original,
          failure: failure,
        ));
      },
      (_) {
        _affectedDates.add(original.startUtc);
        // TODO: Should inform ReservationTablesBloc

        emit(state.copyWith(
          status: ReservationViewStatus.reopened,
          reservation: updated,
          failure: null,
        ));
      },
    );
  }

  Future<void> _onChangeDisplayMode(
      ChangeDisplayMode event, Emitter<ReservationViewState> emit) async {
    emit(state.copyWith(displayMode: event.displayMode));
  }

  Future<void> _onCommitReservationChanges(CommitReservationChanges event,
      Emitter<ReservationViewState> emit) async {
    if (_affectedDates.isNotEmpty) {
      // Inform all listeners that this reservation has been changed
      _eventBus.fire(
        ReservationsChangedEvent(affectedDates: _affectedDates.toList()),
      );

      _affectedDates.clear();
    }

    emit(state.copyWith(status: ReservationViewStatus.readyToPop));
  }
}
