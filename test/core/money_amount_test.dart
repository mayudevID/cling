import 'package:cling/core/money_amount.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('minor units round-trip exactly at the cent boundary', () {
    expect(MoneyAmount.toMinorUnits(0.01), 1);
    expect(MoneyAmount.toMinorUnits(1200.45), 120045);
    expect(MoneyAmount.fromMinorUnits(120045), 1200.45);
    expect(MoneyAmount.toMinorUnits(0, allowZero: true), 0);
  });

  test('invalid or overly precise inputs are rejected', () {
    for (final invalid in [-1.0, 0.0, double.nan, double.infinity, 1.001]) {
      expect(() => MoneyAmount.toMinorUnits(invalid), throwsFormatException);
    }
  });
}
