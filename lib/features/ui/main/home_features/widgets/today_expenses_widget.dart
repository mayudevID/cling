import 'package:cling/core/utils.dart';
import 'package:cling/features/model/expense_model.dart';
import 'package:cling/resources/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

Widget todayExpensesWidget(ExpenseModel expenseModel) {
  return Container(
    margin: EdgeInsets.only(
      left: 20.wmea,
      right: 20.wmea,
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
          child: Text(
            expenseModel.categories.substring(
              0,
              expenseModel.categories.indexOf(" "),
            ),
            style: TextStyle(fontSize: 24.sp),
          ),
        ),
        SizedBox(
          width: 12.wmea,
        ),
        Text(
          expenseModel.item,
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
          NumberFormat.currency(
            locale: "id",
            decimalDigits: 2,
            name: "IDR ",
          ).format(expenseModel.amount),
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
