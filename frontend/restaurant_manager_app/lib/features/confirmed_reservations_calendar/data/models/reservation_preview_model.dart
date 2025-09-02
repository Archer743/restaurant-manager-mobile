import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_manager_app/core/data/converters/app_timeofday_converter.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/domain/entities/reservation_preview.dart';

part 'reservation_preview_model.g.dart';

@JsonSerializable()
class ReservationPreviewModel extends ReservationPreview {
  @override
  @AppTimeOfDayConverter()
  final TimeOfDay time;

  ReservationPreviewModel({
    required super.id,
    required super.tag,
    required super.name,
    required this.time,
    required super.peopleCount,
    required super.isClosed,
  }) : super(time: time);

  factory ReservationPreviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationPreviewModelFromJson(json);
}
