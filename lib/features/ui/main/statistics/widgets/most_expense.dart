import 'package:cling/core/common_widget.dart';
import 'package:cling/core/utils.dart';
import 'package:cling/features/model/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/fonts.gen.dart';

Widget mostExpense(ExpenseModel data) {
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
              data.categories.substring(
                0,
                data.categories.indexOf(" "),
              ),
              style: TextStyle(fontSize: 24.sp),
            ),
          ),
        ),
        SizedBox(
          width: 12.wmea,
        ),
        Text(
          data.item,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        NominalMoneyFormatter(
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 10.5.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w500,
          ),
          amount: data.amount,
          decimalDigits: 2,
          isWithName: true,
        ),
      ],
    ),
  );
}
