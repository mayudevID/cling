import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/common_widget.dart';
import '../../../../../core/route.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../../model/expense_model.dart';
import '../../../language_currency/lang_currency_bloc.dart';
import '../../main_widget/enum_flowtype.dart';

Widget todayExpensesWidget(BuildContext context, ExpenseModel expenseModel) {
  final dateFormat = context
      .read<LangCurrencyBloc>()
      .state
      .selectedLanguage
      .value
      .toLanguageTag();
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(
        context,
        RouteName.editInEx,
        arguments: [expenseModel, FlowType.expense],
      );
    },
    behavior: HitTestBehavior.opaque,
    child: Container(
      margin: EdgeInsets.only(left: 24.w, right: 24.w),
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0x3D787880),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                " ${expenseModel.categories.substring(
                  0,
                  expenseModel.categories.indexOf(" "),
                )}",
                style: TextStyle(fontSize: 9.sp),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            expenseModel.item,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.sp,
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              NominalMoneyFormatter(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w500,
                ),
                amount: expenseModel.amount,
                isWithName: true,
              ),
              Text(
                DateFormat.jm(dateFormat).format(expenseModel.date),
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontSize: 8.5.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
