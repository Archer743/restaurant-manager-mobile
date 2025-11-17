// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_reservations_query_params_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PendingReservationsQueryParamsModel
    _$PendingReservationsQueryParamsModelFromJson(Map<String, dynamic> json) =>
        PendingReservationsQueryParamsModel(
          page: (json['page'] as num?)?.toInt() ?? 1,
          limit: (json['limit'] as num?)?.toInt() ?? 20,
          sortOrder:
              $enumDecodeNullable(_$SortOrderEnumMap, json['sortOrder']) ??
                  SortOrder.desc,
        );

Map<String, dynamic> _$PendingReservationsQueryParamsModelToJson(
        PendingReservationsQueryParamsModel instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'sortOrder': _$SortOrderEnumMap[instance.sortOrder]!,
    };

const _$SortOrderEnumMap = {
  SortOrder.asc: 'asc',
  SortOrder.desc: 'desc',
};
