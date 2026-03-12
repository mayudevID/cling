import 'star_anim_one.dart';
import 'package:flutter/material.dart';

import 'star_anim_three.dart';
import 'star_anim_two.dart';

class StackStar extends StatelessWidget {
  const StackStar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          left: 308.90,
          top: 50,
          child: StarAnimOne(),
        ),
        Positioned(
          left: 369.92,
          top: 92.45,
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
          left: 59,
          top: 108,
          child: Container(
            width: 21,
            height: 21,
            decoration: const ShapeDecoration(
              color: Color(0xFF006DE9),
              shape: StarBorder(
                points: 4,
                innerRadiusRatio: 0.39,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 25,
          top: 118.98,
          child: StarAnimTwo(),
        ),
        const Positioned(
          left: 309,
          top: 362,
          child: StarAnimThree(),
        ),
      ],
    );
  }
}
