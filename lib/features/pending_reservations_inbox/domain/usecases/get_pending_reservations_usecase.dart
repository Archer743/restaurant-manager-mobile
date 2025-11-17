import 'package:dartz/dartz.dart';
import 'package:restaurant_manager_app/core/domain/usecases/usecase.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/features/pending_reservations_inbox/domain/entities/paged_result.dart';
import 'package:restaurant_manager_app/features/pending_reservations_inbox/domain/entities/pending_reservations_query_params.dart';
import 'package:restaurant_manager_app/features/pending_reservations_inbox/domain/repository/pending_reservations_repository.dart';

class GetPendingReservationsUsecase
    implements
        UseCase<Either<Failure, PagedResult>, PendingReservationsQueryParams> {
  final PendingReservationsRepository _pendingReservationsRepo;

  GetPendingReservationsUsecase(this._pendingReservationsRepo);

  @override
  Future<Either<Failure, PagedResult>> call(
      PendingReservationsQueryParams params) async {
    return await _pendingReservationsRepo.getPendingReservations(params);
  }
}
