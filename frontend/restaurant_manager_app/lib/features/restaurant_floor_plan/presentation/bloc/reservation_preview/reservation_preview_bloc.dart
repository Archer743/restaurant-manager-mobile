import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/domain/usecases/get_reservation_preview_usecase.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/presentation/bloc/reservation_preview/reservation_preview_event.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/presentation/bloc/reservation_preview/reservation_preview_state.dart';

class ReservationPreviewBloc
    extends Bloc<ReservationPreviewEvent, ReservationPreviewState> {
  final GetReservationPreviewUseCase _getReservationPreviewUseCase;

  ReservationPreviewBloc(this._getReservationPreviewUseCase)
      : super(ReservationPreviewInitial()) {
    on<GetReservationPreview>(_onGetReservationPreview);
  }

  Future<void> _onGetReservationPreview(GetReservationPreview event,
      Emitter<ReservationPreviewState> emit) async {
    emit(ReservationPreviewLoading());

    final result = await _getReservationPreviewUseCase(event.reservationId);

    result.fold(
      (failure) => emit(ReservationPreviewError(failure)),
      (preview) => emit(ReservationPreviewLoaded(preview)),
    );
  }
}
