import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_manager_app/config/theme/theme.dart';
import 'package:restaurant_manager_app/core/data/converters/app_dateonly_converter.dart';
import 'package:restaurant_manager_app/features/reservation_management/domain/entities/reservation_form_mode.dart';

class DateField extends StatefulWidget {
  final TextEditingController rawController;
  final ReservationFormMode displayMode;
  late final AppDateOnlyConverter dateOnlyConverter;

  DateField({
    super.key,
    required this.rawController,
    required this.displayMode,
  }) {
    dateOnlyConverter = const AppDateOnlyConverter();
  }

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
      text: _format(widget.rawController.text),
    );
    widget.rawController.addListener(_syncFormattedValue);
  }

  void _syncFormattedValue() {
    _displayController.text = _format(widget.rawController.text);
  }

  String _format(String raw) {
    try {
      final parsed = widget.dateOnlyConverter.fromJson(raw);
      return DateFormat.yMMMMd('bg').format(parsed); // e.g., 17 юни 2025
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
              DateTime initialDate;

              try {
                initialDate = DateTime.parse(widget.rawController.text);
              } catch (_) {
                initialDate = DateTime.now();
              }

              final picked = await showDatePicker(
                context: context,
                initialDate: initialDate,
                firstDate: DateTime.utc(2025, 1, 1),
                lastDate: DateTime.utc(
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

              if (picked != null) {
                widget.rawController.text =
                    widget.dateOnlyConverter.toJson(picked);
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
