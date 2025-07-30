import 'package:dartz/dartz.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_create.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_tables_update.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_update.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_view.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/shift_view.dart';

abstract class ReservationRepository {
  Future<Either<Failure, void>> createReservation(ReservationCreate data);

  Future<Either<Failure, ReservationView>> getReservation(String id);

  Future<Either<Failure, ReservationView>> updateReservation(
    String id,
    ReservationUpdate update,
  );

  Future<Either<Failure, ShiftView>> getTablesAvailabilityForReservation(
    String id,
  );

  Future<Either<Failure, ShiftView?>> updateReservationTables(
    String id,
    ReservationTablesUpdate update,
  );
}
