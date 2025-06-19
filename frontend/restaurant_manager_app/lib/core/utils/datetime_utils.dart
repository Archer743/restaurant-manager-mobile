DateTime getFirstDayOfMonth(DateTime date) {
  return DateTime.utc(date.year, date.month, 1);
}

DateTime getLastDayOfMonth(DateTime date) {
  return DateTime.utc(date.year, date.month + 1, 0);
}
