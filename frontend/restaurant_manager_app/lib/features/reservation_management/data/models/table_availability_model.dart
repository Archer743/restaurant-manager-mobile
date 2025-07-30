import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/table_availability.dart';

part 'table_availability_model.g.dart';

@JsonSerializable()
class TableAvailabilityModel extends TableAvailability {
  TableAvailabilityModel({
    required super.id,
    required super.tableNumber,
    required super.capacity,
    required super.status,
  });

  factory TableAvailabilityModel.fromJson(Map<String, dynamic> json) =>
      _$TableAvailabilityModelFromJson(json);
}
