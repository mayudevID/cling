import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/common_widget.dart';
import '../../../../../core/route.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../../model/expense_model.dart';
import '../../../../model/income_model.dart';
import '../../../../model/transaction_model.dart';
import '../../../language_currency/lang_currency_bloc.dart';
import '../../../language_currency/lang_export.dart';
import '../../main_widget/enum_flowtype.dart';

Widget listTransaction(
  BuildContext context,
  TransactionModel transactionModel,
) {
  final data = getTextAndCategories(context, transactionModel);
  final icon = data[1].substring(0, data[1].indexOf(" "));
  final cat = data[1].substring(data[1].indexOf(" ") + 1);
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
        arguments: [
          transactionModel,
          (data[2] == AppLocalizations.of(context)!.income)
              ? FlowType.income
              : FlowType.expense,
        ],
      );
    },
    child: Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0x3D787880),
      ),
      child: Row(
        children: [
          Container(
            height: 45.h,
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 18)),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 5.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 2.h,
                    horizontal: 6.w,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: (data[2] == AppLocalizations.of(context)!.income)
                        ? const Color(0xFF07AC65)
                        : const Color(0xFFE54C19),
                  ),
                  child: Text(
                    data[2],
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.bold,
                      fontSize: 8.sp,
                    ),
                  ),
                ),
                Text(
                  (data[0].isEmpty) ? cat : data[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              NominalMoneyFormatter(
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontFamily: FontFamily.cabinetGrotesk,
                ),
                amount: transactionModel.amount,
                isWithName: true,
              ),
              Text(
                DateFormat.jm(dateFormat).format(transactionModel.date),
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

List<String> getTextAndCategories(
  BuildContext context,
  TransactionModel data,
) {
  String textDesc;
  String categoriesOrSource;
  String type;

  switch (data.getType()) {
    case TransactionType.income:
      textDesc = (data as IncomeModel).desc ?? "";
      categoriesOrSource = data.incomeSource;
      type = AppLocalizations.of(context)!.income;
      break;
    case TransactionType.expense:
      textDesc = (data as ExpenseModel).item;
      categoriesOrSource = data.categories;
      type = AppLocalizations.of(context)!.expense;
      break;
  }
  return [textDesc, categoriesOrSource, type];
}
