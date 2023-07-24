import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils.dart';
import '../../../../resources/gen/fonts.gen.dart';

List<Widget> tagNameHome(String name) {
  return [
    SizedBox(
      height: 24.hmea,
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.wmea),
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
      height: 16.hmea,
    ),
  ];
}
