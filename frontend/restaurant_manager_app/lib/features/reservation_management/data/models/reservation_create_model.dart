import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_create.dart';

part 'reservation_create_model.g.dart';

@JsonSerializable()
class ReservationCreateModel extends ReservationCreate {
  ReservationCreateModel({
    required super.phone,
    required super.email,
    required super.date,
    required super.time,
    required super.peopleCount,
    required super.name,
    required super.comment,
  });

  factory ReservationCreateModel.fromEntity(ReservationCreate entity) {
    return ReservationCreateModel(
      phone: entity.phone,
      email: entity.email,
      date: entity.date,
      time: entity.time,
      peopleCount: entity.peopleCount,
      name: entity.name,
      comment: entity.comment,
    );
  }

  Map<String, dynamic> toJson() => _$ReservationCreateModelToJson(this);
}
