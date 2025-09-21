import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/core/domain/entities/table_availability.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/presentation/widgets/tables/table_card.dart';

class TablesGrid extends StatefulWidget {
  final List<TableAvailability> tables;
  final void Function(TableAvailability) onTableTap;

  const TablesGrid({
    super.key,
    required this.tables,
    required this.onTableTap,
  });

  @override
  State<TablesGrid> createState() => _TablesGridState();
}

class _TablesGridState extends State<TablesGrid> {
  String? _selectedReservationId;

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
      itemCount: widget.tables.length,
      itemBuilder: (context, index) {
        final table = widget.tables[index];
        final isSelected = table.reservationId != null &&
            table.reservationId == _selectedReservationId;

        return TableCard(
          table: table,
          onTableTap: (table) {
            if (table.status == TableStatus.reserved) {
              setState(() {
                // If it is already selected - clear
                if (_selectedReservationId == table.reservationId) {
                  _selectedReservationId = null;
                } else {
                  _selectedReservationId = table.reservationId;
                }
              });
            }

            widget.onTableTap(table);
          },
          isSelected: isSelected,
        );
      },
    );
  }
}
