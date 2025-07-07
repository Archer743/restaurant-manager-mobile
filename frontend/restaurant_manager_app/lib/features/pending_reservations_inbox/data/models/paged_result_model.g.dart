// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagedResultModel _$PagedResultModelFromJson(Map<String, dynamic> json) =>
    PagedResultModel(
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => PendingReservationPreviewModel.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: PaginationMetadataModel.fromJson(
          json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PagedResultModelToJson(PagedResultModel instance) =>
    <String, dynamic>{
      'items': instance.items,
      'pagination': instance.pagination,
    };
