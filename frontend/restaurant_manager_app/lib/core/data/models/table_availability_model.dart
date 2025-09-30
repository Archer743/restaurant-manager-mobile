import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_manager_app/core/domain/entities/table_availability.dart';

part 'table_availability_model.g.dart';

@JsonSerializable()
class TableAvailabilityModel extends TableAvailability {
  TableAvailabilityModel({
    required super.id,
    required super.tableNumber,
    required super.capacity,
    required super.status,
    super.reservationId,
  });

  factory TableAvailabilityModel.fromJson(Map<String, dynamic> json) =>
      _$TableAvailabilityModelFromJson(json);
}
