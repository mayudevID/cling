import 'package:cling/core/utils.dart';
import 'package:cling/features/ui/language_currency/lang_currency_bloc.dart';
import 'package:cling/resources/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../model/transaction_model.dart';

Widget separatorDateTransaction(BuildContext context, TransactionModel model) {
  final dateLocale = context
      .read<LangCurrencyBloc>()
      .state
      .selectedLanguage
      .value
      .toLanguageTag();

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 10.wmea),
    child: Row(
      children: [
        Text(
          model.date.day.toString().padLeft(2, "0"),
          style: TextStyle(
            color: Colors.white,
            fontFamily: FontFamily.cabinetGrotesk,
            fontSize: 30.sp,
          ),
        ),
        SizedBox(width: 8.wmea),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat("EEEE", dateLocale).format(model.date),
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.bold,
                  fontSize: 10.sp,
                ),
              ),
              Text(
                DateFormat("MMM y", dateLocale).format(model.date),
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontSize: 8.5.sp,
                ),
              ),
              SizedBox(height: 2.8.hmea)
            ],
          ),
        ),
      ],
    ),
  );
}
