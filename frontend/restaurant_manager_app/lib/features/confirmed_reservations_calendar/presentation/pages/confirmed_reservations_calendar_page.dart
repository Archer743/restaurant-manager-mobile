import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_manager_app/config/routing/app_routes.dart';
import 'package:restaurant_manager_app/core/errors/error_mapper.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';
import 'package:restaurant_manager_app/core/presentation/services/snackbar_service.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/domain/entities/reservation_preview.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/domain/typedefs.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/presentation/bloc/calendar_bloc.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/presentation/bloc/calendar_event.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/presentation/bloc/calendar_state.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/presentation/widgets/reservation_card.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:restaurant_manager_app/config/theme/theme.dart';

class ConfirmedReservationsCalendarPage extends StatefulWidget {
  const ConfirmedReservationsCalendarPage({super.key});

  @override
  State<ConfirmedReservationsCalendarPage> createState() =>
      _ConfirmedReservationsCalendarPageState();
}

class _ConfirmedReservationsCalendarPageState
    extends State<ConfirmedReservationsCalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final DateTime _firstDay = DateTime.utc(2025, 1, 1);
  late final DateTime _lastDay;

  CalendarConfirmedReservations _currMonthReservations = {};
  final ValueNotifier<List<ReservationPreview>> _selectedDayReservations =
      ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;

    // Calculate _lastDay: 5 years from now
    _lastDay = DateTime.utc(
      DateTime.now().year + 5,
      DateTime.now().month,
      DateTime.now().day,
    );

    // Dispatch the initial event to fetch reservations for the current month
    // WidgetsBinding.instance.addPostFrameCallback is used to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CalendarBloc>().add(FetchReservationsForMonth(_focusedDay));
    });
  }

  // --- Table Calendar Event Loader ---
  List<ReservationPreview> _getReservationsForDay(DateTime day) {
    final normalizedDay = DateTime.utc(day.year, day.month, day.day);
    return _currMonthReservations[normalizedDay] ?? [];
  }

  // --- Calendar Callbacks ---
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedDayReservations.value = _getReservationsForDay(selectedDay);
      });
    }
  }

  void _onPageChanged(DateTime focusedDay) {
    setState(() => _focusedDay = focusedDay);

    context.read<CalendarBloc>().add(FetchReservationsForMonth(focusedDay));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Потвърдени резервации')),
      body: BlocConsumer<CalendarBloc, CalendarState>(
        listener: (context, state) {
          if (state is CalendarLoaded) {
            setState(
              () {
                _currMonthReservations = state.reservations;

                if (_selectedDay != null) {
                  _selectedDayReservations.value =
                      _getReservationsForDay(_selectedDay!);
                }
              },
            );
          } else if (state is CalendarError) {
            SnackBarService.showFailure(context, state.failure);

            if (state.requiresReauthentication) {
              context.go(AppRoutes.welcome);
            }
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              _buildCalendar(),
              state is CalendarLoaded
                  ? _buildSelectedReservationsList()
                  : const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCalendar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 5, // Subtle shadow for depth
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        clipBehavior: Clip.antiAlias, // Ensures content respects border radius
        color: primaryColor.withOpacity(0.1),
        child: TableCalendar(
          firstDay: _firstDay,
          lastDay: _lastDay,
          focusedDay: _focusedDay,
          locale: 'bg_BG',
          calendarFormat: CalendarFormat.month,
          startingDayOfWeek: StartingDayOfWeek.monday,
          availableGestures: AvailableGestures.horizontalSwipe,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: _onDaySelected,
          onPageChanged: _onPageChanged,
          eventLoader: _getReservationsForDay,
          headerStyle: calendarHeaderStyle,
          daysOfWeekStyle: calendarDaysOfWeekStyle,
          calendarStyle: calendarStyle,
        ),
      ),
    );
  }

  Widget _buildSelectedReservationsList() {
    return ValueListenableBuilder(
        valueListenable: _selectedDayReservations,
        builder: (context, reservations, _) {
          if (reservations.isEmpty) {
            return Expanded(
              child: Center(
                child: Text('Няма резервации на този ден',
                    style: defaultTextStyle),
              ),
            );
          }

          return Expanded(
            child: ListView.builder(
                itemCount: reservations.length,
                itemBuilder: (context, index) {
                  final r = reservations[index];
                  return ReservationCard(reservation: r);
                }),
          );
        });
  }
}
