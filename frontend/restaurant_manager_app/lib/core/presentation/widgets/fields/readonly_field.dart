import 'package:flutter/material.dart';

class ReadOnlyField extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final Widget? suffixIcon;

  const ReadOnlyField({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        labelText: label,
      ),
    );
  }
}
