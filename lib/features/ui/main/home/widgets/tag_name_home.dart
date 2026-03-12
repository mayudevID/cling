import '../../../language_currency/lang_currency_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../resources/gen/fonts.gen.dart';

List<Widget> tagNameHome(
  BuildContext context,
  String name, {
  bool withDate = false,
}) {
  return [
    const SizedBox(height: 24),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: RichText(
        text: TextSpan(
          text: name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12.5,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w700,
          ),
          children: (withDate)
              ? [
                  const TextSpan(
                    text: " / ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.5,
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ]
              : null,
        ),
      ),
    ),
    const SizedBox(
      height: 16,
    ),
  ];
}
