import 'package:flutter/material.dart';

/// Returns spacing as a percentage of screen height.
/// Example: spacingByHeight(context, 0.02) -> 2% of height
double spacingByHeight(BuildContext context, double factor) {
  if (!context.mounted) return 0.0;

  final height = MediaQuery.of(context).size.height;
  return height * factor;
}

/// Returns spacing as a percentage of screen width.
/// Example: spacingByWidth(context, 0.02) -> 2% of width
double spacingByWidth(BuildContext context, double factor) {
  if (!context.mounted) return 0.0;

  final width = MediaQuery.of(context).size.width;
  return width * factor;
}
