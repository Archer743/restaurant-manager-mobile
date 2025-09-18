import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

// Main UI Colors
const Color bgColor = Color(0xFF082040);
const Color primaryColor = Color(0xFF1B578C);
const Color secondaryColor = Color(0xFF4AA2D9);
const Color accentColor = Color(0xFF6DCCF2);
const Color actionColor = Color(0xCCFFC107);
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
final appBarTextStyle = TextStyle(
    color: textColor.toColor(), fontSize: 26, fontWeight: FontWeight.w600);
final titleTextStyle = TextStyle(
    color: textColor.toColor(), fontSize: 21, fontWeight: FontWeight.w600);
const elevatedButtonTextStyle =
    TextStyle(fontSize: 19, fontWeight: FontWeight.w700);
final snackBarTextStyle = TextStyle(
    color: textColor.toColor(), fontSize: 16, fontWeight: FontWeight.w600);
final defaultTextStyle = TextStyle(
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
    borderSide: const BorderSide(color: primaryColor, width: borderWidth),
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

// Expansion Tile
final darkExpansionTileTheme = ExpansionTileThemeData(
  backgroundColor: bgColor, // tile background
  collapsedBackgroundColor: bgColor, // collapsed background
  iconColor: accentColor, // expanded icon color
  collapsedIconColor: hintTextColor.toColor(), // collapsed icon color
  textColor: accentColor, // expanded title color
  collapsedTextColor: hintTextColor.toColor(), // collapsed title color
  shape: RoundedRectangleBorder(
    // expanded shape
    borderRadius: BorderRadius.circular(borderRadius),
  ),
  collapsedShape: RoundedRectangleBorder(
    // collapsed shape
    borderRadius: BorderRadius.circular(borderRadius),
  ),
  tilePadding: const EdgeInsets.symmetric(),
  childrenPadding: const EdgeInsets.symmetric(),
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

final darkOutlinedButtonTheme = OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    foregroundColor: textColor.toColor(),
    backgroundColor: Colors.transparent,
    side: BorderSide(
        color: textColor.toColor().withOpacity(0.5), width: borderWidth),
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    minimumSize: const Size(double.infinity, 50),
    textStyle: elevatedButtonTextStyle.copyWith(color: textColor.toColor()),
  ),
);

final floatingActionButtonTheme = FloatingActionButtonThemeData(
  backgroundColor: secondaryColor,
  foregroundColor: actionButtonTextColor.toColor(),
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(borderRadius),
  ),
);

// PopupMenuButton
final darkPopupMenuTheme = PopupMenuThemeData(
  color: primaryColor,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(borderRadius),
  ),
  position: PopupMenuPosition.under,
  textStyle: defaultTextStyle,
);

// SnackBars
final baseSnackBarTheme = SnackBarThemeData(
  behavior: SnackBarBehavior.floating,
  shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
  contentTextStyle: snackBarTextStyle,
);

// Dialogs
final darkCupertinoDialogTheme = CupertinoThemeData(
  primaryColor: secondaryColor,
  scaffoldBackgroundColor: bgColor,
  barBackgroundColor: primaryColor,
  textTheme: CupertinoTextThemeData(
    textStyle: defaultTextStyle.copyWith(color: textColor.toColor()),
  ),
);

// App Bar
final darkAppBarTheme = AppBarTheme(
  backgroundColor: bgColor,
  centerTitle: true,
  titleTextStyle: appBarTextStyle,
  iconTheme: const IconThemeData(color: actionIconColor),

  elevation: 0, // No shadow when not scrolled
  scrolledUnderElevation: 0, // No shadow when content scrolls under it
  shadowColor: Colors.transparent, // Ensure no shadow color is applied
  surfaceTintColor: Colors.transparent,
);

// Tab Bar
final tabBarTheme = TabBarTheme(
  labelColor: accentColor, // Active tab text color
  unselectedLabelColor: hintTextColor.toColor(),
  labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
  unselectedLabelStyle:
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  indicator: const UnderlineTabIndicator(
    borderSide: BorderSide(width: 3, color: accentColor),
  ),
);

// Home Navigation Bar
final navigationBarTheme = NavigationBarThemeData(
  backgroundColor: primaryColor,
  indicatorColor: secondaryColor,
  labelTextStyle: MaterialStateProperty.all(
    const TextStyle(fontSize: 0), // effectively hides label
  ),
  iconTheme: MaterialStateProperty.resolveWith<IconThemeData>((states) {
    // if (states.contains(MaterialState.selected)) {
    //   return const IconThemeData(color: accentColor);
    // }
    return const IconThemeData(size: 28, color: bgColor);
  }),
);

// Calendar
final calendarHeaderStyle = HeaderStyle(
  formatButtonVisible: false,
  titleCentered: true,
  titleTextStyle: titleTextStyle,
  leftChevronIcon: const Icon(Icons.chevron_left, color: accentColor),
  rightChevronIcon: const Icon(Icons.chevron_right, color: accentColor),
  decoration: const BoxDecoration(
    color: primaryColor, // Header background
  ),
);

final calendarDaysOfWeekStyle = DaysOfWeekStyle(
  weekdayStyle: TextStyle(color: textColor.toColor()),
  weekendStyle: const TextStyle(color: warningColor),
);

final calendarStyle = CalendarStyle(
  outsideDaysVisible: false,
  defaultTextStyle: TextStyle(color: textColor.toColor()),
  weekendTextStyle: const TextStyle(color: warningColor),
  // Text color for today
  todayTextStyle: const TextStyle(color: bgColor, fontWeight: FontWeight.bold),
  // Text color for selected day
  selectedTextStyle:
      const TextStyle(color: bgColor, fontWeight: FontWeight.bold),

  // Decorations for specific days
  todayDecoration: BoxDecoration(
      color: secondaryColor.withOpacity(0.6), shape: BoxShape.circle),
  selectedDecoration:
      const BoxDecoration(color: secondaryColor, shape: BoxShape.circle),
  // Reservation marker color
  markerDecoration:
      const BoxDecoration(color: actionColor, shape: BoxShape.circle),
  // Size of the reservation marker dot
  markerSize: 6.0,
  // Position markers at the bottom center of the day cell
  markersAlignment: Alignment.bottomCenter,
);

// Date Picker
final datePickerTheme = ThemeData(
  dialogBackgroundColor: primaryColor, // Background of the entire dialog

  colorScheme: const ColorScheme.dark().copyWith(
    primary: secondaryColor, // Selected day + header
    onPrimary: bgColor, // Text color on selected day/header
    surface: primaryColor, // Dialog background surface
    onSurface: textColor.toColor(), // Default text color (days, header title)
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: secondaryColor, // Action buttons
      textStyle: const TextStyle(fontWeight: FontWeight.w800),
    ),
  ),

  // Customize the shape and background of the date picker dialog
  dialogTheme: DialogTheme(
    backgroundColor: primaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
  ),
);

// Time Picker
final timePickerTheme = ThemeData(
  dialogBackgroundColor: primaryColor,
  colorScheme: const ColorScheme.dark().copyWith(
    primary: secondaryColor, // Dial hand, selected text
    onPrimary: bgColor, // Text on primary color
    surface: primaryColor, // Clock face background
    onSurface: textColor.toColor(), // Labels & inactive text
  ),
  timePickerTheme: TimePickerThemeData(
    backgroundColor: primaryColor,
    hourMinuteColor: secondaryColor.withOpacity(0.2),
    hourMinuteTextColor: textColor.toColor(),
    dialHandColor: secondaryColor,
    dialBackgroundColor: primaryColor,
    entryModeIconColor: secondaryColor,
    dayPeriodColor: primaryColor,
    dayPeriodTextColor: textColor.toColor(),
    helpTextStyle: TextStyle(
      color: textColor.toColor(),
      fontWeight: FontWeight.bold,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: secondaryColor,
      textStyle: const TextStyle(fontWeight: FontWeight.w800),
    ),
  ),
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: bgColor,
  appBarTheme: darkAppBarTheme,
  navigationBarTheme: navigationBarTheme,
  inputDecorationTheme: darkInputDecorationTheme,
  expansionTileTheme: darkExpansionTileTheme,
  elevatedButtonTheme: darkElevatedButtonTheme,
  outlinedButtonTheme: darkOutlinedButtonTheme,
  floatingActionButtonTheme: floatingActionButtonTheme,
  popupMenuTheme: darkPopupMenuTheme,
  snackBarTheme: baseSnackBarTheme,
  tabBarTheme: tabBarTheme,
);
