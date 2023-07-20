import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils.dart';
import '../../../../resources/gen/fonts.gen.dart';

List<Widget> tagNameHome(String name) {
  return [
    SizedBox(
      height: Utils.h(24).h,
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: Utils.w(20).w),
      child: Text(
        name,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
          fontFamily: FontFamily.cabinetGrotesk,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    SizedBox(
      height: Utils.h(16).h,
    ),
  ];
}
