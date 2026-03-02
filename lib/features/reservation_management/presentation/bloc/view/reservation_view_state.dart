import 'package:restaurant_manager_app/core/errors/failure.dart';
import '../../../domain/entities/reservation_form_mode.dart';
import '../../../domain/entities/reservation_view.dart';

enum ReservationViewStatus {
  initial,
  loading,
  loaded,
  updated,
  removed,
  closed,
  reopened,
  readyToPop,
  error;

  bool get isLoading => this == ReservationViewStatus.loading;
  bool get isLoaded => this == ReservationViewStatus.loaded;
  bool get isUpdated => this == ReservationViewStatus.updated;
  bool get isRemoved => this == ReservationViewStatus.removed;
  bool get isClosed => this == ReservationViewStatus.closed;
  bool get isReopened => this == ReservationViewStatus.reopened;
  bool get isReadyToPop => this == ReservationViewStatus.readyToPop;
  bool get isError => this == ReservationViewStatus.error;
}

class ReservationViewState {
  final ReservationViewStatus status;
  final ReservationFormMode displayMode;
  final ReservationView? reservation;
  final Failure? failure;

  const ReservationViewState({
    this.status = ReservationViewStatus.initial,
    this.displayMode = ReservationFormMode.view,
    this.reservation,
    this.failure,
  });

  bool get hasReservation => reservation != null;
  bool get hasFailure => failure != null;

  ReservationViewState copyWith({
    ReservationViewStatus? status,
    ReservationFormMode? displayMode,
    ReservationView? reservation,
    Failure? failure,
  }) {
    return ReservationViewState(
      status: status ?? this.status,
      displayMode: displayMode ?? this.displayMode,
      reservation: reservation ?? this.reservation,
      failure: failure,
    );
  }
}
