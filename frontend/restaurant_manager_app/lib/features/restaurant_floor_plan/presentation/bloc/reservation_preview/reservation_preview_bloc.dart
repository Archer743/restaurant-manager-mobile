import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_manager_app/core/utils/future_utils.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/domain/usecases/get_reservation_preview_usecase.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/presentation/bloc/reservation_preview/reservation_preview_event.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/presentation/bloc/reservation_preview/reservation_preview_state.dart';

class ReservationPreviewBloc
    extends Bloc<ReservationPreviewEvent, ReservationPreviewState> {
  final GetReservationPreviewUseCase _getReservationPreviewUseCase;

  ReservationPreviewBloc(this._getReservationPreviewUseCase)
      : super(ReservationPreviewInitial()) {
    on<GetReservationPreview>(_onGetReservationPreview);
    on<DismissReservationPreview>(_onDismissReservationPreview);
  }

  Future<void> _onGetReservationPreview(GetReservationPreview event,
      Emitter<ReservationPreviewState> emit) async {
    emit(ReservationPreviewLoading());

    final result = await minDelayRun(
      _getReservationPreviewUseCase(event.reservationId),
      minimumDelay: const Duration(milliseconds: 600),
    );

    result.fold(
      (failure) => emit(ReservationPreviewError(failure)),
      (preview) => emit(ReservationPreviewLoaded(preview)),
    );
  }

  Future<void> _onDismissReservationPreview(DismissReservationPreview event,
      Emitter<ReservationPreviewState> emit) async {
    emit(ReservationPreviewDismissed());
  }
}
