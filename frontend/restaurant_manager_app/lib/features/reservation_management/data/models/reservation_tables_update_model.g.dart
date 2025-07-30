// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_tables_update_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationTablesUpdateModel _$ReservationTablesUpdateModelFromJson(
        Map<String, dynamic> json) =>
    ReservationTablesUpdateModel(
      tablesToAdd: (json['tablesToAdd'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      tablesToRemove: (json['tablesToRemove'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ReservationTablesUpdateModelToJson(
        ReservationTablesUpdateModel instance) =>
    <String, dynamic>{
      'tablesToAdd': instance.tablesToAdd,
      'tablesToRemove': instance.tablesToRemove,
    };
