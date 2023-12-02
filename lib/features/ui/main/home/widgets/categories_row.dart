import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/fonts.gen.dart';

List<Widget> rowCategories(String data) {
  return [
    Text(
      data.substring(
        0,
        data.indexOf(" "),
      ),
      style: TextStyle(
        fontSize: 14.5.sp,
        fontFamily: FontFamily.cabinetGrotesk,
      ),
    ),
    SizedBox(
      width: 10.wmea,
    ),
    Text(
      data.substring(
        data.indexOf(" ") + 1,
      ),
      style: TextStyle(
        color: Colors.white,
        fontSize: 10.5.sp,
        fontFamily: FontFamily.cabinetGrotesk,
        fontWeight: FontWeight.w500,
      ),
    ),
  ];
}
