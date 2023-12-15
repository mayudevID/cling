import 'package:cling/core/utils.dart';
import 'package:cling/features/ui/language_currency/lang_currency_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/common_widget.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../../model/income_model.dart';

Widget itemDateAmountIncomeWidget(BuildContext context, IncomeModel data) {
  final dateLocale = context
      .read<LangCurrencyBloc>()
      .state
      .selectedLanguage
      .value
      .toLanguageTag();

  return Container(
    padding: EdgeInsets.all(16.hmea),
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
              data.desc ?? "No Description",
              style: TextStyle(
                color: Colors.white,
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.bold,
                fontSize: 10.5.sp,
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
          decimalDigits: 2,
          isWithName: true,
        ),
      ],
    ),
  );
}
