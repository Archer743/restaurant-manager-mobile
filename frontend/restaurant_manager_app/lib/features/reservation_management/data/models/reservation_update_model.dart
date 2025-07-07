import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_manager_app/core/data/converters/app_datetime_converter.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_update.dart';

part 'reservation_update_model.g.dart';

@JsonSerializable()
class ReservationUpdateModel extends ReservationUpdate {
  @override
  @AppDateTimeUtcConverter()
  final DateTime? startTimeUtc;

  ReservationUpdateModel({
    required super.name,
    required super.email,
    required super.phone,
    required this.startTimeUtc,
    required super.peopleCount,
    required super.comment,
  }) : super(startTimeUtc: startTimeUtc);

  factory ReservationUpdateModel.fromEntity(ReservationUpdate entity) {
    return ReservationUpdateModel(
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      startTimeUtc: entity.startTimeUtc,
      peopleCount: entity.peopleCount,
      comment: entity.comment,
    );
  }

  Map<String, dynamic> toJson() => _$ReservationUpdateModelToJson(this);
}
