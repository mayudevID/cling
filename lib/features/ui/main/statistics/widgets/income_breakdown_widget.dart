import 'package:cling/core/common_widget.dart';
import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/fonts.gen.dart';

Widget incomeBreakdownWidget(Map<String, dynamic> data) {
  return Container(
    margin: EdgeInsets.only(
      bottom: 16.hmea,
    ),
    padding: EdgeInsets.all(
      16.wmea,
    ),
    width: double.infinity,
    decoration: BoxDecoration(
      color: const Color(0x3D787880),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.wmea),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(
              " ${data["Source"].substring(0, data["Source"].indexOf(" "))}",
              style: TextStyle(fontSize: 9.sp),
            ),
          ),
        ),
        SizedBox(
          width: 12.wmea,
        ),
        Text(
          data["Source"].substring(data["Source"].indexOf(" ") + 1),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 10.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        NominalMoneyFormatter(
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 9.5.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w500,
          ),
          amount: data["TotalIncome"],
          decimalDigits: 2,
          isWithName: true,
        ),
      ],
    ),
  );
}
