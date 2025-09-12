import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_manager_app/core/data/models/table_availability_model.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/data/models/shift_view_model.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/domain/entities/floor_plan_view.dart';

part 'floor_plan_view_model.g.dart';

@JsonSerializable()
class FloorPlanViewModel {
  final List<TableAvailabilityModel> tables;
  final List<ShiftViewModel>? shifts;
  final int? selectedShiftIndex;

  FloorPlanViewModel({
    required this.tables,
    this.shifts,
    this.selectedShiftIndex,
  });

  FloorPlanView getEntity() {
    return FloorPlanView(
      tables: tables,
      shifts: shifts,
      selectedShiftIndex: selectedShiftIndex,
    );
  }

  factory FloorPlanViewModel.fromJson(Map<String, dynamic> json) =>
      _$FloorPlanViewModelFromJson(json);
}
