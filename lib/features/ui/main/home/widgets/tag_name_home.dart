import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/fonts.gen.dart';

String formatMonth(DateTime date) {
  final month = date.month;
  if (month <= 9) {
    return '0$month';
  } else {
    return month.toString();
  }
}

String monthAndYearNow() {
  final date = DateTime.now();
  return '(${formatMonth(date)}/${date.year})';
}

List<Widget> tagNameHome(String name, {bool withDate = false}) {
  return [
    SizedBox(
      height: 24.hmea,
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.wmea),
      child: Text(
        '$name ${withDate ? monthAndYearNow() : ""}'.trim(),
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
