import 'package:cling/core/common_widget.dart';
import 'package:cling/core/route.dart';
import 'package:cling/core/utils.dart';
import 'package:cling/resources/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

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
      margin: EdgeInsets.only(left: 24.wmea, right: 24.wmea),
      padding: EdgeInsets.symmetric(vertical: 8.hmea, horizontal: 16.wmea),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0x3D787880),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(5.wmea),
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
          SizedBox(width: 12.wmea),
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
