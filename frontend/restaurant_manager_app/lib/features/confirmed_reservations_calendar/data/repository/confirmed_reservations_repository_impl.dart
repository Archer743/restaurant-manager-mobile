import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:restaurant_manager_app/core/data/data_sources/local/token_storage_service.dart';
import 'package:restaurant_manager_app/core/domain/repository/auth_shared_repository.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/core/network/auth_request_handler.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/data/data_sources/confirmed_reservations_api_service.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/domain/entities/date_range.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/domain/repository/confirmed_reservations_repository.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/domain/typedefs.dart';

class ConfirmedReservationsRepositoryImpl
    implements ConfirmedReservationsRepository {
  final AuthSharedRepository _authSharedRepo;
  final TokenStorageService _tokenService;
  final ConfirmedReservationsApiService _confReservationsApiService;

  ConfirmedReservationsRepositoryImpl(
    this._authSharedRepo,
    this._tokenService,
    this._confReservationsApiService,
  );

  @override
  Future<Either<Failure, CalendarConfirmedReservations>>
      getConfirmedReservations(DateRange dateRange) async {
    return await handleAuthRequest<CalendarConfirmedReservations>(
      _tokenService,
      _authSharedRepo,
      (authorization) async {
        debugPrint(authorization);
        final response =
            await _confReservationsApiService.getConfirmedReservations(
                authorization, dateRange.startDate, dateRange.endDate);

        final CalendarConfirmedReservations transformedMap = {};
        final apiData = response.data;

        // Change map key to DateTime
        apiData.forEach(
          (dateString, models) {
            final parts = dateString.split('-');
            final DateTime dateKey = DateTime.utc(
              int.parse(parts[0]),
              int.parse(parts[1]),
              int.parse(parts[2]),
            );
            transformedMap[dateKey] = models;
          },
        );

        return transformedMap;
      },
    );
  }
}
