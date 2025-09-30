import 'package:dartz/dartz.dart';
import 'package:restaurant_manager_app/core/domain/usecases/usecase.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/domain/entities/reservation_preview.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/domain/repository/floor_plan_repository.dart';

class GetReservationPreviewUseCase
    implements UseCase<Either<Failure, ReservationPreview>, String> {
  final FloorPlanRepository _floorPlanRepository;

  GetReservationPreviewUseCase(this._floorPlanRepository);

  @override
  Future<Either<Failure, ReservationPreview>> call(String reservationId) async {
    return await _floorPlanRepository.getReservationPreview(reservationId);
  }
}
