import 'package:dartz/dartz.dart';
import 'package:restaurant_manager_app/core/data/data_sources/local/token_storage_service.dart';
import 'package:restaurant_manager_app/core/domain/repository/auth_shared_repository.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/core/network/auth_request_handler.dart';
import 'package:restaurant_manager_app/features/pending_reservations_inbox/data/data_sources/pending_reservations_api_service.dart';
import 'package:restaurant_manager_app/features/pending_reservations_inbox/data/models/pending_reservations_query_params_model.dart';
import 'package:restaurant_manager_app/features/pending_reservations_inbox/domain/entities/paged_result.dart';
import 'package:restaurant_manager_app/features/pending_reservations_inbox/domain/entities/pending_reservations_query_params.dart';
import 'package:restaurant_manager_app/features/pending_reservations_inbox/domain/repository/pending_reservations_repository.dart';

class PendingReservationsRepositoryImpl
    implements PendingReservationsRepository {
  final AuthSharedRepository _authSharedRepo;
  final TokenStorageService _tokenService;
  final PendingReservationsApiService _pendingReservationsApiService;

  PendingReservationsRepositoryImpl(
    this._authSharedRepo,
    this._tokenService,
    this._pendingReservationsApiService,
  );

  @override
  Future<Either<Failure, PagedResult>> getPendingReservations(
      PendingReservationsQueryParams params) async {
    return await handleAuthRequest<PagedResult>(
      _tokenService,
      _authSharedRepo,
      (authorization) async {
        final paramsModel =
            PendingReservationsQueryParamsModel.fromEntity(params);

        final response = await _pendingReservationsApiService
            .getPendingReservations(authorization, paramsModel);

        return response.data;
      },
    );
  }
}
