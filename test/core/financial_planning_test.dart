import 'package:cling/core/financial_planning.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RecurringExpenseSchedule', () {
    test('monthly days 29 to 31 clamp across leap and common February', () {
      expect(RecurringExpenseSchedule.monthlyDate(2024, 2, 29),
          DateTime(2024, 2, 29));
      expect(RecurringExpenseSchedule.monthlyDate(2023, 2, 29),
          DateTime(2023, 2, 28));
      expect(RecurringExpenseSchedule.monthlyDate(2023, 2, 30),
          DateTime(2023, 2, 28));
      expect(RecurringExpenseSchedule.monthlyDate(2023, 2, 31),
          DateTime(2023, 2, 28));
      expect(RecurringExpenseSchedule.monthlyDate(2024, 4, 31),
          DateTime(2024, 4, 30));
    });

    test('monthly recurrence preserves the scheduled day at year boundary', () {
      expect(
        RecurringExpenseSchedule.next(
            frequency: 'monthly',
            scheduledDay: 31,
            previous: DateTime(2026, 12, 31)),
        DateTime(2027, 1, 31),
      );
    });

    test('weekly schedule uses Monday 1 through Sunday 7 and advances by weeks',
        () {
      expect(
          RecurringExpenseSchedule.firstOnOrAfter(
              frequency: 'weekly',
              scheduledDay: DateTime.monday,
              from: DateTime(2026, 1, 21)),
          DateTime(2026, 1, 26));
      expect(
          RecurringExpenseSchedule.next(
              frequency: 'weekly',
              scheduledDay: DateTime.monday,
              previous: DateTime(2026, 12, 28)),
          DateTime(2027, 1, 4));
    });

    test('range respects start and end calendar dates', () {
      expect(
          RecurringExpenseSchedule.between(
              frequency: 'monthly',
              scheduledDay: 31,
              from: DateTime(2026, 1, 1),
              through: DateTime(2026, 4, 1),
              endDate: DateTime(2026, 3, 1)),
          [DateTime(2026, 1, 31), DateTime(2026, 2, 28)]);
    });
  });

  group('Payday Runway projection', () {
    test('example computes exact integer spendable amount and daily allowance',
        () {
      final result = projectPaydayRunway(
          today: DateTime(2026, 5, 20),
          paydayDay: 31,
          availableMinor: 300000000,
          billsMinor: 85000000,
          recurringMinor: 0,
          reserveMinor: 50000000,
          expectedIncomeMinor: 250000000,
          currency: 'IDR');
      expect(result.payday, DateTime(2026, 5, 31));
      expect(result.daysRemaining, 11);
      expect(result.estimatedSpendableMinor, 165000000);
      expect(result.dailyAllowanceMinor, 15000000);
      expect(result.expectedIncomeMinor, 250000000);
    });

    test('shortfall remains negative while daily allowance clamps to zero', () {
      final result = projectPaydayRunway(
          today: DateTime(2026, 2, 1),
          paydayDay: 28,
          availableMinor: 100,
          billsMinor: 300,
          recurringMinor: 20,
          reserveMinor: 50,
          expectedIncomeMinor: 900,
          currency: 'IDR');
      expect(result.estimatedSpendableMinor, -270);
      expect(result.dailyAllowanceMinor, 0);
      expect(nextPayday(DateTime(2028, 2, 1), 31), DateTime(2028, 2, 29));
    });
  });
}
