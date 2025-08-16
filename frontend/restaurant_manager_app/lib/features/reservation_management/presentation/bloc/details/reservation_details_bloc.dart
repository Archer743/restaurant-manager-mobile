import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_manager_app/core/utils/datetime_utils.dart';
import 'package:restaurant_manager_app/core/utils/future_utils.dart';
import 'package:restaurant_manager_app/core/utils/timeofday_utils.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_update.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_view.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/usecases/close_reservation_usecase.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/usecases/get_reservation_usecase.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/usecases/remove_reservation_usecase.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/usecases/update_reservation_usecase.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/details/reservation_details_event.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/bloc/details/reservation_details_state.dart';

class ReservationDetailsBloc
    extends Bloc<ReservationDetailsEvent, ReservationDetailsState> {
  final GetReservationUseCase _getReservationUseCase;
  final UpdateReservationUseCase _updateReservationUseCase;
  final RemoveReservationUseCase _removeReservationUseCase;
  final CloseReservationUseCase _closeReservationUseCase;

  ReservationDetailsBloc(
    this._getReservationUseCase,
    this._updateReservationUseCase,
    this._removeReservationUseCase,
    this._closeReservationUseCase,
  ) : super(ReservationDetailsInitial()) {
    on<GetReservationDetails>(_onGetReservationDetails);
    on<UpdateReservationDetails>(_onUpdateReservationDetails);
    on<RemoveReservation>(_onRemoveReservation);
    on<CloseReservation>(_onCloseReservation);
  }

  Future<void> _onGetReservationDetails(
    GetReservationDetails event,
    Emitter<ReservationDetailsState> emit,
  ) async {
    if (isClosed) return;
    emit(ReservationDetailsLoading());

    if (isClosed) return;
    final result = await minDelayRun(
      _getReservationUseCase(event.id),
      minimumDelay: const Duration(milliseconds: 500),
    );

    if (isClosed) return;
    result.fold(
      (failure) => emit(ReservationDetailsError(failure)),
      (reservation) => emit(ReservationDetailsLoaded(reservation)),
    );
  }

  Future<void> _onUpdateReservationDetails(
    UpdateReservationDetails event,
    Emitter<ReservationDetailsState> emit,
  ) async {
    // Needed for retrieving previous version of the reservation in case the update fails
    final currState = state;
    late final ReservationView originalReservation;

    if (currState is ReservationDetailsLoaded) {
      originalReservation = currState.reservation;
    } else if (currState is ReservationDetailsError &&
        currState.hasReservation) {
      originalReservation = currState.originalReservation!;
    } else {
      return;
    }

    final update = _getUpdateFromEvent(event, originalReservation);
    if (!update.hasChanges || isClosed) return;

    emit(ReservationDetailsLoading());

    if (isClosed) return;
    final result = await minDelayRun(
      _updateReservationUseCase(
        UpdateReservationParams(id: originalReservation.id, update: update),
      ),
      minimumDelay: const Duration(milliseconds: 250),
    );

    if (isClosed) return;
    result.fold(
      (failure) => emit(ReservationDetailsError(failure, originalReservation)),
      (reservation) => emit(
        ReservationDetailsUpdated(
            reservation, originalReservation.startTimeUtc),
      ),
    );
  }

  Future<void> _onRemoveReservation(
    RemoveReservation event,
    Emitter<ReservationDetailsState> emit,
  ) async {
    final currState = state;
    late final DateTime affectedDateUtc;

    if (currState is ReservationDetailsLoaded) {
      affectedDateUtc = currState.reservation.startTimeUtc;
    } else if (currState is ReservationDetailsError &&
        currState.hasReservation) {
      affectedDateUtc = currState.originalReservation!.startTimeUtc;
    } else {
      return;
    }

    emit(ReservationDetailsLoading());

    final result = await minDelayRun(_removeReservationUseCase(event.id));

    result.fold(
      (failure) => emit(ReservationDetailsError(failure)),
      (_) => emit(ReservationRemoved(affectedDateUtc)),
    );
  }

  Future<void> _onCloseReservation(
    CloseReservation event,
    Emitter<ReservationDetailsState> emit,
  ) async {
    final currState = state;
    late final ReservationView currReservation;

    if (currState is ReservationDetailsLoaded) {
      currReservation = currState.reservation;
    } else if (currState is ReservationDetailsError &&
        currState.hasReservation) {
      currReservation = currState.originalReservation!;
    } else {
      return;
    }

    emit(ReservationDetailsLoading());

    final result = await minDelayRun(_closeReservationUseCase(event.id));

    result.fold(
      (failure) => emit(ReservationDetailsError(failure, currReservation)),
      (_) {
        emit(ReservationRemoved(affectedDateUtc));
      },
    );
  }

  ReservationUpdate _getUpdateFromEvent(
      UpdateReservationDetails event, ReservationView original) {
    final String? newName = event.name != original.name ? event.name : null;
    final String? newEmail = event.email != original.email ? event.email : null;
    final String? newPhone = event.phone != original.phone ? event.phone : null;

    final DateTime localDate = DateTime.parse(event.dateString);
    final TimeOfDay localTime = parseTimeOfDay(event.timeString);
    final DateTime startTimeUtc =
        buildUtcDateTimeFromLocalComponents(localDate, localTime);

    final DateTime? newStartTimeUtc =
        startTimeUtc != original.startTimeUtc ? startTimeUtc : null;

    final int? peopleCountInt = int.tryParse(event.peopleCountString);
    final int? newPeopleCount =
        (peopleCountInt != null && peopleCountInt != original.peopleCount)
            ? peopleCountInt
            : null;

    final String normalizedComment = event.commentString.trim();
    final String? newComment =
        (normalizedComment != (original.comment ?? '').trim())
            ? normalizedComment
            : null;

    return ReservationUpdate(
      name: newName,
      email: newEmail,
      phone: newPhone,
      startTimeUtc: newStartTimeUtc,
      peopleCount: newPeopleCount,
      comment: newComment,
    );
  }
}
