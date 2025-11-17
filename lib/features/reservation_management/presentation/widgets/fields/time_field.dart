import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/config/theme/theme.dart';
import 'package:restaurant_manager_app/core/utils/timeofday_utils.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_form_mode.dart';

class TimeField extends StatefulWidget {
  final TextEditingController rawController;
  final ReservationFormMode displayMode;

  const TimeField({
    super.key,
    required this.rawController,
    required this.displayMode,
  });

  bool get isEditable {
    return displayMode == ReservationFormMode.create ||
        displayMode == ReservationFormMode.edit;
  }

  @override
  State<TimeField> createState() => _TimeFieldState();
}

class _TimeFieldState extends State<TimeField> {
  late final TextEditingController _displayController;

  @override
  void initState() {
    super.initState();
    _displayController = TextEditingController(
        text: _formatForDisplay(widget.rawController.text));
    widget.rawController.addListener(_syncFormattedValue);
  }

  void _syncFormattedValue() {
    _displayController.text = _formatForDisplay(widget.rawController.text);
  }

  String _formatForDisplay(String raw) {
    try {
      final TimeOfDay time = parseTimeOfDay(raw);
      return time.toHHMMString();
    } catch (_) {
      return '';
    }
  }

  @override
  void dispose() {
    widget.rawController.removeListener(_syncFormattedValue);
    _displayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _displayController,
      readOnly: true,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.access_time),
        suffixIcon: widget.displayMode == ReservationFormMode.edit
            ? const Icon(Icons.edit)
            : null,
        labelText: 'Час',
        hintText: 'Изберете час',
      ),
      onTap: widget.isEditable
          ? () async {
              late final TimeOfDay initialTime;

              try {
                initialTime = parseTimeOfDay(widget.rawController.text);
              } catch (_) {
                initialTime = TimeOfDay.now(); // Local time
              }

              final picked = await showTimePicker(
                context: context,
                initialTime: initialTime,
                builder: (context, child) {
                  return Theme(
                    data: timePickerTheme,
                    child: child!,
                  );
                },
              );

              // 'picked' also is in local time
              if (picked != null) {
                widget.rawController.text = picked.toHHMMSSString();
              }
            }
          : null,
      validator: (value) {
        if (widget.rawController.text.trim().isEmpty) {
          return 'Изберете час';
        }
        return null;
      },
    );
  }
}
