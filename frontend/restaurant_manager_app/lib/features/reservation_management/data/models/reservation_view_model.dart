import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_manager_app/core/data/converters/app_datetime_converter.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_view.dart';

part 'reservation_view_model.g.dart';

@JsonSerializable()
class ReservationViewModel extends ReservationView {
  @override
  @AppDateTimeUtcConverter()
  final DateTime startTimeUtc;

  ReservationViewModel({
    required super.id,
    required super.phone,
    required super.email,
    required this.startTimeUtc,
    required super.peopleCount,
    required super.name,
    required super.isCreatedByStaff,
    super.comment,
  }) : super(startTimeUtc: startTimeUtc);

  factory ReservationViewModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationViewModelFromJson(json);
}
