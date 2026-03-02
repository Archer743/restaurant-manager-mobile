import '../../../domain/requests/reservation_request.dart';
import '../../../domain/entities/reservation_create.dart';

abstract class ReservationCreateEvent {}

class CreateReservation extends ReservationCreateEvent {
  final ReservationCreate reservation;

  CreateReservation(ReservationRequest request)
      : reservation = request.toCreateEntity();
}
