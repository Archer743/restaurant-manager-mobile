import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_manager_app/config/routing/app_routes.dart';
import 'package:restaurant_manager_app/core/presentation/services/snackbar_service.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/domain/utils/calendar_date_utils.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/coordinators/reservation_refresh_coordinator.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../domain/entities/reservation_preview.dart';
import '../bloc/calendar_bloc.dart';
import '../bloc/calendar_event.dart';
import '../bloc/calendar_state.dart';
import '../widgets/calendar_view.dart';
import '../widgets/selected_day_reservations.dart';

class ConfirmedReservationsCalendarPage extends StatefulWidget {
  const ConfirmedReservationsCalendarPage({super.key});

  @override
  State<ConfirmedReservationsCalendarPage> createState() =>
      _ConfirmedReservationsCalendarPageState();
}

class _ConfirmedReservationsCalendarPageState
    extends State<ConfirmedReservationsCalendarPage> {
  late final DateTime _firstCalendarDay;
  late final DateTime _lastCalendarDay;

  late DateTime _focusedDay; // The day that determines which month is visible
  late DateTime _selectedDay; // The day the user clicked

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    _focusedDay = _selectedDay = CalendarDateUtils.normalizeDate(now);

    // 3 months history, 6 months forward
    _firstCalendarDay = DateTime.utc(now.year, now.month - 3, 1);
    _lastCalendarDay = DateTime.utc(now.year, now.month + 6, 0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchMonthData(_focusedDay);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Потвърдени резервации')),
      body: BlocConsumer<CalendarBloc, CalendarState>(
        listener: _listener,
        builder: (context, state) {
          return Column(
            children: [
              CalendarView(
                firstDay: _firstCalendarDay,
                lastDay: _lastCalendarDay,
                focusedDay: _focusedDay,
                selectedDay: _selectedDay,
                onDaySelected: _onDaySelected,
                onPageChanged: _onPageChanged,
                eventLoader: (day) {
                  if (state is! CalendarLoaded) return [];
                  return state.reservations[day] ?? [];
                },
              ),
              SelectedDayReservations(
                reservations: state is CalendarLoaded
                    ? state.reservations[_selectedDay] ?? []
                    : [],
                onTap: _openReservation,
              ),
            ],
          );
        },
      ),
      floatingActionButton: _buildFab(),
    );
  }

  void _fetchMonthData(DateTime focusedDay) {
    context.read<CalendarBloc>().add(GetReservationsForMonth(focusedDay));
  }

  void _listener(BuildContext context, CalendarState state) {
    if (state is CalendarReload) {
      context.read<CalendarBloc>().add(GetReservationsForMonth(_focusedDay));
    } else if (state is CalendarError) {
      SnackBarService.showFailure(context, state.failure);

      if (state.failure.requiresReauthentication) {
        context.go(AppRoutes.welcome);
      }
    }
  }

  void _openReservation(ReservationPreview reservation) {
    final coordinator = ReservationRefreshCoordinator.forCalendar(
      calendarBloc: context.read<CalendarBloc>(),
    );

    context.push(
      '${AppRoutes.reservation}/${reservation.id}',
      extra: coordinator,
    );
  }

  // Both provided days are normalized
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  // Here focusedDay is the first day of the current visible month (normalized)
  void _onPageChanged(DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;

      // Keep the selected day in sync with the currently visible month.
      // We try to recreate the selected day using the same day number
      // in the newly focused month.
      DateTime newSelectedDay =
          DateTime.utc(_focusedDay.year, _focusedDay.month, _selectedDay.day);

      if (newSelectedDay.month != _focusedDay.month) {
        // Day 0 is the last day of the previous month
        _selectedDay = DateTime.utc(_focusedDay.year, _focusedDay.month + 1, 0);
      } else {
        _selectedDay = newSelectedDay;
      }
    });

    _fetchMonthData(focusedDay);
  }

  // Create new reservation button
  Widget _buildFab() {
    return FloatingActionButton(
      onPressed: () {
        context.push(
          AppRoutes.reservation,
          extra: {
            'initialDateLocal': DateTime(
                _selectedDay.year, _selectedDay.month, _selectedDay.day),
          },
        );
      },
      child: const Icon(Icons.add),
    );
  }
}
