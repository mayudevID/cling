import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
      margin: const EdgeInsets.only(left: 24, right: 24),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0x3D787880),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
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
                style: const TextStyle(fontSize: 9),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            expenseModel.item,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              NominalMoneyFormatter(
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
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
                  fontSize: 8.5,
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
