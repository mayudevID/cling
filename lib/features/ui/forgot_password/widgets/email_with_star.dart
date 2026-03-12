import 'package:flutter/material.dart';

import '../../../../../resources/gen/assets.gen.dart';
import 'star_rotate_scale_anim.dart';

class EmailWithStar extends StatelessWidget {
  const EmailWithStar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 197,
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 197,
              height: double.infinity,
              decoration: const ShapeDecoration(
                color: Color(0xFF313131),
                shape: OvalBorder(),
              ),
              child: Center(
                child: Assets.lib.resources.imagesPng.emailLogo.image(),
              ),
            ),
          ),
          const StarRotateScaleAnim(),
          Positioned(
            bottom: 10,
            left: 118,
            child: Container(
              width: 48,
              height: 48,
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
            bottom: 0,
            left: 155,
            child: Container(
              width: 29,
              height: 29,
              decoration: const ShapeDecoration(
                color: Color(0xFFF2D82D),
                shape: StarBorder(
                  points: 4,
                  innerRadiusRatio: 0.39,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
