import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_manager_app/core/domain/events/app_event_bus.dart';
import 'package:restaurant_manager_app/core/domain/events/reservation_events.dart';
import 'package:restaurant_manager_app/core/utils/future_utils.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/domain/utils/calendar_date_utils.dart';
import '../../domain/services/month_reservations_cache.dart';
import '../../domain/usecases/get_confirmed_reservations_usecase.dart';
import '../../presentation/bloc/calendar_event.dart';
import '../../presentation/bloc/calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final AppEventBus _eventBus;
  StreamSubscription? _eventSubscription;

  final GetConfirmedReservationsUsecase _usecase;

  final MonthReservationsCache _cache = MonthReservationsCache(
    ttl: const Duration(minutes: 5),
  );

  DateTime? _lastFocusedDay;

  CalendarBloc(this._eventBus, this._usecase) : super(CalendarInitial()) {
    _eventSubscription = _eventBus.on<ReservationsChangedEvent>().listen(
      (event) {
        add(RefreshCalendar(rawDatesAffected: event.affectedDates));
      },
    );

    on<GetReservationsForMonth>(_onGetReservationsForMonth);
    on<RefreshCalendar>(_onRefreshCalendar);
  }

  @override
  Future<void> close() {
    _eventSubscription?.cancel();
    return super.close();
  }

  Future<void> _onGetReservationsForMonth(
    GetReservationsForMonth event,
    Emitter<CalendarState> emit,
  ) async {
    _lastFocusedDay = event.focusedDay;

    final cached = _cache.get(event.monthKey);
    final isFresh = _cache.isFresh(event.monthKey);

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
        _cache.put(event.monthKey, data);
        emit(CalendarLoaded(data));
      },
    );
  }

  Future<void> _onRefreshCalendar(
    RefreshCalendar event,
    Emitter<CalendarState> emit,
  ) async {
    // Expire all affected months
    for (var monthKey in event.affectedMonthKeys) {
      _cache.expire(monthKey);
    }

    if (_lastFocusedDay == null || isClosed) return;

    final currMonthKey = CalendarDateUtils.getMonthKey(_lastFocusedDay!);

    // Refresh the calendar immediately if the displayed month is affected
    if (event.affectedMonthKeys.contains(currMonthKey)) {
      add(GetReservationsForMonth(_lastFocusedDay!));
    }
  }
}
