import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_manager_app/core/utils/future_utils.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/usecases/create_reservation_usecase.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/usecases/get_reservation_details_usecase.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/usecases/update_reservation_usecase.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/reservation_event.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/reservation_state.dart';

class ReservationBloc extends Bloc<ReservationEvent, ReservationState> {
  final GetReservationDetailsUseCase _getReservationDetailsUseCase;
  final CreateReservationUseCase _createReservationUseCase;
  final UpdateReservationUseCase _updateReservationUseCase;

  ReservationBloc(
    this._getReservationDetailsUseCase,
    this._createReservationUseCase,
    this._updateReservationUseCase,
  ) : super(ReservationInitial()) {
    on<GetReservation>(_onGetReservation);
    on<CreateReservation>(_onCreateReservation);
    on<UpdateReservation>(_onUpdateReservation);
  }

  Future<void> _onGetReservation(
    GetReservation event,
    Emitter<ReservationState> emit,
  ) async {
    if (isClosed) return;
    emit(ReservationLoading());

    if (isClosed) return;
    final result = await minDelayRun(
      _getReservationDetailsUseCase(event.id),
      minimumDelay: const Duration(milliseconds: 500),
    );

    if (isClosed) return;
    result.fold(
      (failure) => emit(ReservationError(failure)),
      (reservation) => emit(ReservationLoaded(reservation)),
    );
  }

  Future<void> _onCreateReservation(
    CreateReservation event,
    Emitter<ReservationState> emit,
  ) async {
    if (isClosed) return;
    emit(ReservationLoading());

    if (isClosed) return;
    final result = await minDelayRun(
      _createReservationUseCase(event.data),
      minimumDelay: const Duration(milliseconds: 500),
    );

    if (isClosed) return;
    result.fold(
      (failure) => emit(ReservationError(failure)),
      (_) => emit(ReservationSaved()),
    );
  }

  Future<void> _onUpdateReservation(
    UpdateReservation event,
    Emitter<ReservationState> emit,
  ) async {
    if (!event.hasChanges || isClosed) return;
    emit(ReservationLoading());

    if (isClosed) return;
    final result = await _updateReservationUseCase(
      UpdateReservationParams(id: event.id, update: event.update),
    );

    if (isClosed) return;
    result.fold(
      (failure) => emit(ReservationError(failure)),
      (reservation) =>
          emit(ReservationUpdated(event.originalDate, reservation)),
    );
  }
}
