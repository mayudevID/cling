import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils.dart';
import '../../../../resources/gen/fonts.gen.dart';

Widget widgetGoals(MapEntry e, int length) {
  return Container(
    margin: EdgeInsets.only(
      left: (e.key == 0) ? 20.wmea : 12.wmea,
      right: (e.key == length - 1) ? 20.wmea : 0,
    ),
    padding: EdgeInsets.symmetric(
      vertical: 16.wmea,
      horizontal: 16.wmea,
    ),
    decoration: BoxDecoration(
      color: const Color(0x3D787880),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.all(
            8.wmea,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: e.value['image'],
        ),
        SizedBox(
          height: 12.hmea,
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
          height: 4.hmea,
        ),
        Stack(
          children: [
            Container(
              width: 133.wmea,
              height: 8.hmea,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.white.withOpacity(0.76),
              ),
            ),
            Container(
              width: 10.w,
              height: 8.hmea,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: const Color(0xFF006DE9),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 4.hmea,
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
