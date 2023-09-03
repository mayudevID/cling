import 'package:cling/core/utils.dart';
import 'package:cling/features/ui/auth/forgot_password/widgets/star_rotate_scale_anim.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/assets.gen.dart';

class EmailWithStar extends StatelessWidget {
  const EmailWithStar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      height: 197.hmea,
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 197.wmea,
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
            bottom: 10.hmea,
            left: 118.wmea,
            child: Container(
              width: 48.wmea,
              height: 48.wmea,
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
            left: 155.wmea,
            child: Container(
              width: 29.wmea,
              height: 29.wmea,
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
