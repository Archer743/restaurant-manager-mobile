import 'package:dartz/dartz.dart';
import 'package:restaurant_manager_app/core/domain/usecases/usecase.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_shift_view.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/repository/reservation_repository.dart';

class GetTablesAvailabilityForReservationUseCase
    implements UseCase<Either<Failure, ReservationShiftView>, String> {
  final ReservationRepository _reservationRepo;

  GetTablesAvailabilityForReservationUseCase(this._reservationRepo);

  @override
  Future<Either<Failure, ReservationShiftView>> call(String id) async {
    return await _reservationRepo.getTablesAvailabilityForReservation(id);
  }
}
