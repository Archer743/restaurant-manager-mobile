import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/config/theme/theme.dart';
import 'package:restaurant_manager_app/core/utils/timeofday_utils.dart';
import 'package:restaurant_manager_app/features/restaurant_floor_plan/domain/entities/shift_view.dart';

class ShiftFilter extends StatelessWidget {
  final List<ShiftView> allShifts;
  final int? selectedShiftIndex;
  final ValueChanged<int?> onShiftSelected;

  const ShiftFilter({
    super.key,
    required this.allShifts,
    required this.selectedShiftIndex,
    required this.onShiftSelected,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      // Aladin's lamp. Allows long text to be displayed without overflowing
      isExpanded: true,
      dropdownColor: primaryColor,
      value: selectedShiftIndex,
      items: allShifts.asMap().entries.map((entry) {
        final index = entry.key;
        final shift = entry.value;
        return DropdownMenuItem<int>(
          value: index,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                shift.name,
                style: const TextStyle(fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Text(
                '${shift.startTime.toHHMMString()} - ${shift.endTime.toHHMMString()}',
                style: TextStyle(fontSize: 13, color: hintTextColor.toColor()),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: onShiftSelected,
      selectedItemBuilder: (BuildContext context) {
        return allShifts.map((shift) {
          return Text(
            shift.name,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          );
        }).toList();
      },
    );
  }
}
