import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_manager_app/core/data/converters/app_datetime_converter.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_create.dart';

part 'reservation_create_model.g.dart';

@JsonSerializable()
class ReservationCreateModel extends ReservationCreate {
  @override
  @AppDateTimeUtcConverter()
  final DateTime startTimeUtc;

  ReservationCreateModel({
    required super.name,
    required this.startTimeUtc,
    required super.peopleCount,
    required super.email,
    required super.phone,
    required super.comment,
  }) : super(startTimeUtc: startTimeUtc);

  factory ReservationCreateModel.fromEntity(ReservationCreate entity) {
    return ReservationCreateModel(
      name: entity.name,
      startTimeUtc: entity.startTimeUtc,
      peopleCount: entity.peopleCount,
      email: entity.email,
      phone: entity.phone,
      comment: entity.comment,
    );
  }

  Map<String, dynamic> toJson() => _$ReservationCreateModelToJson(this);
}
