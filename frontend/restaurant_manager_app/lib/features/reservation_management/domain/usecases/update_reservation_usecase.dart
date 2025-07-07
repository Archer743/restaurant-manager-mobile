import 'package:dartz/dartz.dart';
import 'package:restaurant_manager_app/core/domain/usecases/usecase.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_update.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_view.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/repository/reservation_repository.dart';

class UpdateReservationUseCase
    implements
        UseCase<Either<Failure, ReservationView>, UpdateReservationParams> {
  final ReservationRepository _reservationRepo;

  UpdateReservationUseCase(this._reservationRepo);

  @override
  Future<Either<Failure, ReservationView>> call(
      UpdateReservationParams params) async {
    return await _reservationRepo.updateReservation(params.id, params.update);
  }
}

class UpdateReservationParams {
  final String id;
  final ReservationUpdate update;

  UpdateReservationParams({
    required this.id,
    required this.update,
  });
}
