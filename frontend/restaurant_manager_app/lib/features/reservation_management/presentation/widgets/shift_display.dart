import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/config/theme/theme.dart';
import 'package:restaurant_manager_app/core/utils/timeofday_utils.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_shift_view.dart';
import 'package:restaurant_manager_app/core/domain/entities/table_availability.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/tables/tables_grid.dart';

class ShiftDisplay extends StatelessWidget {
  final ReservationShiftView shift;
  final Set<String> selectedTableIds;
  final void Function(TableAvailability) onTableTap;

  const ShiftDisplay({
    super.key,
    required this.shift,
    required this.selectedTableIds,
    required this.onTableTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildShiftInfoBlock(context),
        const SizedBox(height: 24.0),
        TablesGrid(
          tables: shift.tables,
          selectedTableIds: selectedTableIds,
          onTableTap: onTableTap,
        ),
      ],
    );
  }

  /// Display shift information (title and time range)
  Widget _buildShiftInfoBlock(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          shift.name,
          style: titleTextStyle,
        ),
        const SizedBox(width: 10.0),
        Text(
          '${shift.startTime.toHHMMString()} - ${shift.endTime.toHHMMString()}',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: hintTextColor.toColor(),
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
