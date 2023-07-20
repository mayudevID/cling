import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class StackStarReg extends StatelessWidget {
  const StackStarReg({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: Utils.w(308.90).w,
          top: Utils.h(95).h,
          child: Container(
            width: Utils.w(61.02).w,
            height: Utils.w(61.02).w,
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
          left: Utils.w(350).w,
          top: Utils.h(80.45).h,
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
          left: Utils.w(45).w,
          top: Utils.h(108).h,
          child: Container(
            width: Utils.w(21).w,
            height: Utils.w(21).w,
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
          left: Utils.w(30).h,
          top: Utils.h(123).h,
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
          left: Utils.w(309).w,
          top: Utils.w(305).w,
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
      ],
    );
  }
}
