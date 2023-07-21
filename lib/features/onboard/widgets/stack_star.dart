import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

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
          left: Utils.w(308.90).w,
          top: Utils.h(50).h,
          child: RotationTransition(
            turns: _listSpinAnimation[0],
            child: Container(
              width: Utils.w(61.02).w,
              height: Utils.w(61.02).w,
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
          left: Utils.w(369.92).w,
          top: Utils.h(92.45).h,
          child: Container(
            width: Utils.w(34.49).w,
            height: Utils.w(34.49).w,
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
          left: Utils.w(59).w,
          top: Utils.h(108).h,
          child: Container(
            width: Utils.w(21).w,
            height: Utils.w(21).w,
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
          left: Utils.w(10).h,
          top: Utils.h(118.98).h,
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
          left: Utils.w(309).w,
          top: Utils.h(362).h,
          child: RotationTransition(
            turns: _listSpinAnimation[1],
            child: Container(
              width: Utils.w(34.49).w,
              height: Utils.w(34.49).w,
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
