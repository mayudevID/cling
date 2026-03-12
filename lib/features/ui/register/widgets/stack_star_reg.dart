import 'package:flutter/material.dart';

class StackStarReg extends StatelessWidget {
  const StackStarReg({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 308.90,
          top: 95,
          child: Container(
            width: 61.02,
            height: 61.02,
            decoration: const ShapeDecoration(
              color: Color(0xFFF2D82D),
              shape: StarBorder(
                points: 4,
                innerRadiusRatio: 0.39,
              ),
            ),
          ),
        ),
        Positioned(
          left: 350,
          top: 80.45,
          child: Container(
            width: 34.49,
            height: 34.49,
            decoration: const ShapeDecoration(
              color: Color(0xFF006DE9),
              shape: StarBorder(
                points: 4,
                innerRadiusRatio: 0.39,
              ),
            ),
          ),
        ),
        Positioned(
          left: 45,
          top: 108,
          child: Container(
            width: 21,
            height: 21,
            decoration: const ShapeDecoration(
              color: Color(0xFFE54C19),
              shape: StarBorder(
                points: 4,
                innerRadiusRatio: 0.39,
              ),
            ),
          ),
        ),
        Positioned(
          left: 30,
          top: 123,
          child: Container(
            width: 34.49,
            height: 34.49,
            decoration: const ShapeDecoration(
              color: Color(0xFFF599DA),
              shape: StarBorder(
                points: 4,
                innerRadiusRatio: 0.39,
              ),
            ),
          ),
        ),
        Positioned(
          left: 309,
          top: 305,
          child: Container(
            width: 34.49,
            height: 34.49,
            decoration: const ShapeDecoration(
              color: Color(0xFFF599DA),
              shape: StarBorder(
                points: 4,
                innerRadiusRatio: 0.39,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
