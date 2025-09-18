import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_manager_app/core/utils/future_utils.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/domain/entities/floor_plan_view.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/domain/usecases/get_floor_plan_usecase.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/presentation/bloc/floor_plan_event.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/presentation/bloc/floor_plan_state.dart';

class FloorPlanBloc extends Bloc<FloorPlanEvent, FloorPlanState> {
  final GetFloorPlanUseCase _getFloorPlanUseCase;

  FloorPlanBloc(this._getFloorPlanUseCase) : super(FloorPlanInitial()) {
    on<GetFloorPlan>(_onGetFloorPlan);
  }

  Future<void> _onGetFloorPlan(
      GetFloorPlan event, Emitter<FloorPlanState> emit) async {
    final currState = state;
    FloorPlanView? originalFloorPlan;

    if (currState is FloorPlanLoaded) {
      originalFloorPlan = currState.floorPlanView;
    } else if (currState is FloorPlanError) {
      originalFloorPlan = currState.floorPlanView;
    }

    emit(FloorPlanLoading());

    final result = await minDelayRun(
      _getFloorPlanUseCase(
          GetFloorPlanParams(date: event.date, shiftId: event.shiftId)),
    );

    result.fold(
      (failure) => emit(
          FloorPlanError(failure: failure, floorPlanView: originalFloorPlan)),
      (floorPlanView) => emit(FloorPlanLoaded(floorPlanView)),
    );
  }
}
