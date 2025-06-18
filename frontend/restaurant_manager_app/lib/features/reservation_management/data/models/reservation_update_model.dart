import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_update.dart';

part 'reservation_update_model.g.dart';

@JsonSerializable()
class ReservationUpdateModel extends ReservationUpdate {
  ReservationUpdateModel({
    required super.date,
    required super.time,
    required super.peopleCount,
    required super.comment,
  });

  factory ReservationUpdateModel.fromEntity(ReservationUpdate entity) {
    return ReservationUpdateModel(
      date: entity.date,
      time: entity.time,
      peopleCount: entity.peopleCount,
      comment: entity.comment,
    );
  }

  Map<String, dynamic> toJson() => _$ReservationUpdateModelToJson(this);
}
