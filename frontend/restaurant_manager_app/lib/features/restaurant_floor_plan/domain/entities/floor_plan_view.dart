import 'package:restaurant_manager_app/core/domain/entities/table_availability.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/domain/entities/shift_view.dart';

class FloorPlanView {
  final List<TableAvailability> tables;
  final List<ShiftView>? shifts;
  final int? selectedShiftIndex;

  FloorPlanView({
    required this.tables,
    this.shifts,
    this.selectedShiftIndex,
  });
}
