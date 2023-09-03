import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import '../../../../resources/gen/assets.gen.dart';

class QuarterWidgetRotate extends StatelessWidget {
  const QuarterWidgetRotate({super.key, required this.bigRound});
  final int bigRound;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: bigRound,
      child: Assets.lib.resources.imagesPng.ellipseOnboard.image(
        fit: BoxFit.fill,
        width: (bigRound == 1 || bigRound == -1) ? 215.hmea : 50.w,
        height: (bigRound == 1 || bigRound == -1) ? 50.w : 215.hmea,
      ),
    );
  }
}
