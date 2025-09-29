abstract class ReservationPreviewEvent {}

class GetReservationPreview extends ReservationPreviewEvent {
  final String reservationId;

  GetReservationPreview(this.reservationId);
}

class DismissReservationPreview extends ReservationPreviewEvent {}
