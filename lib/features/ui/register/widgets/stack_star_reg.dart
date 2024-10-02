import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StackStarReg extends StatelessWidget {
  const StackStarReg({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 308.90.w,
          top: 95.h,
          child: Container(
            width: 61.02.w,
            height: 61.02.w,
            decoration: const ShapeDecoration(
              color: Color(0xFFF2D82D),
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
          left: 350.w,
          top: 80.45.h,
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
          left: 45.w,
          top: 108.h,
          child: Container(
            width: 21.w,
            height: 21.w,
            decoration: const ShapeDecoration(
              color: Color(0xFFE54C19),
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
          left: 30.h,
          top: 123.h,
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
        Positioned(
          left: 309.w,
          top: 305.w,
          child: Container(
            width: 34.49.w,
            height: 34.49.w,
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
      ],
    );
  }
}
