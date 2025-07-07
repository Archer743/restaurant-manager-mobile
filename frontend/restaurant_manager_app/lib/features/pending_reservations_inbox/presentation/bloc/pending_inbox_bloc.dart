import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_manager_app/core/utils/future_utils.dart';
import 'package:restaurant_manager_app/features/pending_reservations_inbox/domain/entities/pagination_metadata.dart';
import 'package:restaurant_manager_app/features/pending_reservations_inbox/domain/entities/pending_reservation_preview.dart';
import 'package:restaurant_manager_app/features/pending_reservations_inbox/domain/entities/pending_reservations_query_params.dart';
import 'package:restaurant_manager_app/features/pending_reservations_inbox/domain/usecases/get_pending_reservations_usecase.dart';
import 'package:restaurant_manager_app/features/pending_reservations_inbox/presentation/bloc/pending_inbox_event.dart';
import 'package:restaurant_manager_app/features/pending_reservations_inbox/presentation/bloc/pending_inbox_state.dart';

class PendingInboxBloc extends Bloc<PendingInboxEvent, PendingInboxState> {
  final GetPendingReservationsUsecase _getPendingReservationsUsecase;

  final List<PendingReservationPreview> _allLoadedReservations = [];
  PaginationMetadata? _lastPaginationMetadata;

  PendingInboxBloc(this._getPendingReservationsUsecase)
      : super(PendingInboxInitial()) {
    on<GetPendingReservations>(_onGetPendingReservations);
    on<LoadNextPage>(_onLoadNextPage);
  }

  Future<void> _onGetPendingReservations(
    GetPendingReservations event,
    Emitter<PendingInboxState> emit,
  ) async {
    emit(PendingInboxLoading());

    if (event.isRefresh) {
      _allLoadedReservations.clear();
      _lastPaginationMetadata = null;
    }

    final params = PendingReservationsQueryParams(limit: 8);
    await _fetchAndEmit(params: params, emit: emit);
  }

  Future<void> _onLoadNextPage(
    LoadNextPage event,
    Emitter<PendingInboxState> emit,
  ) async {
    if (_lastPaginationMetadata == null ||
        !_lastPaginationMetadata!.hasNextPage ||
        state is PendingInboxLoading ||
        state is PendingInboxLoadingMore) {
      return;
    }

    emit(PendingInboxLoadingMore(
      reservations: _allLoadedReservations,
      hasNextPage: _lastPaginationMetadata!.hasNextPage,
    ));

    final params = PendingReservationsQueryParams(
      page: _lastPaginationMetadata!.currentPage + 1,
      limit: _lastPaginationMetadata!.pageSize,
    );

    await _fetchAndEmit(params: params, emit: emit);
  }

  Future<void> _fetchAndEmit({
    required PendingReservationsQueryParams params,
    required Emitter<PendingInboxState> emit,
  }) async {
    final result = await minDelayRun(_getPendingReservationsUsecase(params));

    result.fold(
      (failure) => emit(PendingInboxError(failure)),
      (pagedResult) {
        _allLoadedReservations.addAll(pagedResult.items);
        _lastPaginationMetadata = pagedResult.pagination;
        emit(PendingInboxLoaded(
          reservations: _allLoadedReservations,
          hasNextPage: _lastPaginationMetadata!.hasNextPage,
        ));
      },
    );
  }
}
