// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_availability_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableAvailabilityModel _$TableAvailabilityModelFromJson(
        Map<String, dynamic> json) =>
    TableAvailabilityModel(
      id: json['id'] as String,
      tableNumber: (json['tableNumber'] as num).toInt(),
      capacity: (json['capacity'] as num).toInt(),
      status: $enumDecode(_$TableStatusEnumMap, json['status']),
      reservationId: json['reservationId'] as String?,
    );

Map<String, dynamic> _$TableAvailabilityModelToJson(
        TableAvailabilityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tableNumber': instance.tableNumber,
      'capacity': instance.capacity,
      'status': _$TableStatusEnumMap[instance.status]!,
      'reservationId': instance.reservationId,
    };

const _$TableStatusEnumMap = {
  TableStatus.available: 'available',
  TableStatus.reserved: 'reserved',
  TableStatus.reservedByCurrent: 'reservedByCurrent',
};
