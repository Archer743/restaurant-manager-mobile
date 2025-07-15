import 'package:dartz/dartz.dart';
import 'package:restaurant_manager_app/core/data/data_sources/local/token_storage_service.dart';
import 'package:restaurant_manager_app/core/domain/repository/auth_shared_repository.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/core/network/auth_request_handler.dart';
import 'package:restaurant_manager_app/features/reservation_management/data/data_sources/reservation_api_service.dart';
import 'package:restaurant_manager_app/features/reservation_management/data/data_sources/reservation_table_api_service.dart';
import 'package:restaurant_manager_app/features/reservation_management/data/models/reservation_create_model.dart';
import 'package:restaurant_manager_app/features/reservation_management/data/models/reservation_update_model.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_create.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_update.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_view.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/shift_view.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/repository/reservation_repository.dart';

class ReservationRepositoryImpl implements ReservationRepository {
  final AuthSharedRepository _authSharedRepo;
  final TokenStorageService _tokenService;
  final ReservationApiService _reservationApiService;
  final ReservationTableApiService _reservationTableApiService;

  ReservationRepositoryImpl(
    this._authSharedRepo,
    this._tokenService,
    this._reservationApiService,
    this._reservationTableApiService,
  );

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
  Future<Either<Failure, void>> createReservation(
    ReservationCreate data,
  ) async {
    return await handleAuthRequest<Null>(
      _tokenService,
      _authSharedRepo,
      (authorization) async {
        final createModel = ReservationCreateModel.fromEntity(data);

        await _reservationApiService.createReservation(
            authorization, createModel);

        return null;
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
  Future<Either<Failure, ShiftView>> getTablesAvailabilityForReservation(
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
}
