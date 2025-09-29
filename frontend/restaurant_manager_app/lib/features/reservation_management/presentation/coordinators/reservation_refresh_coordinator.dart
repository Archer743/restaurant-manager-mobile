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
  bool _dismissReservationPreviewRequired = false;

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

  void requirePreviewDismiss() {
    _dismissReservationPreviewRequired = true;
  }

  // TODO: Improve preview dismiss and refresh - handle difficult states like:
  //- when reservation date is changed to a different day from the one that is displayed in floor plan
  //- when reservation is closed and then activated again + tables are added
  //- when all tables are removed
  // TODO: It's bad practice to use a BLoC event to trigger navigation or transient side effects like closing a modal
  void executeRefresh() {
    // Refresh calendar
    if (_refreshCalendarRequired && _calendarBloc != null) {
      _calendarBloc.add(RefreshCalendar(rawDatesAffected: _rawDatesAffected));
    }

    // Refresh or dismiss reservation preview in floor plan page
    if (_reservationPreviewBloc != null) {
      if (_dismissReservationPreviewRequired) {
        _reservationPreviewBloc.add(DismissReservationPreview());
      } else if (_refreshReservationPreviewRequired && _reservationId != null) {
        _reservationPreviewBloc.add(GetReservationPreview(_reservationId));
      }
    }

    // Refresh floor plan
    if (_refreshFloorPlanRequired && _floorPlanBloc != null && _date != null) {
      _floorPlanBloc.add(GetFloorPlan(date: _date, shiftId: _shiftId));
    }
  }
}
