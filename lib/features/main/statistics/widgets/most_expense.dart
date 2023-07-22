import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils.dart';
import '../../../../resources/gen/fonts.gen.dart';

Widget mostExpense(Map data) {
  return Container(
    margin: EdgeInsets.only(
      bottom: Utils.h(16).h,
    ),
    padding: EdgeInsets.all(
      Utils.w(16).w,
    ),
    width: double.infinity,
    decoration: BoxDecoration(
      color: const Color(0x3D787880),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        Container(
          padding: EdgeInsets.all(Utils.w(8).w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: data['image'],
        ),
        SizedBox(
          width: Utils.w(12).w,
        ),
        Text(
          data['name'],
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          "IDR ${data['expense'].toString()}",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 10.5.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    ),
  );
}
