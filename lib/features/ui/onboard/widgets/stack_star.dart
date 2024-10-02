import 'package:cling/features/ui/onboard/widgets/star_anim_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'star_anim_three.dart';
import 'star_anim_two.dart';

class StackStar extends StatelessWidget {
  const StackStar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 308.90.w,
          top: 50.h,
          child: const StarAnimOne(),
        ),
        Positioned(
          left: 369.92.w,
          top: 92.45.h,
          child: Container(
            width: 34.49.w,
            height: 34.49.w,
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
          left: 59.w,
          top: 108.h,
          child: Container(
            width: 21.w,
            height: 21.w,
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
          left: 25.w,
          top: 118.98.h,
          child: const StarAnimTwo(),
        ),
        Positioned(
          left: 309.w,
          top: 362.h,
          child: const StarAnimThree(),
        ),
      ],
    );
  }
}
