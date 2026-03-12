import 'package:flutter/material.dart';

import '../../../../resources/gen/assets.gen.dart';

class QuarterWidgetRotate extends StatelessWidget {
  const QuarterWidgetRotate({super.key, required this.bigRound});
  final int bigRound;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: RotatedBox(
        quarterTurns: bigRound,
        child: Assets.lib.resources.imagesPng.ellipseOnboard.image(
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
