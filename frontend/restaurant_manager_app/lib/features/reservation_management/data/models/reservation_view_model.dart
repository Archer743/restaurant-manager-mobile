import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_manager_app/core/data/converters/app_dateonly_converter.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_view.dart';

part 'reservation_view_model.g.dart';

@JsonSerializable()
class ReservationViewModel {
  final String id;
  final String phone;
  final String email;

  @AppDateOnlyConverter()
  final DateTime date;

  final String time;
  final int peopleCount;
  final String name;
  final bool isCreatedByStaff;
  final String? comment;

  ReservationViewModel({
    required this.id,
    required this.phone,
    required this.email,
    required this.date,
    required this.time,
    required this.peopleCount,
    required this.name,
    required this.isCreatedByStaff,
    this.comment,
  });

  factory ReservationViewModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationViewModelFromJson(json);

  ReservationView toEntity() {
    return ReservationView(
      id: id,
      phone: phone,
      email: email,
      date: date,
      time: time,
      peopleCount: peopleCount,
      name: name,
      isCreatedByStaff: isCreatedByStaff,
      comment: comment,
    );
  }
}
