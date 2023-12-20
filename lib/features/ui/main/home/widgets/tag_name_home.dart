import 'package:cling/core/utils.dart';
import 'package:cling/features/ui/language_currency/lang_currency_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/fonts.gen.dart';

List<Widget> tagNameHome(
  BuildContext context,
  String name, {
  bool withDate = false,
}) {
  return [
    SizedBox(height: 24.hmea),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.wmea),
      child: RichText(
        text: TextSpan(
          text: name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.5.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w700,
          ),
          children: (withDate)
              ? [
                  TextSpan(
                    text: " / ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.5.sp,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: DateFormat.yMMMM(
                      context.select(
                        (LangCurrencyBloc bloc) {
                          return bloc.state.selectedLanguage.value
                              .toLanguageTag();
                        },
                      ),
                    ).format(
                      DateTime.now(),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ]
              : null,
        ),
      ),
    ),
    SizedBox(
      height: 16.hmea,
    ),
  ];
}
