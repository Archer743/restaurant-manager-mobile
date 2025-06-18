import 'package:dartz/dartz.dart';
import 'package:restaurant_manager_app/core/domain/usecases/usecase.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_view.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/repository/reservation_repository.dart';

class GetReservationDetailsUseCase
    implements UseCase<Either<Failure, ReservationView>, String> {
  final ReservationRepository _reservationRepo;

  GetReservationDetailsUseCase(this._reservationRepo);

  @override
  Future<Either<Failure, ReservationView>> call(String id) async {
    return await _reservationRepo.getReservation(id);
  }
}
