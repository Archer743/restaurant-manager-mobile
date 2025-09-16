import 'package:dartz/dartz.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/domain/entities/floor_plan_view.dart';

abstract class FloorPlanRepository {
  Future<Either<Failure, FloorPlanView>> getRestaurantFloorPlan(
      String date, String? shiftId);
}
