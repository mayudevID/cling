import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../../resources/gen/assets.gen.dart';
import '../../../../../../resources/gen/fonts.gen.dart';
import '../../../../language_currency/lang_currency_bloc.dart';
import '../../bloc/statistics_bloc.dart';
import "dart:math" as math;

Widget rangeDateMonthly(BuildContext context, StatisticsState state) {
  final formatCurr = context.select(
    (LangCurrencyBloc bloc) {
      return bloc.state.selectedLanguage.value.toLanguageTag();
    },
  );

  return Row(
    children: [
      GestureDetector(
        onTap: () {
          context.read<StatisticsBloc>().add(const ChangeMonthly(0));
        },
        child: Assets.lib.resources.images.fluentChevronLeft24Filled.svg(),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: GestureDetector(
          onTap: () {
            context.read<StatisticsBloc>().add(const ChangeMonthly(null));
          },
          child: Container(
            padding: EdgeInsets.all(14.wmea),
            decoration: BoxDecoration(
              color: const Color(0x3D787880),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  DateFormat.yMMMM(formatCurr).format(state.dateRight),
                  key: ValueKey<String>(state.dateRight.toString()),
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: FontFamily.cabinetGrotesk,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(width: 8),
      GestureDetector(
        onTap: () {
          context.read<StatisticsBloc>().add(const ChangeMonthly(1));
        },
        child: Transform.rotate(
          angle: math.pi,
          child: Assets.lib.resources.images.fluentChevronLeft24Filled.svg(),
        ),
      ),
    ],
  );
}
