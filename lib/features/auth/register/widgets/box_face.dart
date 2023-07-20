import 'package:cling/resources/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils.dart';

class BoxFace extends StatelessWidget {
  const BoxFace({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: Utils.w(324.04).w,
        height: Utils.h(152).h,
        decoration: const BoxDecoration(
          color: Color(0xFF07AC65),
        ),
        child: Column(
          children: [
            SizedBox(
              height: Utils.h(31.74).h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: Utils.w(33.41).w,
                  height: Utils.w(33.41).w,
                  child: Stack(
                    children: [
                      Container(
                        width: Utils.w(33.41).w,
                        height: Utils.w(33.41).w,
                        decoration: const ShapeDecoration(
                          color: Colors.white,
                          shape: OvalBorder(),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: Utils.w(20.04).w,
                          height: Utils.w(20.04).w,
                          decoration: const ShapeDecoration(
                            color: Colors.black,
                            shape: OvalBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: Utils.w(8.35).w,
                ),
                SizedBox(
                  width: Utils.w(33.41).w,
                  height: Utils.w(33.41).w,
                  child: Stack(
                    children: [
                      Container(
                        width: Utils.w(33.41).w,
                        height: Utils.w(33.41).w,
                        decoration: const ShapeDecoration(
                          color: Colors.white,
                          shape: OvalBorder(),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: Utils.w(20.04).w,
                          height: Utils.w(20.04).w,
                          decoration: const ShapeDecoration(
                            color: Colors.black,
                            shape: OvalBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: Utils.h(8.35).w,
            ),
            Assets.lib.resources.images.smile.svg(),
          ],
        ),
      ),
    );
  }
}
