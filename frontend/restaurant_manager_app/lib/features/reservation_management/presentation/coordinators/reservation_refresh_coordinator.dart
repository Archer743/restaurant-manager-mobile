import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/presentation/bloc/calendar_bloc.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/presentation/bloc/calendar_event.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/presentation/bloc/floor_plan/floor_plan_bloc.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/presentation/bloc/floor_plan/floor_plan_event.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/presentation/bloc/reservation_preview/reservation_preview_bloc.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/presentation/bloc/reservation_preview/reservation_preview_event.dart';

class ReservationRefreshCoordinator {
  // Confirmed Reservations Calendar
  final CalendarBloc? _calendarBloc;
  final List<DateTime> _rawDatesAffected = [];
  bool _refreshCalendarRequired = false;

  // Restaurant Floor Plan
  final FloorPlanBloc? _floorPlanBloc;
  final ReservationPreviewBloc? _reservationPreviewBloc;

  final DateTime? _date;
  final String? _shiftId;
  final String? _reservationId;

  bool _refreshFloorPlanRequired = false;
  bool _refreshReservationPreviewRequired = false;

  // This is the only place where final fields are directly initialized.
  ReservationRefreshCoordinator._internal({
    CalendarBloc? calendarBloc,
    FloorPlanBloc? floorPlanBloc,
    ReservationPreviewBloc? reservationPreviewBloc,
    DateTime? date,
    String? shiftId,
    String? reservationId,
  })  : _calendarBloc = calendarBloc,
        _floorPlanBloc = floorPlanBloc,
        _reservationPreviewBloc = reservationPreviewBloc,
        _date = date,
        _shiftId = shiftId,
        _reservationId = reservationId;

  ReservationRefreshCoordinator.forCalendar({
    required CalendarBloc calendarBloc,
  }) : this._internal(calendarBloc: calendarBloc);

  ReservationRefreshCoordinator.forFloorPlan({
    required FloorPlanBloc floorPlanBloc,
    required ReservationPreviewBloc reservationPreviewBloc,
    required DateTime date,
    required String reservationId,
    String? shiftId,
  }) : this._internal(
          floorPlanBloc: floorPlanBloc,
          reservationPreviewBloc: reservationPreviewBloc,
          date: date,
          reservationId: reservationId,
          shiftId: shiftId,
        );

  void requireCalendarRefresh(DateTime dateTimeUtc) {
    _rawDatesAffected.add(dateTimeUtc.toLocal());
    _refreshCalendarRequired = true;
  }

  void requireFloorPlanRefresh() {
    _refreshFloorPlanRequired = true;
  }

  void requireReservationPreviewRefresh() {
    _refreshReservationPreviewRequired = true;
  }

  void executeRefresh() {
    // Refresh calendar
    if (_refreshCalendarRequired && _calendarBloc != null) {
      _calendarBloc.add(RefreshCalendar(rawDatesAffected: _rawDatesAffected));
    }

    // Refresh floor plan
    if (_refreshFloorPlanRequired && _floorPlanBloc != null && _date != null) {
      _floorPlanBloc.add(GetFloorPlan(date: _date, shiftId: _shiftId));
    }

    // Refresh reservation preview in floor plan page
    if (_refreshReservationPreviewRequired &&
        _reservationPreviewBloc != null &&
        _reservationId != null) {
      _reservationPreviewBloc.add(GetReservationPreview(_reservationId));
    }
  }
}
