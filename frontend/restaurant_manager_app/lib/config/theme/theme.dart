import 'package:flutter/material.dart';

// Main UI Colors
const Color bgColor = Color(0xFF082040);
const Color primaryColor = Color(0xFF1B578C);
const Color secondaryColor = Color(0xFF4AA2D9);
const Color accentColor = Color(0xFF6DCCF2);
const Color actionColor = Color(0xFFFFC107);
const Color successColor = Color(0xFF34C759);
const Color warningColor = Color(0xFFF25C54);

// Text Colors
const HSLColor textColor = HSLColor.fromAHSL(1.0, 0, 0.0, 0.92); // #EAEAEA

const HSLColor hintTextColor =
    HSLColor.fromAHSL(1.0, 0, 0.0, 0.60); // Hint (dimmer)

const HSLColor actionButtonTextColor =
    HSLColor.fromAHSL(1.0, 0, 0.0, 0.2); // #333333

// Icon Colors
const Color inputIconColor = Color(0xFFEAEAEA);
const Color actionIconColor = actionColor;

// Text Styles
const elevatedButtonTextStyle =
    TextStyle(fontSize: 19, fontWeight: FontWeight.w700);
final appBarTextStyle = TextStyle(
    color: textColor.toColor(), fontSize: 26, fontWeight: FontWeight.w600);
final snackBarTextStyle = TextStyle(
    color: textColor.toColor(), fontSize: 16, fontWeight: FontWeight.w600);

// Border Settings
const double borderRadius = 12;
const double borderWidth = 1.7;
const double borderFocusedWidth = 3;

// Input Fields
final darkInputDecorationTheme = InputDecorationTheme(
  filled: true,
  fillColor: bgColor,
  prefixIconColor: inputIconColor,
  suffixIconColor: inputIconColor,
  labelStyle: TextStyle(color: textColor.toColor()),
  hintStyle: TextStyle(color: hintTextColor.toColor()),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(borderRadius),
    borderSide: const BorderSide(color: primaryColor, width: borderWidth),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(borderRadius),
    borderSide:
        const BorderSide(color: primaryColor, width: borderFocusedWidth),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(borderRadius),
    borderSide: const BorderSide(color: warningColor, width: borderWidth),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(borderRadius),
    borderSide:
        const BorderSide(color: warningColor, width: borderFocusedWidth),
  ),
  errorStyle: const TextStyle(color: warningColor),
  errorMaxLines: 2,
);

// Action Buttons
final darkElevatedButtonTheme = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: secondaryColor,
    disabledBackgroundColor: primaryColor,
    foregroundColor: actionButtonTextColor.toColor(),
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    // padding: const EdgeInsets.symmetric(vertical: 16),
    minimumSize: const Size(double.infinity, 50),
    textStyle: elevatedButtonTextStyle,
  ),
);

// SnackBars
final baseSnackBarTheme = SnackBarThemeData(
  behavior: SnackBarBehavior.floating,
  shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
  contentTextStyle: snackBarTextStyle,
);

final darkAppBarTheme = AppBarTheme(
  backgroundColor: bgColor,
  centerTitle: true,
  titleTextStyle: appBarTextStyle,
  iconTheme: const IconThemeData(color: actionIconColor),
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: bgColor,
  appBarTheme: darkAppBarTheme,
  inputDecorationTheme: darkInputDecorationTheme,
  elevatedButtonTheme: darkElevatedButtonTheme,
  snackBarTheme: baseSnackBarTheme,
);
