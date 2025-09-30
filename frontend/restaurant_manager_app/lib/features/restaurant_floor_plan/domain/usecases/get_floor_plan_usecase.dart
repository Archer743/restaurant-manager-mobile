import 'package:dartz/dartz.dart';
import 'package:restaurant_manager_app/core/domain/usecases/usecase.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/core/utils/datetime_utils.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/domain/entities/floor_plan_view.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/domain/repository/floor_plan_repository.dart';

class GetFloorPlanUseCase
    implements UseCase<Either<Failure, FloorPlanView>, GetFloorPlanParams> {
  final FloorPlanRepository _floorPlanRepository;

  GetFloorPlanUseCase(this._floorPlanRepository);

  @override
  Future<Either<Failure, FloorPlanView>> call(GetFloorPlanParams params) async {
    return await _floorPlanRepository.getRestaurantFloorPlan(
      params.date.toYYYYMMDDString(),
      params.shiftId,
    );
  }
}

class GetFloorPlanParams {
  final DateTime date;
  final String? shiftId;

  GetFloorPlanParams({required this.date, this.shiftId});
}
