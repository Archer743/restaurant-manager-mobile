import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/domain/entities/reservation_preview.dart';

abstract class ReservationPreviewState {}

class ReservationPreviewInitial extends ReservationPreviewState {}

class ReservationPreviewLoading extends ReservationPreviewState {}

class ReservationPreviewLoaded extends ReservationPreviewState {
  final ReservationPreview reservationPreview;

  ReservationPreviewLoaded(this.reservationPreview);
}

class ReservationPreviewError extends ReservationPreviewState {
  final Failure failure;

  ReservationPreviewError(this.failure);
}
