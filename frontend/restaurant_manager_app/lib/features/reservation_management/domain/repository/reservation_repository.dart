import 'package:dartz/dartz.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_update.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_view.dart';

abstract class ReservationRepository {
  Future<Either<Failure, ReservationView>> getReservation(String id);

  Future<Either<Failure, ReservationView>> updateReservation(
    String id,
    ReservationUpdate update,
  );
}
