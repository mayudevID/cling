import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/utils.dart';
import '../../../resources/gen/fonts.gen.dart';

class StatisticsPage extends StatelessWidget {
  StatisticsPage({super.key});

  final tagFlow = [
    "All",
    "Income",
    "Expense",
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Utils.w(20).w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Utils.h(16).h,
            ),
            Text(
              'Statistics',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: Utils.h(24).h,
            ),
            Row(
              children: tagFlow.map(
                (e) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Utils.w(16).w,
                      vertical: Utils.h(8).h,
                    ),
                    margin: EdgeInsets.only(right: Utils.w(12).w),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF599DA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      e,
                      style: TextStyle(
                        color: const Color(0xFF101010),
                        fontSize: 13.5.sp,
                        fontFamily: FontFamily.cabinetGrotesk,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                },
              ).toList(),
            )
          ],
        ),
      ),
    );
  }
}
