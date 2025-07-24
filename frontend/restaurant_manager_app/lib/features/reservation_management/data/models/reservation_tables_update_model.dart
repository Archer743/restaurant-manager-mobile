import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_tables_update.dart';

part 'reservation_tables_update_model.g.dart';

@JsonSerializable()
class ReservationTablesUpdateModel extends ReservationTablesUpdate {
  ReservationTablesUpdateModel({
    required super.tablesToAdd,
    required super.tablesToRemove,
  });

  factory ReservationTablesUpdateModel.fromEntity(
      ReservationTablesUpdate entity) {
    return ReservationTablesUpdateModel(
      tablesToAdd: entity.tablesToAdd,
      tablesToRemove: entity.tablesToRemove,
    );
  }

  Map<String, dynamic> toJson() => _$ReservationTablesUpdateModelToJson(this);
}
