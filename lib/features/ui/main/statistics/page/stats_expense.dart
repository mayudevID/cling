import 'package:cling/core/utils.dart';
import 'package:cling/features/ui/main/statistics/bloc/statistics_bloc.dart';
import 'package:cling/features/ui/main/statistics/widgets/pie_chart_stats_expense.dart';
import 'package:cling/resources/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/fonts.gen.dart';
import 'dart:math' as math;
import '../../../language_currency/lang_currency_bloc.dart';
import '../../../language_currency/lang_export.dart';
import '../widgets/expense_date_range_widget.dart';

class StatsExpense extends StatelessWidget {
  const StatsExpense({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        pieChartStatsExpense(),
        SizedBox(
          height: 24.hmea,
        ),
        Row(
          children: [
            Text(
              AppLocalizations.of(context)!.expense,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 11.5.sp,
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {},
              child:
                  Assets.lib.resources.images.fluentChevronLeft24Filled.svg(),
            ),
            SizedBox(
              width: 8.wmea,
            ),
            BlocBuilder<StatisticsBloc, StatisticsState>(
              buildWhen: (p, c) {
                //return p.dateRight != c.dateRight;
                return false;
              },
              builder: (context, state) {
                final dateRight = DateTime.now();
                final dateLeft = dateRight.subtract(const Duration(days: 7));

                final locale = context.select(
                  (LangCurrencyBloc bloc) {
                    return bloc.state.selectedLanguage.value.toLanguageTag();
                  },
                );

                final dateLeftFix = DateFormat.yMd(locale).format(dateLeft);
                final dateRightFix = DateFormat.yMd(locale).format(dateRight);

                return Text(
                  '$dateLeftFix - $dateRightFix',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9.5.sp,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
            SizedBox(
              width: 8.wmea,
            ),
            GestureDetector(
              onTap: () {},
              child: Transform.rotate(
                angle: math.pi,
                child:
                    Assets.lib.resources.images.fluentChevronLeft24Filled.svg(),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.hmea),
        BlocBuilder<StatisticsBloc, StatisticsState>(
          buildWhen: (p, c) {
            return p.expenseDateRangeList != c.expenseDateRangeList;
          },
          builder: (context, state) {
            if (state.expenseDateRangeList.isEmpty) {
              return const Center(
                child: Text(
                  "No data :(",
                  style: TextStyle(
                    fontFamily: FontFamily.cabinetGrotesk,
                    color: Colors.white,
                  ),
                ),
              );
            }

            return MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                itemCount: state.expenseDateRangeList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return expenseDateRangeWidget(
                    state.expenseDateRangeList[index],
                  );
                },
              ),
            );
          },
        ),
        SizedBox(
          height: 90.hmea,
        ),
      ],
    );
  }
}
