import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:restaurant_manager_app/core/data/data_sources/local/token_storage_service.dart';
import 'package:restaurant_manager_app/core/domain/events/app_event_bus.dart';
import 'package:restaurant_manager_app/core/domain/events/reservation_events.dart';
import 'package:restaurant_manager_app/core/domain/repository/auth_shared_repository.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/core/network/auth_request_handler.dart';
import '../data_sources/reservation_api_service.dart';
import '../data_sources/reservation_table_api_service.dart';
import '../models/reservation_create_model.dart';
import '../models/reservation_tables_update_model.dart';
import '../models/reservation_update_model.dart';
import '../models/reservation_shift_view_model.dart';
import '../../domain/entities/reservation_create.dart';
import '../../domain/entities/reservation_tables_update.dart';
import '../../domain/entities/reservation_update.dart';
import '../../domain/entities/reservation_view.dart';
import '../../domain/entities/reservation_shift_view.dart';
import '../../domain/repository/reservation_repository.dart';

class ReservationRepositoryImpl implements ReservationRepository {
  final AppEventBus _eventBus;

  final AuthSharedRepository _authSharedRepo;
  final TokenStorageService _tokenService;
  final ReservationApiService _reservationApiService;
  final ReservationTableApiService _reservationTableApiService;

  ReservationRepositoryImpl(
    this._eventBus,
    this._authSharedRepo,
    this._tokenService,
    this._reservationApiService,
    this._reservationTableApiService,
  );

  @override
  Future<Either<Failure, void>> createReservation(
    ReservationCreate reservation,
  ) async {
    return await handleAuthRequest<Null>(
      _tokenService,
      _authSharedRepo,
      (authorization) async {
        final createModel = ReservationCreateModel.fromEntity(reservation);

        await _reservationApiService.createReservation(
            authorization, createModel);

        // Inform all listeners that new reservation was created
        _eventBus.fire(ReservationsChangedEvent(
          affectedDates: [reservation.startUtc],
        ));

        return null;
      },
    );
  }

  @override
  Future<Either<Failure, ReservationView>> getReservation(String id) async {
    return await handleAuthRequest(
      _tokenService,
      _authSharedRepo,
      (authorization) async {
        final response =
            await _reservationApiService.getReservation(authorization, id);

        return response.data;
      },
    );
  }

  @override
  Future<Either<Failure, ReservationView>> updateReservation(
    String id,
    ReservationUpdate update,
  ) async {
    return await handleAuthRequest(
      _tokenService,
      _authSharedRepo,
      (authorization) async {
        final updateModel = ReservationUpdateModel.fromEntity(update);

        final response = await _reservationApiService.updateReservation(
            authorization, id, updateModel);

        return response.data;
      },
    );
  }

  @override
  Future<Either<Failure, void>> removeReservation(String id) async {
    return await handleAuthRequest<Null>(
      _tokenService,
      _authSharedRepo,
      (authorization) async {
        await _reservationApiService.removeReservation(authorization, id);
        return null;
      },
    );
  }

  @override
  Future<Either<Failure, void>> closeReservation(String id) async {
    return await handleAuthRequest<Null>(
      _tokenService,
      _authSharedRepo,
      (authorization) async {
        await _reservationApiService.closeReservation(authorization, id);
        return null;
      },
    );
  }

  @override
  Future<Either<Failure, void>> reopenReservation(String id) async {
    return await handleAuthRequest<Null>(
      _tokenService,
      _authSharedRepo,
      (authorization) async {
        await _reservationApiService.reopenReservation(authorization, id);
        return null;
      },
    );
  }

  @override
  Future<Either<Failure, ReservationShiftView>>
      getTablesAvailabilityForReservation(
    String id,
  ) async {
    return await handleAuthRequest(
      _tokenService,
      _authSharedRepo,
      (authorization) async {
        final response = await _reservationTableApiService
            .getTablesAvailabilityForReservation(authorization, id);

        return response.data.getEntity();
      },
    );
  }

  @override
  Future<Either<Failure, ReservationShiftView?>> updateReservationTables(
    String id,
    ReservationTablesUpdate update,
  ) async {
    return await handleAuthRequest(
      _tokenService,
      _authSharedRepo,
      (authorization) async {
        final updateModel = ReservationTablesUpdateModel.fromEntity(update);

        final response = await _reservationTableApiService
            .updateReservationTables(authorization, id, updateModel);

        // Normally, retrofit auto-deserializes the response body into `HttpResponse<T>.data`.
        // But since the backend can return either 200 with JSON (ShiftViewModel)
        // OR 204 No Content (with an empty body), we must handle the parsing manually.
        if (response.response.statusCode == HttpStatus.ok) {
          final shift = ReservationShiftViewModel.fromJson(response.data);
          return shift.getEntity();
        }

        return null;
      },
    );
  }
}
