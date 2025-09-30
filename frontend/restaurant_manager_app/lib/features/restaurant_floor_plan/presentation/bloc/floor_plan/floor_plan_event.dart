abstract class FloorPlanEvent {}

class GetFloorPlan extends FloorPlanEvent {
  final DateTime date; // Local date
  final String? shiftId;

  GetFloorPlan({required this.date, this.shiftId});
}
