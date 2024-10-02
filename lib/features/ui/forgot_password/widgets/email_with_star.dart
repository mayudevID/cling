import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../resources/gen/assets.gen.dart';
import 'star_rotate_scale_anim.dart';

class EmailWithStar extends StatelessWidget {
  const EmailWithStar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      height: 197.h,
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 197.w,
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
            bottom: 10.h,
            left: 118.w,
            child: Container(
              width: 48.w,
              height: 48.w,
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
            bottom: 0,
            left: 155.w,
            child: Container(
              width: 29.w,
              height: 29.w,
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
          )
        ],
      ),
    );
  }
}
