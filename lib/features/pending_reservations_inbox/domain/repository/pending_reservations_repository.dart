import 'package:dartz/dartz.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/features/pending_reservations_inbox/domain/entities/paged_result.dart';
import 'package:restaurant_manager_app/features/pending_reservations_inbox/domain/entities/pending_reservations_query_params.dart';

abstract class PendingReservationsRepository {
  Future<Either<Failure, PagedResult>> getPendingReservations(
      PendingReservationsQueryParams params);
}
