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
        width: 50.w,
      ),
    );
  }
}
