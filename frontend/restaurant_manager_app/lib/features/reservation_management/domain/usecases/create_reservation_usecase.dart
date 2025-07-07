import 'package:dartz/dartz.dart';
import 'package:restaurant_manager_app/core/domain/usecases/usecase.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_create.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/repository/reservation_repository.dart';

class CreateReservationUseCase
    implements UseCase<Either<Failure, void>, ReservationCreate> {
  final ReservationRepository _reservationRepo;

  CreateReservationUseCase(this._reservationRepo);

  @override
  Future<Either<Failure, void>> call(ReservationCreate data) async {
    return await _reservationRepo.createReservation(data);
  }
}
