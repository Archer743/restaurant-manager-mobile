import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_manager_app/core/utils/datetime_utils.dart';
import 'package:restaurant_manager_app/core/utils/future_utils.dart';
import 'package:restaurant_manager_app/core/utils/timeofday_utils.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_create.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/usecases/create_reservation_usecase.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/create/reservation_create_event.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/create/reservation_create_state.dart';

class ReservationCreateBloc
    extends Bloc<ReservationCreateEvent, ReservationCreateState> {
  final CreateReservationUseCase _createReservationUseCase;

  ReservationCreateBloc(
    this._createReservationUseCase,
  ) : super(ReservationInitial()) {
    on<CreateReservation>(_onCreateReservation);
  }

  Future<void> _onCreateReservation(
    CreateReservation event,
    Emitter<ReservationCreateState> emit,
  ) async {
    final reservationData = _getReservationDataFromEvent(event);

    if (isClosed) return;
    emit(ReservationLoading());

    if (isClosed) return;
    final result = await minDelayRun(
      _createReservationUseCase(reservationData),
      minimumDelay: const Duration(milliseconds: 500),
    );

    if (isClosed) return;
    result.fold(
      (failure) => emit(ReservationError(failure)),
      (_) => emit(ReservationSaved()),
    );
  }

  ReservationCreate _getReservationDataFromEvent(CreateReservation event) {
    final DateTime date = DateTime.parse(event.dateString);
    final TimeOfDay time = parseTimeOfDay(event.timeString);

    return ReservationCreate(
      name: event.name,
      email: event.email,
      phone: event.phone,
      startTimeUtc: buildUtcDateTimeFromLocalComponents(date, time),
      peopleCount: int.parse(event.peopleCountString),
      comment: event.comment,
    );
  }
}
