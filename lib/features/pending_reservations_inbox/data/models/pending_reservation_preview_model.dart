import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_manager_app/core/data/converters/app_datetime_converter.dart';
import 'package:restaurant_manager_app/features/pending_reservations_inbox/domain/entities/pending_reservation_preview.dart';

part 'pending_reservation_preview_model.g.dart';

@JsonSerializable()
class PendingReservationPreviewModel extends PendingReservationPreview {
  @override
  @AppDateTimeUtcConverter()
  final DateTime startUtc;

  @override
  @AppDateTimeUtcConverter()
  final DateTime createdAtUtc;

  PendingReservationPreviewModel({
    required super.id,
    required super.name,
    required this.startUtc,
    required this.createdAtUtc,
    required super.peopleCount,
  }) : super(startUtc: startUtc, createdAtUtc: createdAtUtc);

  factory PendingReservationPreviewModel.fromJson(Map<String, dynamic> json) =>
      _$PendingReservationPreviewModelFromJson(json);
}
