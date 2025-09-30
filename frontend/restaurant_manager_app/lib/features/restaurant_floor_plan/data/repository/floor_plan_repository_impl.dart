import 'package:dartz/dartz.dart';
import 'package:restaurant_manager_app/core/data/data_sources/local/token_storage_service.dart';
import 'package:restaurant_manager_app/core/domain/repository/auth_shared_repository.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/core/network/auth_request_handler.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/data/data_sources/floor_plan_api_service.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/data/data_sources/reservation_preview_api_service.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/domain/entities/floor_plan_view.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/domain/entities/reservation_preview.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/domain/repository/floor_plan_repository.dart';

class FloorPlanRepositoryImpl implements FloorPlanRepository {
  final AuthSharedRepository _authSharedRepo;
  final TokenStorageService _tokenService;
  final FloorPlanApiService _floorPlanApiService;
  final ReservationPreviewApiService _reservationPreviewApiService;

  FloorPlanRepositoryImpl(
    this._authSharedRepo,
    this._tokenService,
    this._floorPlanApiService,
    this._reservationPreviewApiService,
  );

  @override
  Future<Either<Failure, FloorPlanView>> getRestaurantFloorPlan(
    String date,
    String? shiftId,
  ) async {
    return await handleAuthRequest(
      _tokenService,
      _authSharedRepo,
      (authorization) async {
        final response = await _floorPlanApiService.getRestaurantFloorPlan(
            authorization, date, shiftId);

        return response.data.getEntity();
      },
    );
  }

  @override
  Future<Either<Failure, ReservationPreview>> getReservationPreview(
      String reservationId) async {
    return await handleAuthRequest(
      _tokenService,
      _authSharedRepo,
      (authorization) async {
        final response = await _reservationPreviewApiService
            .getReservationPreview(authorization, reservationId);

        return response.data;
      },
    );
  }
}
