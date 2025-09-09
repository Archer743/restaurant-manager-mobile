import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/config/theme/theme.dart';
import 'package:restaurant_manager_app/core/utils/timeofday_utils.dart';
import 'package:restaurant_manager_app/features/confirmed_reservations_calendar/domain/entities/reservation_preview.dart';

class ReservationCard extends StatelessWidget {
  final ReservationPreview reservation;
  final VoidCallback onTap;

  const ReservationCard({
    super.key,
    required this.reservation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius)),
      color: primaryColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopRow(),
              const SizedBox(height: 12),
              _buildBottomRow(),
            ],
          ),
        ),
      ),
    );
  }

  // Top row: Tag, Name, Time
  Widget _buildTopRow() {
    return Row(
      children: [
        // Tag chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.shade600,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            reservation.tag,
            style: TextStyle(
              color: textColor.toColor(),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Name
        Expanded(
          child: Text(reservation.name, style: defaultTextStyle),
        ),
        const SizedBox(width: 4),
        // Time
        Row(
          children: [
            const Icon(Icons.access_time, size: 18),
            const SizedBox(width: 4),
            Text(
              reservation.time.toHHMMString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
      ],
    );
  }

  // Bottom row: People count, IsClosed
  Widget _buildBottomRow() {
    return Row(
      children: [
        Row(
          children: [
            const Icon(Icons.people, size: 18),
            const SizedBox(width: 4),
            Text(
              reservation.peopleCount == 1
                  ? '1 гост'
                  : '${reservation.peopleCount} гости',
            ),
          ],
        ),
        const Spacer(),
        Row(
          children: [
            Icon(
              reservation.isClosed
                  ? Icons.check_circle
                  : Icons.hourglass_bottom,
              size: 18,
              color: reservation.isClosed ? successColor : actionColor,
            ),
            const SizedBox(width: 4),
            Text(
              reservation.isClosed ? "Приключена" : "Активна",
              style: TextStyle(
                color: reservation.isClosed ? successColor : actionColor,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        )
      ],
    );
  }
}
