import 'package:json_annotation/json_annotation.dart';

class AppDateTimeUtcConverter implements JsonConverter<DateTime, String> {
  const AppDateTimeUtcConverter();

  @override
  DateTime fromJson(String json) {
    try {
      final DateTime parsedDateTime = DateTime.parse(json);
      return parsedDateTime.toUtc();
    } on FormatException catch (e) {
      throw FormatException(
          "Invalid DateTime format for UTC conversion: '$json'. Error: $e");
    }
  }

  @override
  String toJson(DateTime object) {
    return object.toUtc().toIso8601String();
  }
}
