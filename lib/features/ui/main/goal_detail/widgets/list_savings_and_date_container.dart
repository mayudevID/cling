import 'package:cling/core/utils.dart';
import 'package:cling/features/ui/language_currency/lang_currency_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_export.dart';

Widget listSavingsWithDateContainer(
  BuildContext context,
  DateTime itemDate,
  Widget container,
) {
  final dateLocale = context
      .read<LangCurrencyBloc>()
      .state
      .selectedLanguage
      .value
      .toLanguageTag();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Row(
        children: [
          //Container(width: 24.wmea, height: 1.hmea, color: Colors.grey),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              (itemDate.isAtSameMomentAs(
                DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                ),
              ))
                  ? AppLocalizations.of(context)!.today
                  : DateFormat.yMMMMEEEEd(dateLocale).format(itemDate),
              style: TextStyle(
                color: Colors.white,
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.w700,
                fontSize: 9.2.sp,
              ),
            ),
          ),
          Expanded(child: Container(height: 1.hmea, color: Colors.grey)),
        ],
      ),
      SizedBox(height: 8.hmea),
      container,
    ],
  );
}
