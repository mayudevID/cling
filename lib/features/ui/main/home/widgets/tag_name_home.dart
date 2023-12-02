import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/fonts.gen.dart';

String monthAndYearNow(BuildContext context) {
  final date = DateTime.now();
  return '${monthIntToString(context: context, time: date, compact: false)} ${date.year}';
}

List<Widget> tagNameHome(
  BuildContext context,
  String name, {
  bool withDate = false,
}) {
  return [
    SizedBox(
      height: 24.hmea,
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.wmea),
      child: RichText(
        text: TextSpan(
          text: name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.5.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w700,
          ),
          children: (withDate)
              ? [
                  TextSpan(
                    text: " / ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.5.sp,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: monthAndYearNow(context),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ]
              : null,
        ),
      ),
    ),
    SizedBox(
      height: 16.hmea,
    ),
  ];
}
