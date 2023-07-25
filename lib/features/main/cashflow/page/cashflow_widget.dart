import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../resources/gen/fonts.gen.dart';

Widget cashflowWidget(MapEntry data, int index) {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: 8.wmea,
      vertical: 10.hmea,
    ),
    margin: EdgeInsets.only(
      left: (index == 0) ? 20.wmea : 16.wmea,
    ),
    width: 187.wmea,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(7),
      color:
          (index % 2 != 0) ? const Color(0xFFF2D82D) : const Color(0xFFF599DA),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          data.key,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: const Color(0xFF101010),
            fontSize: 10.5.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 6.hmea,
        ),
        Text(
          'IDR',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: const Color(0xFF101010),
            fontSize: 10.5.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          data.value.toString(),
          textAlign: TextAlign.right,
          style: TextStyle(
            color: const Color(0xFF101010),
            fontSize: 10.5.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
