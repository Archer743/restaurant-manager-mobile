import 'package:restaurant_manager_app/core/utils/datetime_utils.dart';

class DateRange {
  late final String startDate;
  late final String endDate;

  DateRange({required DateTime startDate, required DateTime endDate}) {
    this.startDate = startDate.toYYYYMMDDString();
    this.endDate = endDate.toYYYYMMDDString();
  }
}
