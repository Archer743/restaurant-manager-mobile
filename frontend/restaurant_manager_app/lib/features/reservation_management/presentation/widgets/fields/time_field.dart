import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/config/theme/theme.dart';
import 'package:restaurant_manager_app/core/data/converters/app_timeofday_converter.dart';

class TimeField extends StatefulWidget {
  final TextEditingController rawController;
  final bool isEditable;
  late final AppTimeOfDayConverter timeOfDayConverter;

  TimeField({
    super.key,
    required this.rawController,
    required this.isEditable,
  }) {
    timeOfDayConverter = const AppTimeOfDayConverter();
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
      text: widget.timeOfDayConverter.formatTime(widget.rawController.text),
    );
    widget.rawController.addListener(_syncFormattedValue);
  }

  void _syncFormattedValue() {
    _displayController.text =
        widget.timeOfDayConverter.formatTime(widget.rawController.text);
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
        suffixIcon: widget.isEditable ? const Icon(Icons.edit) : null,
        labelText: 'Час',
      ),
      onTap: widget.isEditable
          ? () async {
              final initialTime =
                  widget.timeOfDayConverter.fromJson(widget.rawController.text);

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

              if (picked != null) {
                widget.rawController.text =
                    widget.timeOfDayConverter.toJson(picked);
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
