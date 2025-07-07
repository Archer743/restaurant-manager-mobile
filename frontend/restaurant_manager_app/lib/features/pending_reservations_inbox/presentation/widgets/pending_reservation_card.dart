import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/config/theme/theme.dart';
import 'package:restaurant_manager_app/core/utils/datetime_utils.dart';
import 'package:restaurant_manager_app/core/utils/timeofday_utils.dart';
import 'package:restaurant_manager_app/features/pending_reservations_inbox/domain/entities/pending_reservation_preview.dart';

class PendingReservationCard extends StatelessWidget {
  final PendingReservationPreview reservation;
  // Callbacks for actions
  final VoidCallback? onApprove;
  final VoidCallback? onDecline;

  const PendingReservationCard({
    super.key,
    required this.reservation,
    this.onApprove,
    this.onDecline,
  });

  /// Determine if the reservation is "new" (e.g., created within the last hour)
  bool get isNew {
    return DateTime.now()
            .toUtc()
            .difference(reservation.createdAtUtc)
            .inMinutes <
        60;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      color: primaryColor,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTimeBlock(context),
                  const SizedBox(width: 16.0),
                  Expanded(child: _buildInfoBlock(context)),
                ],
              ),
              // const Divider(height: 24.0, thickness: 1.0),
              const SizedBox(height: 20), // Visual separator
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeBlock(BuildContext context) {
    final (localDate, localTime) =
        extractLocalComponentsFromUtc(reservation.startTimeUtc);

    return Container(
      width: 70,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        children: [
          Text(
            localTime.toHHMMString(),
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                  color: Theme.of(context).primaryColor,
                ),
          ),
          Text(
            localDate.toSmartBulgarianDateString(),
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor.withOpacity(0.9),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBlock(BuildContext context) {
    final (localDate, localTime) =
        extractLocalComponentsFromUtc(reservation.createdAtUtc);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              reservation.name,
              style: titleTextStyle,
              overflow: TextOverflow.ellipsis,
            ),
            if (isNew) _buildNewBadge(context),
          ],
        ),
        const SizedBox(height: 4.0),
        Row(
          children: [
            _buildGuestCountRow(context),
            _buildSeparator(),
            _buildCreatedAtRow(context, localDate, localTime),
          ],
        ),

        // Display creation time
      ],
    );
  }

  Widget _buildNewBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: actionColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        'НОВА',
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildGuestCountRow(BuildContext context) {
    return Row(
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
    );
  }

  Widget _buildSeparator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: hintTextColor.toColor(),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildCreatedAtRow(
      BuildContext context, DateTime localDate, TimeOfDay localTime) {
    return Row(
      children: [
        Icon(Icons.inbox, size: 18, color: hintTextColor.toColor()),
        const SizedBox(width: 4),
        Text(
          '${localDate.toSmartBulgarianDateString()}, ${localTime.toHHMMString()}',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w600,
                color: hintTextColor.toColor(),
              ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceEvenly, // Distribute buttons evenly
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onApprove,
            icon: const Icon(Icons.check, size: 18),
            label: const Text('Одобри'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green, // Green for approve
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius)),
            ),
          ),
        ),
        const SizedBox(width: 16.0), // Space between buttons
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onDecline,
            icon: const Icon(Icons.close, size: 18),
            label: const Text('Откажи'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Red for decline
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius)),
            ),
          ),
        ),
      ],
    );
  }
}
