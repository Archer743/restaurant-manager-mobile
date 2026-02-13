import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_manager_app/core/data/converters/app_datetime_converter.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/domain/entities/reservation_preview.dart';

part 'reservation_preview_model.g.dart';

@JsonSerializable()
class ReservationPreviewModel extends ReservationPreview {
  @override
  @AppDateTimeUtcConverter()
  final DateTime startUtc;

  ReservationPreviewModel({
    required super.id,
    required super.tag,
    required super.name,
    required this.startUtc,
    required super.peopleCount,
    required super.isClosed,
  }) : super(startUtc: startUtc);

  factory ReservationPreviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationPreviewModelFromJson(json);
}
