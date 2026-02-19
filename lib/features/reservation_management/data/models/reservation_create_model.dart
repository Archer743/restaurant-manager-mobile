import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_manager_app/core/data/converters/app_datetime_converter.dart';
import '../../domain/entities/reservation_create.dart';

part 'reservation_create_model.g.dart';

@JsonSerializable()
class ReservationCreateModel extends ReservationCreate {
  @override
  @AppDateTimeUtcConverter()
  final DateTime startUtc;

  ReservationCreateModel({
    required super.name,
    required this.startUtc,
    required super.peopleCount,
    required super.email,
    required super.phone,
    required super.comment,
  }) : super(startUtc: startUtc);

  factory ReservationCreateModel.fromEntity(ReservationCreate entity) {
    return ReservationCreateModel(
      name: entity.name,
      startUtc: entity.startUtc,
      peopleCount: entity.peopleCount,
      email: entity.email,
      phone: entity.phone,
      comment: entity.comment,
    );
  }

  Map<String, dynamic> toJson() => _$ReservationCreateModelToJson(this);
}
