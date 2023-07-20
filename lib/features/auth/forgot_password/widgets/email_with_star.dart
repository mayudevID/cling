import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils.dart';
import '../../../../resources/gen/assets.gen.dart';

class EmailWithStar extends StatelessWidget {
  const EmailWithStar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      height: Utils.h(197).h,
      child: Stack(
        children: [
          Center(
            child: Container(
              width: Utils.w(197).w,
              height: double.infinity,
              decoration: const ShapeDecoration(
                color: Color(0xFF313131),
                shape: OvalBorder(),
              ),
              child: Center(
                child: Assets.lib.resources.images.emailLogo.image(),
              ),
            ),
          ),
          Positioned(
            right: Utils.w(120).w,
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
            bottom: Utils.h(10).h,
            left: Utils.w(118).w,
            child: Container(
              width: Utils.w(48).w,
              height: Utils.w(48).w,
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
            left: Utils.w(155).w,
            child: Container(
              width: Utils.w(29).w,
              height: Utils.w(29).w,
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
