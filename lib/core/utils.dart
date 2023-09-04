import 'package:sizer/sizer.dart';

extension Resizing on num {
  double get hmea => (toDouble() * 100 / 932).h;
  double get wmea => (toDouble() * 100 / 430).w;
}

extension RemoveDot on String {
  String get removeDot => replaceAll(RegExp(r'[^0-9]'), '');
}
