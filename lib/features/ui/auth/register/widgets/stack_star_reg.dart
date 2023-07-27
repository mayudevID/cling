import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';

class StackStarReg extends StatelessWidget {
  const StackStarReg({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 308.90.wmea,
          top: 95.hmea,
          child: Container(
            width: 61.02.wmea,
            height: 61.02.wmea,
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
          left: 350.wmea,
          top: 80.45.hmea,
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
          left: 45.wmea,
          top: 108.hmea,
          child: Container(
            width: 21.wmea,
            height: 21.wmea,
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
          left: 30.hmea,
          top: 123.hmea,
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
          left: 309.wmea,
          top: 305.wmea,
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
      ],
    );
  }
}
