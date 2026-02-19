import 'package:dartz/dartz.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import '../entities/reservation_create.dart';
import '../entities/reservation_tables_update.dart';
import '../entities/reservation_update.dart';
import '../entities/reservation_view.dart';
import '../entities/reservation_shift_view.dart';

abstract class ReservationRepository {
  Future<Either<Failure, void>> createReservation(
      ReservationCreate reservation);

  Future<Either<Failure, ReservationView>> getReservation(String id);

  Future<Either<Failure, ReservationView>> updateReservation(
    String id,
    ReservationUpdate update,
  );

  Future<Either<Failure, void>> removeReservation(String id);

  Future<Either<Failure, void>> closeReservation(String id);

  Future<Either<Failure, void>> reopenReservation(String id);

  Future<Either<Failure, ReservationShiftView>>
      getTablesAvailabilityForReservation(
    String id,
  );

  Future<Either<Failure, ReservationShiftView?>> updateReservationTables(
    String id,
    ReservationTablesUpdate update,
  );
}
