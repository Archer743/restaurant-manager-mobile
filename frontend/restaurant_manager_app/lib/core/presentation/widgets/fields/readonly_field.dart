import 'package:flutter/material.dart';

class ReadOnlyField extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;

  const ReadOnlyField({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
      ),
    );
  }
}
