import 'package:flutter/material.dart';

import 'quarter_widget_rotate.dart';

class StackEmoticon extends StatelessWidget {
  const StackEmoticon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            QuarterWidgetRotate(bigRound: 0),
            QuarterWidgetRotate(bigRound: 1),
          ],
        ),
        Row(
          children: [
            QuarterWidgetRotate(bigRound: -1),
            QuarterWidgetRotate(bigRound: 2),
          ],
        ),
      ],
    );
  }
}
