import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_manager_app/core/data/converters/app_datetime_converter.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_view.dart';

part 'reservation_view_model.g.dart';

@JsonSerializable()
class ReservationViewModel extends ReservationView {
  @override
  @AppDateTimeUtcConverter()
  final DateTime startUtc;

  ReservationViewModel({
    required super.id,
    required super.tag,
    required super.name,
    required this.startUtc,
    required super.peopleCount,
    required super.isCreatedByStaff,
    required super.isClosed,
    super.email,
    super.phone,
    super.comment,
  }) : super(startUtc: startUtc);

  factory ReservationViewModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationViewModelFromJson(json);
}
