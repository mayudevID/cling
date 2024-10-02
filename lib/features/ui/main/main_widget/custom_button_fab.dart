import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../resources/gen/fonts.gen.dart';

Widget customButtonFab(String text) {
  return Container(
    padding: EdgeInsets.symmetric(
      vertical: 9.w,
      horizontal: 19.5.h,
    ),
    decoration: BoxDecoration(
      color: const Color(0xFFF599DA),
      borderRadius: BorderRadius.circular(13),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: Colors.black,
        fontSize: 11.5.sp,
        fontFamily: FontFamily.cabinetGrotesk,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}
