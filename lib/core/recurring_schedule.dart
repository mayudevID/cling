/// Calendar-aware, timezone-local recurring income schedule.
class RecurringSchedule {
  const RecurringSchedule._();

  static DateTime occurrence(int year, int month, int day) {
    if (day < 1 || day > 31) {
      throw RangeError.range(day, 1, 31, 'day');
    }
    final base = DateTime(year, month);
    final lastDay = DateTime(base.year, base.month + 1, 0).day;
    return DateTime(base.year, base.month, day > lastDay ? lastDay : day);
  }

  static DateTime next(DateTime previous, int day) =>
      occurrence(previous.year, previous.month + 1, day);

  /// On first setup, do not fabricate income in a past month.
  /// If today is payday, the current month will be inserted on first check.
  static DateTime initialLast(DateTime today, int day) {
    final scheduled = occurrence(today.year, today.month, day);
    return scheduled.isBefore(DateTime(today.year, today.month, today.day))
        ? scheduled
        : occurrence(today.year, today.month - 1, day);
  }
}
