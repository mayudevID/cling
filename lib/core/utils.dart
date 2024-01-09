import 'package:sizer/sizer.dart';

extension Resizing on num {
  double get hmea => (toDouble() * 100 / 932).h;
  double get wmea => (toDouble() * 100 / 430).w;
}

extension RemoveDot on String {
  String get removeDot => replaceAll(RegExp(r'[^0-9]'), '');
}

double? setInterval(double maxVal) {
  if (maxVal <= 10000) {
    return 2000;
  } else if (maxVal <= 50000) {
    return 10000;
  } else if (maxVal <= 100000) {
    return 20000;
  } else if (maxVal <= 200000) {
    return 25000;
  } else if (maxVal <= 500000) {
    return 50000;
  } else if (maxVal <= 1000000) {
    return 100000;
  } else if (maxVal <= 1500000) {
    return 200000;
  } else if (maxVal <= 10000000) {
    return 1000000;
  } else if (maxVal <= 50000000) {
    return 5000000;
  } else if (maxVal <= 100000000) {
    return 15000000;
  } else {
    return null;
  }
}

String getRankString(int number) {
  if (number == 0) {
    return "-";
  }

  if (number >= 11 && number <= 13) {
    return '${number}th';
  }

  switch (number % 10) {
    case 1:
      return '${number}st';
    case 2:
      return '${number}nd';
    case 3:
      return '${number}rd';
    default:
      return '${number}th';
  }
}
