import 'package:cling/core/recurring_schedule.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('end of month clamps instead of overflowing', () {
    expect(
      RecurringSchedule.next(DateTime(2026, 1, 31), 31),
      DateTime(2026, 2, 28),
    );
    expect(
      RecurringSchedule.next(DateTime(2028, 1, 31), 31),
      DateTime(2028, 2, 29),
    );
    expect(
      RecurringSchedule.next(DateTime(2026, 12, 31), 31),
      DateTime(2027, 1, 31),
    );
  });

  test('initial setup does not backfill earlier payday', () {
    expect(
      RecurringSchedule.initialLast(DateTime(2026, 11, 20), 7),
      DateTime(2026, 11, 7),
    );
    expect(
      RecurringSchedule.initialLast(DateTime(2026, 11, 7), 7),
      DateTime(2026, 10, 7),
    );
  });
}
