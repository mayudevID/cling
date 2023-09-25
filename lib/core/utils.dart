import 'package:cling/features/ui/language_currency/lang_export.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

extension Resizing on num {
  double get hmea => (toDouble() * 100 / 932).h;
  double get wmea => (toDouble() * 100 / 430).w;
}

extension RemoveDot on String {
  String get removeDot => replaceAll(RegExp(r'[^0-9]'), '');
}

String monthIntToString({
  required BuildContext context,
  required DateTime time,
  bool compact = false,
}) {
  var lion = AppLocalizations.of(context)!;
  switch (time.month) {
    case 1:
      return (compact) ? lion.jan : lion.january;
    case 2:
      return (compact) ? lion.feb : lion.february;
    case 3:
      return (compact) ? lion.mar : lion.march;
    case 4:
      return (compact) ? lion.apr : lion.april;
    case 5:
      return lion.may;
    case 6:
      return (compact) ? lion.jun : lion.june;
    case 7:
      return (compact) ? lion.jul : lion.july;
    case 8:
      return (compact) ? lion.aug : lion.august;
    case 9:
      return (compact) ? lion.sept : lion.september;
    case 10:
      return (compact) ? lion.oct : lion.october;
    case 11:
      return (compact) ? lion.nov : lion.november;
    case 12:
      return (compact) ? lion.dec : lion.december;
    default:
      return "-";
  }
}

double setInterval(double maxVal) {
  if (maxVal < 50000) {
    return 10000;
  } else if (maxVal < 100000) {
    return 20000;
  } else if (maxVal < 500000) {
    return 100000;
  } else if (maxVal < 1000000) {
    return 200000;
  } else if (maxVal < 10000000) {
    return 500000;
  } else if (maxVal < 100000000) {
    return 10000000;
  } else if (maxVal < 200000000) {
    return 15000000;
  } else {
    return 20000000;
  }
}
