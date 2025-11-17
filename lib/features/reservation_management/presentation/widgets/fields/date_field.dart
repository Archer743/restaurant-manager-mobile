import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/config/theme/theme.dart';
import 'package:restaurant_manager_app/core/utils/datetime_utils.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_form_mode.dart';

class DateField extends StatefulWidget {
  final TextEditingController rawController;
  final ReservationFormMode displayMode;

  const DateField({
    super.key,
    required this.rawController,
    required this.displayMode,
  });

  bool get isEditable {
    return displayMode == ReservationFormMode.create ||
        displayMode == ReservationFormMode.edit;
  }

  @override
  State<DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  late final TextEditingController _displayController;

  @override
  void initState() {
    super.initState();
    _displayController = TextEditingController(
      text: _formatForDisplay(widget.rawController.text),
    );
    widget.rawController.addListener(_syncFormattedValue);
  }

  void _syncFormattedValue() {
    _displayController.text = _formatForDisplay(widget.rawController.text);
  }

  String _formatForDisplay(String raw) {
    try {
      final parsed = DateTime.parse(raw);
      return parsed.toBulgarianDateString(); // e.g., 17 юни 2025
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
        prefixIcon: const Icon(Icons.event_note),
        suffixIcon: widget.displayMode == ReservationFormMode.edit
            ? const Icon(Icons.edit)
            : null,
        labelText: 'Дата',
        hintText: 'Изберете дата',
      ),
      onTap: widget.isEditable
          ? () async {
              late final DateTime initialDate;

              try {
                initialDate = DateTime.parse(widget.rawController.text);
              } catch (_) {
                initialDate = DateTime.now(); // Local time
              }

              final picked = await showDatePicker(
                context: context,
                initialDate: initialDate,
                firstDate: DateTime(2025, 1, 1),
                lastDate: DateTime(
                  DateTime.now().year + 5,
                  DateTime.now().month,
                  DateTime.now().day,
                ),
                initialEntryMode: DatePickerEntryMode.calendarOnly,
                locale: const Locale('bg'),
                builder: (context, child) {
                  return Theme(
                    data: datePickerTheme,
                    child: child!,
                  );
                },
              );

              // 'picked' also is in local time
              if (picked != null) {
                widget.rawController.text = picked.toYYYYMMDDString();
              }
            }
          : null,
      validator: (value) {
        if (widget.rawController.text.trim().isEmpty) {
          return 'Изберете дата';
        }
        return null;
      },
    );
  }
}
