import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_manager_app/features/pending_reservations_inbox/domain/entities/pending_reservations_query_params.dart';

part 'pending_reservations_query_params_model.g.dart';

@JsonSerializable()
class PendingReservationsQueryParamsModel
    extends PendingReservationsQueryParams {
  PendingReservationsQueryParamsModel({
    super.page,
    super.limit,
    super.sortOrder,
  });

  factory PendingReservationsQueryParamsModel.fromEntity(
      PendingReservationsQueryParams entity) {
    return PendingReservationsQueryParamsModel(
      page: entity.page,
      limit: entity.limit,
      sortOrder: entity.sortOrder,
    );
  }

  Map<String, dynamic> toJson() =>
      _$PendingReservationsQueryParamsModelToJson(this);
}
