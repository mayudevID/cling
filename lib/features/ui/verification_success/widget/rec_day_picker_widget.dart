import '../../../../core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../../../resources/gen/assets.gen.dart';
import '../../../../resources/gen/fonts.gen.dart';
import '../../language_currency/lang_export.dart';
import '../bloc/monthly_data_bloc.dart';
import 'dart:math' as math;

Widget recDayPickerWidget(BuildContext context) {
  return SizedBox(
    height: 200,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.recurringEveryDate,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                final int day =
                    context.read<MonthlyDataBloc>().state.dateRec - 1;
                context.read<MonthlyDataBloc>().add(RecDay(day.clamp(0, 28)));
              },
              child:
                  Assets.lib.resources.images.fluentChevronLeft24Filled.svg(),
            ),
            const SizedBox(width: 16),
            BlocBuilder<MonthlyDataBloc, MonthlyDataState>(
              buildWhen: (p, c) => p.dateRec != c.dateRec,
              builder: (context, state) {
                return NumberPicker(
                  itemCount: 1,
                  axis: Axis.horizontal,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white),
                  ),
                  textMapper: (numberText) {
                    return getRankString(int.parse(numberText));
                  },
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w600,
                  ),
                  selectedTextStyle: const TextStyle(
                    color: Colors.white,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  value: state.dateRec,
                  minValue: 0,
                  maxValue: 28,
                  onChanged: (int value) {},
                );
              },
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () {
                final int day =
                    context.read<MonthlyDataBloc>().state.dateRec + 1;
                context.read<MonthlyDataBloc>().add(RecDay(day.clamp(0, 28)));
              },
              child: Transform.rotate(
                angle: math.pi,
                child:
                    Assets.lib.resources.images.fluentChevronLeft24Filled.svg(),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
