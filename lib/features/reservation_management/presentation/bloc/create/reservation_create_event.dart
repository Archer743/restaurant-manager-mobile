import '../../../domain/requests/create_reservation_request.dart';
import '../../../domain/entities/reservation_create.dart';

abstract class ReservationCreateEvent {}

class CreateReservation extends ReservationCreateEvent {
  final ReservationCreate reservation;

  CreateReservation(CreateReservationRequest request)
      : reservation = request.toEntity();
}
