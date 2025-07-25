import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/config/theme/theme.dart';
import 'package:restaurant_manager_app/core/utils/timeofday_utils.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/shift_view.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/table_availability.dart';
import 'package:restaurant_manager_app/features/reservation_management/presentation/widgets/tables/tables_grid.dart';

class ShiftInfo extends StatelessWidget {
  final ShiftView shift;
  final Set<String> selectedTableIds;
  final void Function(TableAvailability) onTableTap;

  const ShiftInfo({
    super.key,
    required this.shift,
    required this.selectedTableIds,
    required this.onTableTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: 30,
          bottom: 100, // Leaves space for the save button
        ),
        child: Column(
          children: [
            _buildShiftInfoBlock(context),
            const SizedBox(height: 24.0),
            TablesGrid(
              tables: shift.tables,
              selectedTableIds: selectedTableIds,
              onTableTap: onTableTap,
            ),
          ],
        ),
      ),
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
