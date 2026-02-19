import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_manager_app/core/utils/future_utils.dart';
import '../../../domain/usecases/create_reservation_usecase.dart';
import 'reservation_create_event.dart';
import 'reservation_create_state.dart';

class ReservationCreateBloc
    extends Bloc<ReservationCreateEvent, ReservationCreateState> {
  final CreateReservationUseCase _usecase;

  ReservationCreateBloc(this._usecase) : super(ReservationInitial()) {
    // droppable - If a request is in progress -> ignore new ones.
    on<CreateReservation>(_onCreateReservation, transformer: droppable());
  }

  Future<void> _onCreateReservation(
    CreateReservation event,
    Emitter<ReservationCreateState> emit,
  ) async {
    emit(ReservationLoading());

    final result = await minDelayRun(
      _usecase(event.reservation),
      minimumDelay: const Duration(milliseconds: 500),
    );

    result.fold(
      (failure) => emit(ReservationError(failure)),
      (_) => emit(ReservationSaved()),
    );
  }
}
