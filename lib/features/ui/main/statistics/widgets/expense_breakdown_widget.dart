import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/common_widget.dart';
import '../../../../../resources/gen/fonts.gen.dart';

Widget expenseBreakdownWidget(Map<String, dynamic> data) {
  return Container(
    margin: EdgeInsets.only(bottom: 16.hmea),
    padding: EdgeInsets.all(16.wmea),
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
              " ${data['Categories'].substring(0, data['Categories'].indexOf(" "))}",
              style: TextStyle(fontSize: 9.sp),
            ),
          ),
        ),
        SizedBox(
          width: 12.wmea,
        ),
        Text(
          data["Categories"].substring(data["Categories"].indexOf(" ") + 1),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 10.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w500,
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
          amount: data["TotalExpense"],
          decimalDigits: 2,
          isWithName: true,
        ),
      ],
    ),
  );
}
