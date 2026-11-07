/// Canonical persisted representation: integer hundredths of the selected
/// currency unit. Using a fixed 100x scale keeps legacy major-unit amounts
/// compatible even for zero-decimal currencies such as IDR and JPY.
class MoneyAmount {
  const MoneyAmount._();

  static const int factor = 100;

  static int toMinorUnits(double major, {bool allowZero = false}) {
    if (!major.isFinite || major < 0 || (!allowZero && major == 0)) {
      throw const FormatException('Amount must be finite and positive.');
    }
    final scaled = major * factor;
    if (!scaled.isFinite ||
        scaled.abs() > 9007199254740991 ||
        (scaled - scaled.roundToDouble()).abs() > 0.000001) {
      throw const FormatException(
          'Amount exceeds two decimal places or is too large.');
    }
    return scaled.round();
  }

  static double fromMinorUnits(Object? minor) {
    if (minor is! num) {
      throw const FormatException('Missing canonical monetary value.');
    }
    return minor.toInt() / factor;
  }
}
