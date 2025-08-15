import 'package:dartz/dartz.dart';
import 'package:restaurant_manager_app/core/domain/usecases/usecase.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/repository/reservation_repository.dart';

class RemoveReservationUseCase
    implements UseCase<Either<Failure, void>, String> {
  final ReservationRepository _reservationRepo;

  RemoveReservationUseCase(this._reservationRepo);

  @override
  Future<Either<Failure, void>> call(String id) async {
    return await _reservationRepo.removeReservation(id);
  }
}
