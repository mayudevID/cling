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
          width: 15.wmea,
          height: 15.wmea,
          decoration: const ShapeDecoration(
            color: Color(0xFFE54C19),
            shape: OvalBorder(),
          ),
        ),
        SizedBox(
          width: 6.wmea,
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
          width: 11.wmea,
        ),
        Container(
          width: 15.wmea,
          height: 15.wmea,
          decoration: const ShapeDecoration(
            color: Color(0xFF07AC65),
            shape: OvalBorder(),
          ),
        ),
        SizedBox(
          width: 6.wmea,
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
          width: 11.wmea,
        ),
        Container(
          width: 15.wmea,
          height: 15.wmea,
          decoration: const ShapeDecoration(
            color: Color(0xFF006DE9),
            shape: OvalBorder(),
          ),
        ),
        SizedBox(
          width: 6.wmea,
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
