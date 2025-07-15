import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/config/theme/theme.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/table_availability.dart';

class TableCard extends StatelessWidget {
  final TableAvailability table;
  final void Function(TableAvailability) onTableTap;

  const TableCard({
    super.key,
    required this.table,
    required this.onTableTap,
  });

  Color _getColor(TableStatus status) {
    switch (status) {
      case TableStatus.available:
        return successColor;
      case TableStatus.occupiedByOther:
        return warningColor;
      case TableStatus.reservedByCurrent:
        return actionColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTableTap(table),
      child: Container(
        decoration: BoxDecoration(
          color: _getColor(table.status),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Маса ${table.tableNumber}',
                style: defaultTextStyle,
              ),
              _buildCapacityRow(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCapacityRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${table.capacity}x',
          style: defaultTextStyle,
        ),
        Icon(Icons.person, size: 18, color: textColor.toColor()),
      ],
    );
  }
}
