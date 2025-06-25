import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/config/theme/theme.dart';
import 'package:restaurant_manager_app/core/data/converters/app_timeofday_converter.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/domain/entities/reservation_preview.dart';

class ReservationCard extends StatelessWidget {
  final ReservationPreview reservation;

  const ReservationCard({
    super.key,
    required this.reservation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius)),
      color: primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            _buildTimeBlock(context),
            const SizedBox(width: 16.0),
            _buildMiddleBlock(context),
            if (reservation.isCreatedByStaff)
              Tooltip(
                message: 'Създадена от служител',
                child: Icon(Icons.verified_user, color: Colors.grey[400]),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeBlock(BuildContext context) {
    const timeOfDayConverter = AppTimeOfDayConverter();

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        timeOfDayConverter.formatTime(reservation.time),
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
              color: Theme.of(context).primaryColor,
            ),
      ),
    );
  }

  Widget _buildMiddleBlock(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            reservation.name,
            style: titleTextStyle,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4.0),
          Row(
            children: [
              Icon(Icons.people, size: 18, color: hintTextColor.toColor()),
              const SizedBox(width: 4.0),
              Text(
                reservation.peopleCount == 1
                    ? '1 гост'
                    : '${reservation.peopleCount} гости',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: hintTextColor.toColor(),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
