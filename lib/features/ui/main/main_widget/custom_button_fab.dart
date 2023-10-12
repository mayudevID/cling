import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../resources/gen/fonts.gen.dart';

Widget customButtonFab(String text) {
  return Container(
    padding: EdgeInsets.symmetric(
      vertical: 9.wmea,
      horizontal: 19.5.hmea,
    ),
    decoration: BoxDecoration(
      color: const Color(0xFFF599DA),
      borderRadius: BorderRadius.circular(13),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: Colors.black,
        fontSize: 13.5.sp,
        fontFamily: FontFamily.cabinetGrotesk,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}
