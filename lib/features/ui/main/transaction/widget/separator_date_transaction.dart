import '../../../language_currency/lang_currency_bloc.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../model/transaction_model.dart';

Widget separatorDateTransaction(BuildContext context, TransactionModel model) {
  final dateLocale = context
      .read<LangCurrencyBloc>()
      .state
      .selectedLanguage
      .value
      .toLanguageTag();

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Row(
      children: [
        Text(
          model.date.day.toString().padLeft(2, "0"),
          style: const TextStyle(
            color: Colors.white,
            fontFamily: FontFamily.cabinetGrotesk,
            fontSize: 30,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat("EEEE", dateLocale).format(model.date),
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
              Text(
                DateFormat("MMM y", dateLocale).format(model.date),
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontSize: 8.5,
                ),
              ),
              const SizedBox(height: 2.8)
            ],
          ),
        ),
      ],
    ),
  );
}
