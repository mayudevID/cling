import 'package:sizer/sizer.dart';

extension Resizing on num {
  double get hmea => (toDouble() * 100 / 932).h;
  double get wmea => (toDouble() * 100 / 430).w;
}

extension RemoveDot on String {
  String get removeDot => replaceAll(RegExp(r'[^0-9]'), '');
}

double? setInterval(double maxVal) {
  if (maxVal < 50000) {
    return 10000;
  } else if (maxVal < 100000) {
    return 20000;
  } else if (maxVal < 500000) {
    return 50000;
  } else if (maxVal < 5000000) {
    return 200000;
  } else if (maxVal < 10000000) {
    return 500000;
  } else if (maxVal < 50000000) {
    return 1000000;
  } else if (maxVal < 100000000) {
    return 15000000;
  } else {
    return null;
  }
}
