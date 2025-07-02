import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_manager_app/features/pending_reservations_inbox/domain/entities/pagination_metadata.dart';

part 'pagination_metadata_model.g.dart';

@JsonSerializable()
class PaginationMetadataModel extends PaginationMetadata {
  PaginationMetadataModel({
    required super.currentPage,
    required super.pageSize,
    required super.totalItems,
    required super.totalPages,
    required super.hasNextPage,
  });

  factory PaginationMetadataModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetadataModelFromJson(json);
}
