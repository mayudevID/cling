import 'package:cling/core/utils.dart';
import 'package:cling/features/ui/onboard/widgets/star_anim_one.dart';
import 'package:flutter/material.dart';

import 'star_anim_three.dart';
import 'star_anim_two.dart';

class StackStar extends StatelessWidget {
  const StackStar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 308.90.wmea,
          top: 50.hmea,
          child: const StarAnimOne(),
        ),
        Positioned(
          left: 369.92.wmea,
          top: 92.45.hmea,
          child: Container(
            width: 34.49.wmea,
            height: 34.49.wmea,
            decoration: const ShapeDecoration(
              color: Color(0xFF006DE9),
              shape: StarBorder(
                points: 4,
                innerRadiusRatio: 0.39,
                pointRounding: 0,
                valleyRounding: 0,
                rotation: 0,
                squash: 0,
              ),
            ),
          ),
        ),
        Positioned(
          left: 59.wmea,
          top: 108.hmea,
          child: Container(
            width: 21.wmea,
            height: 21.wmea,
            decoration: const ShapeDecoration(
              color: Color(0xFF006DE9),
              shape: StarBorder(
                points: 4,
                innerRadiusRatio: 0.39,
                pointRounding: 0,
                valleyRounding: 0,
                rotation: 0,
                squash: 0,
              ),
            ),
          ),
        ),
        Positioned(
          left: 25.wmea,
          top: 118.98.hmea,
          child: const StarAnimTwo(),
        ),
        Positioned(
          left: 309.wmea,
          top: 362.hmea,
          child: const StarAnimThree(),
        ),
      ],
    );
  }
}
