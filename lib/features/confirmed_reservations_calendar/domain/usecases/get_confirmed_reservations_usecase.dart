import 'package:dartz/dartz.dart';
import 'package:restaurant_manager_app/core/domain/usecases/usecase.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/domain/entities/utc_range.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/domain/repository/confirmed_reservations_repository.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/domain/typedefs.dart';

class GetConfirmedReservationsUsecase
    implements
        UseCase<Either<Failure, CalendarConfirmedReservations>, UtcRange> {
  final ConfirmedReservationsRepository _confReservationsRepo;

  GetConfirmedReservationsUsecase(this._confReservationsRepo);

  @override
  Future<Either<Failure, CalendarConfirmedReservations>> call(
      UtcRange utcRange) async {
    return await _confReservationsRepo.getConfirmedReservations(utcRange);
  }
}
