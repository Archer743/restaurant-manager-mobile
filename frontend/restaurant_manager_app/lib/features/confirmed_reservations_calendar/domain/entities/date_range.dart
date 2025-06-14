import 'package:intl/intl.dart';

class DateRange {
  late final String startDate;
  late final String endDate;

  DateRange({required DateTime startDate, required DateTime endDate}) {
    this.startDate = _getDateString(startDate);
    this.endDate = _getDateString(endDate);
  }

  String _getDateString(DateTime object) {
    return DateFormat('yyyy-MM-dd').format(object.toUtc());
  }
}
