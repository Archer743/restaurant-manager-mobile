import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_manager_app/core/data/converters/app_datetime_converter.dart';
import 'package:restaurant_manager_app/features/pending_reservations_inbox/domain/entities/pending_reservation_preview.dart';

part 'pending_reservation_preview_model.g.dart';

@JsonSerializable()
class PendingReservationPreviewModel extends PendingReservationPreview {
  @override
  @AppDateTimeUtcConverter()
  final DateTime startTimeUtc;

  @override
  @AppDateTimeUtcConverter()
  final DateTime createdAtUtc;

  PendingReservationPreviewModel({
    required super.id,
    required super.name,
    required this.startTimeUtc,
    required this.createdAtUtc,
    required super.peopleCount,
  }) : super(startTimeUtc: startTimeUtc, createdAtUtc: createdAtUtc);

  factory PendingReservationPreviewModel.fromJson(Map<String, dynamic> json) =>
      _$PendingReservationPreviewModelFromJson(json);
}
