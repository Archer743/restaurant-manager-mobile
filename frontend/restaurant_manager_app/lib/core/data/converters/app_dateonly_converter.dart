import 'package:json_annotation/json_annotation.dart';

class AppDateOnlyConverter implements JsonConverter<DateTime, String> {
  const AppDateOnlyConverter();

  @override
  DateTime fromJson(String json) {
    // Format: yyyy-MM-DD
    final parts = json.split('-');

    final DateTime dateOnly = DateTime.utc(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );

    return dateOnly;
  }

  @override
  String toJson(DateTime object) {
    // Ensure format is yyyy-MM-dd
    final String year = object.year.toString().padLeft(4, '0');
    final String month = object.month.toString().padLeft(2, '0');
    final String day = object.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}
