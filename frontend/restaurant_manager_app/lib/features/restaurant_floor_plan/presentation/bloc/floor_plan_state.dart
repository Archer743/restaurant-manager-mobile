import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/domain/entities/floor_plan_view.dart';

abstract class FloorPlanState {
  bool hasView() => false;
}

class FloorPlanInitial extends FloorPlanState {}

class FloorPlanLoading extends FloorPlanState {}

class FloorPlanLoaded extends FloorPlanState {
  final FloorPlanView floorPlanView;

  FloorPlanLoaded(this.floorPlanView);

  @override
  bool hasView() => true;
}

class FloorPlanError extends FloorPlanState {
  final Failure failure;
  final FloorPlanView? floorPlanView;

  FloorPlanError({required this.failure, this.floorPlanView});

  @override
  bool hasView() => floorPlanView != null;
}
