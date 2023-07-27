import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';

import 'animation_onboard.dart';

class StackStar extends StatefulWidget {
  const StackStar({super.key});

  @override
  State<StackStar> createState() => _StackStarState();
}

class _StackStarState extends State<StackStar> with TickerProviderStateMixin {
  late List<Animation<double>> _listSpinAnimation;

  @override
  void initState() {
    _listSpinAnimation = AnimationOnboard.setAnimationsStar(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 308.90.wmea,
          top: 50.hmea,
          child: RotationTransition(
            turns: _listSpinAnimation[0],
            child: Container(
              width: 61.02.wmea,
              height: 61.02.wmea,
              decoration: const ShapeDecoration(
                color: Color(0xFF07AC65),
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
          child: RotationTransition(
            turns: _listSpinAnimation[2],
            child: Container(
              width: 34.49,
              height: 34.49,
              decoration: const ShapeDecoration(
                color: Color(0xFFF599DA),
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
        ),
        Positioned(
          left: 309.wmea,
          top: 362.hmea,
          child: RotationTransition(
            turns: _listSpinAnimation[1],
            child: Container(
              width: 34.49.wmea,
              height: 34.49.wmea,
              decoration: const ShapeDecoration(
                color: Color(0xFFF599DA),
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
        ),
      ],
    );
  }
}
