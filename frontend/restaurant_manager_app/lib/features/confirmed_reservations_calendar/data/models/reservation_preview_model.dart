import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/domain/entities/reservation_preview.dart';

part 'reservation_preview_model.g.dart';

@JsonSerializable()
class ReservationPreviewModel extends ReservationPreview {
  ReservationPreviewModel({
    required super.id,
    required super.time,
    required super.peopleCount,
    required super.name,
  });

  factory ReservationPreviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationPreviewModelFromJson(json);
}
