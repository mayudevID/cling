import '../../../../model/expense_model.dart';
import '../../../../model/income_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/common_widget.dart';
import '../../../../../core/route.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../../model/transaction_model.dart';
import '../../../language_currency/lang_currency_bloc.dart';
import '../../main_widget/enum_flowtype.dart';

Widget itemDateAmountWidget(
  BuildContext context,
  TransactionModel data,
  bool isIncome,
) {
  final dateLocale = context
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
        arguments: [data, (isIncome) ? FlowType.income : FlowType.expense],
      );
    },
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0x3D787880),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (isIncome)
                    ? (data as IncomeModel).desc ?? ""
                    : (data as ExpenseModel).item,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.5,
                ),
              ),
              Text(
                DateFormat.yMd(dateLocale).format(data.date),
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: FontFamily.cabinetGrotesk,
                ),
              ),
            ],
          ),
          NominalMoneyFormatter(
            textStyle: const TextStyle(
              color: Colors.white,
              fontFamily: FontFamily.cabinetGrotesk,
            ),
            amount: data.amount,
            isWithName: true,
          ),
        ],
      ),
    ),
  );
}
