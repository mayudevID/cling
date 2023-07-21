import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils.dart';

class TagInfo extends StatelessWidget {
  const TagInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: Utils.w(15).w,
          height: Utils.w(15).w,
          decoration: const ShapeDecoration(
            color: Color(0xFFE54C19),
            shape: OvalBorder(),
          ),
        ),
        SizedBox(
          width: Utils.w(6).w,
        ),
        Text(
          'Expense',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 10.sp,
            fontFamily: 'Cabinet Grotesk',
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          width: Utils.w(11).w,
        ),
        Container(
          width: Utils.w(15).w,
          height: Utils.w(15).w,
          decoration: const ShapeDecoration(
            color: Color(0xFF07AC65),
            shape: OvalBorder(),
          ),
        ),
        SizedBox(
          width: Utils.w(6).w,
        ),
        Text(
          'Income',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 10.sp,
            fontFamily: 'Cabinet Grotesk',
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          width: Utils.w(11).w,
        ),
        Container(
          width: Utils.w(15).w,
          height: Utils.w(15).w,
          decoration: const ShapeDecoration(
            color: Color(0xFF006DE9),
            shape: OvalBorder(),
          ),
        ),
        SizedBox(
          width: Utils.w(6).w,
        ),
        Text(
          'Savings',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 10.sp,
            fontFamily: 'Cabinet Grotesk',
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
