import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_manager_app/core/utils/future_utils.dart';
import '../../domain/services/month_reservations_cache.dart';
import '../../domain/usecases/get_confirmed_reservations_usecase.dart';
import '../../presentation/bloc/calendar_event.dart';
import '../../presentation/bloc/calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final GetConfirmedReservationsUsecase _usecase;

  final MonthReservationsCache _cache =
      MonthReservationsCache(ttl: const Duration(minutes: 5));

  CalendarBloc(this._usecase) : super(CalendarInitial()) {
    on<GetReservationsForMonth>(_onGetReservationsForMonth);
    on<RefreshCalendar>(_onRefreshCalendar);
  }

  Future<void> _onGetReservationsForMonth(
    GetReservationsForMonth event,
    Emitter<CalendarState> emit,
  ) async {
    final monthKey = event.monthKey;

    final cached = _cache.get(monthKey);
    final isFresh = _cache.isFresh(monthKey);

    /// If data for the requested month is available in cache (even if stale),
    /// emit it immediately.
    /// This provides a "stale-while-revalidate" (SWR) experience.
    if (cached != null) {
      emit(CalendarLoaded(cached));
      if (isFresh) return;
    } else {
      emit(CalendarLoading());
    }

    // Fetch the current month's data if not cached or stale
    final result = await minDelayRun(_usecase(event.utcRange));
    if (emit.isDone) return;

    result.fold(
      (failure) => emit(CalendarError(failure)),
      (data) {
        _cache.put(monthKey, data);
        emit(CalendarLoaded(data));
      },
    );
  }

  Future<void> _onRefreshCalendar(
    RefreshCalendar event,
    Emitter<CalendarState> emit,
  ) async {
    bool isCacheExpiryModified = false;

    // Expire modified months so they are fetched again
    for (var monthKey in event.affectedMonthKeys) {
      if (_cache.expire(monthKey)) isCacheExpiryModified = true;
    }

    // Trigger the reload process for the current month displayed
    if (isCacheExpiryModified && !isClosed) {
      emit(CalendarReload());
    }
  }
}
