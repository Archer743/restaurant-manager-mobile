import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/config/theme/theme.dart';
import 'package:restaurant_manager_app/core/utils/color_utils.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/table_availability.dart';

class TableCard extends StatelessWidget {
  final TableAvailability table;
  final void Function(TableAvailability) onTableTap;
  final bool isSelected;
  final double _darkenAmount = .25;

  const TableCard({
    super.key,
    required this.table,
    required this.onTableTap,
    required this.isSelected,
  });

  Color _getBaseColor(TableStatus status) {
    switch (status) {
      case TableStatus.available:
        return successColor;
      case TableStatus.occupiedByOther:
        return warningColor;
      case TableStatus.reservedByCurrent:
        return actionColor;
    }
  }

  Border? _getSelectionBorder(TableStatus status, bool isSelected) {
    if (!isSelected) return null;

    final Color borderColor = switch (status) {
      TableStatus.available => successColor.darken(_darkenAmount),
      TableStatus.reservedByCurrent => warningColor.darken(_darkenAmount),
      _ => Colors.transparent,
    };

    return Border.all(
      color: borderColor,
      width: 4,
    );
  }

  Icon? _getSelectionIcon(TableStatus status, bool isSelected) {
    if (!isSelected) return null;

    final Color iconColor = switch (status) {
      TableStatus.available => successColor.darken(_darkenAmount),
      TableStatus.reservedByCurrent => warningColor.darken(_darkenAmount),
      _ => Colors.transparent,
    };

    return Icon(
      status == TableStatus.available ? Icons.add : Icons.remove,
      color: iconColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTableTap(table),
      child: Container(
        decoration: BoxDecoration(
          color: _getBaseColor(table.status),
          border: _getSelectionBorder(table.status, isSelected),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
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
            if (_getSelectionIcon(table.status, isSelected) != null)
              Positioned(
                right: 4,
                top: 0,
                child: _getSelectionIcon(table.status, isSelected)!,
              ),
          ],
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
