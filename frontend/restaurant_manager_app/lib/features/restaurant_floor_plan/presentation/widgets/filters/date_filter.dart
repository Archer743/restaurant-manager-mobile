import 'package:flutter/material.dart';
import 'package:restaurant_manager_app/config/theme/theme.dart';
import 'package:restaurant_manager_app/core/utils/datetime_utils.dart';

class DateFilter extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateSelected;
  final bool isEnabled;

  const DateFilter({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
    this.isEnabled = true,
  });

  @override
  State<DateFilter> createState() => _DateFilterState();
}

class _DateFilterState extends State<DateFilter> {
  late final TextEditingController _displayController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _displayController = TextEditingController(
      text: _selectedDate.toDDMMYYYYString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _displayController,
      readOnly: true,
      decoration: const InputDecoration(
        labelText: 'Дата',
        prefixIcon: Icon(Icons.event_note),
      ),
      onTap: widget.isEnabled
          ? () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
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

              if (pickedDate != null && pickedDate != _selectedDate) {
                setState(() {
                  _selectedDate = pickedDate;
                  _displayController.text = _selectedDate.toDDMMYYYYString();
                });
                widget.onDateSelected(pickedDate);
              }
            }
          : null,
    );
  }

  @override
  void dispose() {
    _displayController.dispose();
    super.dispose();
  }
}
