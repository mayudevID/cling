/// Pure calendar and integer-money calculations used by financial planning.
class RecurringExpenseSchedule {
  const RecurringExpenseSchedule._();

  static DateTime dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  static DateTime monthlyDate(int year, int month, int day) {
    if (day < 1 || day > 31) throw RangeError.range(day, 1, 31, 'day');
    final first = DateTime(year, month, 1);
    final lastDay = DateTime(first.year, first.month + 1, 0).day;
    return DateTime(first.year, first.month, day.clamp(1, lastDay).toInt());
  }

  static DateTime firstOnOrAfter({
    required String frequency,
    required int scheduledDay,
    required DateTime from,
  }) {
    final date = dateOnly(from);
    if (frequency == 'monthly') {
      var candidate = monthlyDate(date.year, date.month, scheduledDay);
      if (candidate.isBefore(date)) {
        candidate = monthlyDate(date.year, date.month + 1, scheduledDay);
      }
      return candidate;
    }
    if (frequency != 'weekly' || scheduledDay < 1 || scheduledDay > 7) {
      throw RangeError('Invalid recurrence frequency or scheduled day.');
    }
    return date.add(Duration(days: (scheduledDay - date.weekday + 7) % 7));
  }

  static DateTime next({
    required String frequency,
    required int scheduledDay,
    required DateTime previous,
  }) {
    if (frequency == 'weekly')
      return dateOnly(previous).add(const Duration(days: 7));
    if (frequency != 'monthly') throw ArgumentError.value(frequency);
    return monthlyDate(previous.year, previous.month + 1, scheduledDay);
  }

  static List<DateTime> between({
    required String frequency,
    required int scheduledDay,
    required DateTime from,
    required DateTime through,
    DateTime? endDate,
  }) {
    final first = firstOnOrAfter(
      frequency: frequency,
      scheduledDay: scheduledDay,
      from: from,
    );
    final end = dateOnly(through);
    final effectiveEnd = endDate == null || end.isBefore(dateOnly(endDate))
        ? end
        : dateOnly(endDate);
    final dates = <DateTime>[];
    var current = first;
    while (!current.isAfter(effectiveEnd)) {
      dates.add(current);
      current = next(
        frequency: frequency,
        scheduledDay: scheduledDay,
        previous: current,
      );
    }
    return dates;
  }
}

class PaydayRunwayProjection {
  const PaydayRunwayProjection({
    required this.payday,
    required this.daysRemaining,
    required this.availableMinor,
    required this.billsMinor,
    required this.recurringMinor,
    required this.reserveMinor,
    required this.expectedIncomeMinor,
    required this.currency,
  });

  final DateTime payday;
  final int daysRemaining;
  final int availableMinor;
  final int billsMinor;
  final int recurringMinor;
  final int reserveMinor;
  final int expectedIncomeMinor;
  final String currency;

  int get estimatedSpendableMinor =>
      availableMinor - billsMinor - recurringMinor - reserveMinor;
  int get dailyAllowanceMinor => daysRemaining <= 0
      ? 0
      : (estimatedSpendableMinor <= 0
          ? 0
          : estimatedSpendableMinor ~/ daysRemaining);
}

DateTime nextPayday(DateTime today, int scheduledDay) {
  final date = RecurringExpenseSchedule.dateOnly(today);
  if (scheduledDay < 1 || scheduledDay > 31) {
    throw RangeError.range(scheduledDay, 1, 31, 'scheduledDay');
  }
  var next = RecurringExpenseSchedule.monthlyDate(
    date.year,
    date.month,
    scheduledDay,
  );
  if (!next.isAfter(date)) {
    next = RecurringExpenseSchedule.monthlyDate(
      date.year,
      date.month + 1,
      scheduledDay,
    );
  }
  return next;
}

PaydayRunwayProjection projectPaydayRunway({
  required DateTime today,
  required int paydayDay,
  required int availableMinor,
  required int billsMinor,
  required int recurringMinor,
  required int reserveMinor,
  required int expectedIncomeMinor,
  required String currency,
}) {
  final payday = nextPayday(today, paydayDay);
  final days =
      payday.difference(RecurringExpenseSchedule.dateOnly(today)).inDays;
  return PaydayRunwayProjection(
    payday: payday,
    daysRemaining: days,
    availableMinor: availableMinor,
    billsMinor: billsMinor,
    recurringMinor: recurringMinor,
    reserveMinor: reserveMinor,
    expectedIncomeMinor: expectedIncomeMinor,
    currency: currency,
  );
}
