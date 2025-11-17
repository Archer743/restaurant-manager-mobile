import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_manager_app/features/pending_reservations_inbox/domain/entities/paged_result.dart'; // Your PagedResult entity
import 'package:restaurant_manager_app/features/pending_reservations_inbox/data/models/pending_reservation_preview_model.dart'; // The specific model for items
import 'package:restaurant_manager_app/features/pending_reservations_inbox/data/models/pagination_metadata_model.dart'; // The specific model for pagination

part 'paged_result_model.g.dart';

@JsonSerializable()
class PagedResultModel extends PagedResult {
  @override
  @JsonKey(name: 'items', defaultValue: <PendingReservationPreviewModel>[])
  final List<PendingReservationPreviewModel> items;

  @override
  @JsonKey(name: 'pagination')
  final PaginationMetadataModel pagination;

  PagedResultModel({
    required this.items,
    required this.pagination,
  }) : super(items: items, pagination: pagination);

  factory PagedResultModel.fromJson(Map<String, dynamic> json) =>
      _$PagedResultModelFromJson(json);
}
