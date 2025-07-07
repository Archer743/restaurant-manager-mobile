// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_metadata_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationMetadataModel _$PaginationMetadataModelFromJson(
        Map<String, dynamic> json) =>
    PaginationMetadataModel(
      currentPage: (json['currentPage'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
      totalItems: (json['totalItems'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      hasNextPage: json['hasNextPage'] as bool,
    );

Map<String, dynamic> _$PaginationMetadataModelToJson(
        PaginationMetadataModel instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'pageSize': instance.pageSize,
      'totalItems': instance.totalItems,
      'totalPages': instance.totalPages,
      'hasNextPage': instance.hasNextPage,
    };
