import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_manager_app/core/utils/future_utils.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/domain/entities/date_range.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/domain/typedefs.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/domain/usecases/get_confirmed_reservations_usecase.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/presentation/bloc/calendar_event.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/presentation/bloc/calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final GetConfirmedReservationsUsecase _getConfReservationsUsecase;
  final CachedConfirmedReservations _monthCache = {};
  // TODO: Update old cache

  CalendarBloc(this._getConfReservationsUsecase) : super(CalendarInitial()) {
    on<FetchReservationsForMonth>(_onFetchReservationsForMonth);
  }

  Future<void> _onFetchReservationsForMonth(
    FetchReservationsForMonth event,
    Emitter<CalendarState> emit,
  ) async {
    final DateTime startOfMonth =
        DateTime.utc(event.focusedDay.year, event.focusedDay.month, 1);

    // 1. Check cache first
    if (_monthCache.containsKey(startOfMonth)) {
      emit(CalendarLoaded(_monthCache[startOfMonth]!));
      return;
    }

    // 2. If not in cache, proceed with loading
    emit(CalendarLoading());

    final DateTime endOfMonth =
        DateTime.utc(event.focusedDay.year, event.focusedDay.month + 1, 0);

    // Place dates in DateRange
    final DateRange dateRange =
        DateRange(startDate: startOfMonth, endDate: endOfMonth);

    final result = await minDelayRun(_getConfReservationsUsecase(dateRange));

    result.fold(
      (failure) => emit(CalendarError(failure)),
      (reservations) {
        // Store in cache
        _monthCache[startOfMonth] = reservations;
        emit(CalendarLoaded(reservations));
      },
    );
  }
}
