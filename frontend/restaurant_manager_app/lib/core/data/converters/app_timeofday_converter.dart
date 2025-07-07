import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_manager_app/core/utils/timeofday_utils.dart';

class AppTimeOfDayConverter implements JsonConverter<TimeOfDay, String> {
  const AppTimeOfDayConverter();

  @override
  TimeOfDay fromJson(String json) {
    // Expecting "hh:mm:ss" or "hh:mm" format from your backend.
    // Ensure robustness by handling potential missing seconds.
    return parseTimeOfDay(json);
  }

  @override
  String toJson(TimeOfDay object) {
    // When sending TimeOfDay to backend, format as "hh:mm:ss"
    return object.toHHMMSSString();
  }
}
