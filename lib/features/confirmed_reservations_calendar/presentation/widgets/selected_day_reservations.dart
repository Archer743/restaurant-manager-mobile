import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/config/theme/theme.dart';
import '../../domain/entities/reservation_preview.dart';
import 'reservation_card.dart';

class SelectedDayReservations extends StatelessWidget {
  final List<ReservationPreview> reservations;
  final void Function(ReservationPreview reservation) onTap;

  const SelectedDayReservations({
    super.key,
    required this.reservations,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (reservations.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            'Няма резервации на този ден',
            style: defaultTextStyle,
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: reservations.length,
        itemBuilder: (_, index) {
          final reservation = reservations[index];
          return ReservationCard(
            reservation: reservation,
            onTap: () => onTap(reservation),
          );
        },
      ),
    );
  }
}
