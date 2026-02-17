import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:restaurant_manager_app/config/theme/theme.dart';
import '../../domain/entities/reservation_preview.dart';

class CalendarView extends StatelessWidget {
  final DateTime firstDay;
  final DateTime lastDay;
  final DateTime focusedDay;
  final DateTime selectedDay;
  final void Function(DateTime selected, DateTime focused) onDaySelected;
  final void Function(DateTime focused) onPageChanged;
  final List<ReservationPreview> Function(DateTime day) eventLoader;

  const CalendarView({
    super.key,
    required this.firstDay,
    required this.lastDay,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    required this.onPageChanged,
    required this.eventLoader,
  });

  @override
  Widget build(BuildContext context) {
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
          firstDay: firstDay,
          lastDay: lastDay,
          focusedDay: focusedDay,
          locale: 'bg_BG',
          calendarFormat: CalendarFormat.month,
          startingDayOfWeek: StartingDayOfWeek.monday,
          selectedDayPredicate: (day) => isSameDay(selectedDay, day),
          onDaySelected: onDaySelected,
          onPageChanged: onPageChanged,
          eventLoader: eventLoader,
          headerStyle: calendarHeaderStyle,
          daysOfWeekStyle: calendarDaysOfWeekStyle,
          calendarStyle: calendarStyle,
        ),
      ),
    );
  }
}
