import 'package:dartz/dartz.dart';
import 'package:restaurant_manager_app/core/domain/usecases/usecase.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_tables_update.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_shift_view.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/repository/reservation_repository.dart';

class UpdateReservationTablesUseCase
    implements
        UseCase<Either<Failure, ReservationShiftView?>, UpdateTablesParams> {
  final ReservationRepository _reservationRepo;

  UpdateReservationTablesUseCase(this._reservationRepo);

  @override
  Future<Either<Failure, ReservationShiftView?>> call(
      UpdateTablesParams params) async {
    return await _reservationRepo.updateReservationTables(
        params.id, params.update);
  }
}

class UpdateTablesParams {
  final String id;
  final ReservationTablesUpdate update;

  UpdateTablesParams({
    required this.id,
    required this.update,
  });
}
