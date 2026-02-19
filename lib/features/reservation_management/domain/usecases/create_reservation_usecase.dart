import 'package:dartz/dartz.dart';
import 'package:restaurant_manager_app/core/domain/usecases/usecase.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import '../entities/reservation_create.dart';
import '../repository/reservation_repository.dart';

class CreateReservationUseCase
    implements UseCase<Either<Failure, void>, ReservationCreate> {
  final ReservationRepository _reservationRepo;

  CreateReservationUseCase(this._reservationRepo);

  @override
  Future<Either<Failure, void>> call(ReservationCreate reservation) async {
    return await _reservationRepo.createReservation(reservation);
  }
}
