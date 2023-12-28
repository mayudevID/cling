import 'package:cling/core/utils.dart';
import 'package:cling/features/model/goal_saving_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/common_widget.dart';
import '../../../../../resources/gen/fonts.gen.dart';

Widget listSavingsGoal(String formatCurr, GoalSavingModel data) {
  return GestureDetector(
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10.wmea, vertical: 8.wmea),
      decoration: ShapeDecoration(
        color: const Color(0x3D787880),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat.yMd(formatCurr).format(data.date),
            style: TextStyle(
              color: Colors.white,
              fontSize: 9.5.sp,
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.w500,
            ),
          ),
          NominalMoneyFormatter(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 9.5.sp,
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.w700,
            ),
            amount: data.amount,
            decimalDigits: 2,
            isWithName: true,
          ),
        ],
      ),
    ),
  );
}
