import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_manager_app/core/utils/datetime_utils.dart';
import 'package:restaurant_manager_app/core/utils/future_utils.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/domain/entities/date_range.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/domain/typedefs.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/domain/usecases/get_confirmed_reservations_usecase.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/presentation/bloc/calendar_event.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/presentation/bloc/calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final GetConfirmedReservationsUsecase _getConfReservationsUsecase;

  // TODO: Cache
  final CachedConfirmedReservations _monthCache = {};
  // Month : Expiry
  final Map<DateTime, DateTime> _cacheExpiry = {};
  // How long the cache is considered fresh TTL (Time-To-Live)
  static const Duration _monthDataTTL = Duration(minutes: 5);

  CalendarBloc(this._getConfReservationsUsecase) : super(CalendarInitial()) {
    on<GetReservationsForMonth>(_onGetReservationsForMonth);
    on<RefreshCalendar>(_onRefreshCalendar);
  }

  Future<void> _onGetReservationsForMonth(
    GetReservationsForMonth event,
    Emitter<CalendarState> emit,
  ) async {
    final DateTime requestedMonthStart = getFirstDayOfMonth(event.focusedDay);

    final bool isCached = _monthCache.containsKey(requestedMonthStart);
    final DateTime? expiry = _cacheExpiry[requestedMonthStart];
    final bool isStale = expiry == null || DateTime.now().isAfter(expiry);

    // If data for the requested month is available in cache (even if stale), emit it immediately.
    // This provides a "stale-while-revalidate" (SWR) experience.
    if (isCached) {
      if (isClosed) return;
      emit(CalendarLoaded(_monthCache[requestedMonthStart]!));

      // If data is fresh, we're done. Otherwise, we'll proceed to fetch fresh data.
      if (!isStale) return;
    } else {
      // If no data is available for the requested month, show loading.
      if (isClosed) return;
      emit(CalendarLoading());
    }

    // Fetch the current month's data if not cached or stale
    final DateTime requestedMonthEnd = getLastDayOfMonth(event.focusedDay);

    // Place dates in DateRange
    final DateRange dateRange =
        DateRange(startDate: requestedMonthStart, endDate: requestedMonthEnd);

    if (isClosed) return;
    final result = await minDelayRun(_getConfReservationsUsecase(dateRange));

    if (isClosed) return;
    result.fold(
      (failure) => emit(CalendarError(failure)),
      (reservations) {
        // Store in cache
        _monthCache[requestedMonthStart] = reservations;
        _cacheExpiry[requestedMonthStart] = DateTime.now().add(_monthDataTTL);

        // Emit the newly fetched (and now fresh) data
        emit(CalendarLoaded(reservations));
      },
    );
  }

  Future<void> _onRefreshCalendar(
    RefreshCalendar event,
    Emitter<CalendarState> emit,
  ) async {
    bool isCacheExpiryModified = false;

    // Expire modified months so they are fetched again
    for (var monthStart in event.affectedMonths) {
      if (_cacheExpiry.containsKey(monthStart)) {
        _cacheExpiry[monthStart] = DateTime.now();
        isCacheExpiryModified = true;
      }
    }

    // Trigger the reload proccess for the current month displayed
    if (isCacheExpiryModified && !isClosed) {
      emit(CalendarReload());
    }
  }
}
