import '../../../domain/entities/reservation_update.dart';
import '../../../domain/entities/reservation_form_mode.dart';

abstract class ReservationViewEvent {}

abstract class ReservationActionEvent extends ReservationViewEvent {
  final String id;
  ReservationActionEvent(this.id);
}

class GetReservation extends ReservationActionEvent {
  GetReservation(super.id);
}

class UpdateReservation extends ReservationActionEvent {
  final ReservationUpdate update;

  UpdateReservation(super.id, this.update);
}

class RemoveReservation extends ReservationActionEvent {
  RemoveReservation(super.id);
}

class CloseReservation extends ReservationActionEvent {
  CloseReservation(super.id);
}

class ReopenReservation extends ReservationActionEvent {
  ReopenReservation(super.id);
}

class ChangeDisplayMode extends ReservationViewEvent {
  final ReservationFormMode displayMode;
  ChangeDisplayMode(this.displayMode);
}

class CommitReservationChanges extends ReservationViewEvent {}
