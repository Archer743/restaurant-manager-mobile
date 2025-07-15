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
    );

Map<String, dynamic> _$TableAvailabilityModelToJson(
        TableAvailabilityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tableNumber': instance.tableNumber,
      'capacity': instance.capacity,
      'status': _$TableStatusEnumMap[instance.status]!,
    };

const _$TableStatusEnumMap = {
  TableStatus.available: 'available',
  TableStatus.occupiedByOther: 'occupiedByOther',
  TableStatus.reservedByCurrent: 'reservedByCurrent',
};
