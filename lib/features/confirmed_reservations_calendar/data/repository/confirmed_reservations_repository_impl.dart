import 'package:dartz/dartz.dart';
import 'package:restaurant_manager_app/core/data/data_sources/local/token_storage_service.dart';
import 'package:restaurant_manager_app/core/domain/repository/auth_shared_repository.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/core/network/auth_request_handler.dart';
import '../data_sources/confirmed_reservations_api_service.dart';
import '../../domain/entities/utc_range.dart';
import '../../domain/repository/confirmed_reservations_repository.dart';
import '../../domain/typedefs.dart';
import '../../domain/mappers/reservation_grouping_mapper.dart';

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
      getConfirmedReservations(UtcRange utcRange) async {
    return await handleAuthRequest<CalendarConfirmedReservations>(
      _tokenService,
      _authSharedRepo,
      (authorization) async {
        final response =
            await _confReservationsApiService.getConfirmedReservations(
                authorization, utcRange.startUtc, utcRange.endUtc);

        final reservations = response.data;
        return ReservationGroupingMapper.groupByDayKey(reservations);
      },
    );
  }
}
