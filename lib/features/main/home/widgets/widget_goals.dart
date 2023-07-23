import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils.dart';
import '../../../../resources/gen/fonts.gen.dart';

Widget widgetGoals(MapEntry e, int length) {
  return Container(
    margin: EdgeInsets.only(
      left: (e.key == 0) ? Utils.w(20).w : Utils.w(12).w,
      right: (e.key == length - 1) ? Utils.w(20).w : 0,
    ),
    padding: EdgeInsets.symmetric(
      vertical: Utils.w(16).w,
      horizontal: Utils.w(16).w,
    ),
    decoration: BoxDecoration(
      color: const Color(0x3D787880),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.all(
            Utils.w(8).w,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: e.value['image'],
        ),
        SizedBox(
          height: Utils.h(12).h,
        ),
        Text(
          e.value['name'],
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: Utils.h(4).h,
        ),
        Stack(
          children: [
            Container(
              width: Utils.w(133).w,
              height: Utils.h(8).h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.white.withOpacity(0.76),
              ),
            ),
            Container(
              width: 10.w,
              height: Utils.h(8).h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: const Color(0xFF006DE9),
              ),
            ),
          ],
        ),
        SizedBox(
          height: Utils.h(4).h,
        ),
        Text(
          "IDR ${e.value['target']} / ${(e.value['collected'] * 100 / e.value['target']).round()}%",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 10.5.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    ),
  );
}
