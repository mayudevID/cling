import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import '../../../resources/gen/assets.gen.dart';

class QuarterWidgetRotate extends StatelessWidget {
  const QuarterWidgetRotate({super.key, required this.bigRound});
  final int bigRound;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: bigRound,
      child: Assets.lib.resources.images.ellipseOnboard.image(
        fit: BoxFit.fill,
        width: (bigRound == 1 || bigRound == -1) ? Utils.h(215).h : 50.w,
        height: (bigRound == 1 || bigRound == -1) ? 50.w : Utils.h(215).h,
      ),
    );
  }
}
