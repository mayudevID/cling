import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils.dart';
import '../../../../resources/gen/fonts.gen.dart';

Widget incomeAndExpense() {
  return Container(
    margin: EdgeInsets.symmetric(
      horizontal: Utils.w(20).w,
    ),
    width: double.infinity,
    padding: EdgeInsets.symmetric(
      horizontal: Utils.w(16).w,
      vertical: Utils.h(16).h,
    ),
    decoration: BoxDecoration(
      color: const Color(0x3D787880),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF07AC65),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Utils.w(8).w,
                vertical: Utils.h(10).h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Income ✨',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.5.sp,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: Utils.h(6).h,
                  ),
                  Text(
                    'IDR',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.5.sp,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '3,800,000',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.5.sp,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: Utils.w(16).w,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE54C19),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Utils.w(8).w,
                vertical: Utils.h(10).h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Expense 🙏',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.5.sp,
                      fontFamily: 'Cabinet Grotesk',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: Utils.h(6).h,
                  ),
                  Text(
                    'IDR',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.5.sp,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '-1,450,000',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.5.sp,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
