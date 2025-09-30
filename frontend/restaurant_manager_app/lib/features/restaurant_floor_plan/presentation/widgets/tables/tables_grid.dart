import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/core/domain/entities/table_availability.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/presentation/widgets/tables/table_card.dart';

class TablesGrid extends StatelessWidget {
  final List<TableAvailability> tables;
  final Future<void> Function(TableAvailability) onTableTap;
  final String? selectedReservationId;

  const TablesGrid({
    super.key,
    required this.tables,
    required this.onTableTap,
    this.selectedReservationId,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: tables.length,
      itemBuilder: (context, index) {
        final table = tables[index];
        final isSelected = table.reservationId != null &&
            table.reservationId == selectedReservationId;

        return TableCard(
          table: table,
          onTableTap: onTableTap,
          isSelected: isSelected,
        );
      },
    );
  }
}
