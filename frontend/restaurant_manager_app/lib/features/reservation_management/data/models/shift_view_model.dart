import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_manager_app/features/reservation_management/data/models/table_availability_model.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/shift_view.dart';

part 'shift_view_model.g.dart';

@JsonSerializable()
class ShiftViewModel {
  final List<TableAvailabilityModel> tables;

  ShiftViewModel({
    required this.tables,
  });

  ShiftView getEntity() {
    return ShiftView(tables: tables);
  }

  factory ShiftViewModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftViewModelFromJson(json);
}
