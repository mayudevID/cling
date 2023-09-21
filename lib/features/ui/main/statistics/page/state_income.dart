import 'package:cling/core/utils.dart';
import 'package:cling/features/ui/main/statistics/widgets/line_column_stats_income.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_currency_bloc.dart';
import '../../../language_currency/lang_export.dart';

class StatsIncome extends StatelessWidget {
  StatsIncome({super.key});

  final List<IncomeData> chartData = [
    IncomeData("Jan", 35),
    IncomeData("Feb", 23),
    IncomeData("Mar", 23),
    IncomeData("Apr", 34),
    IncomeData("Mei", 25),
    IncomeData("Jun", 40),
    IncomeData("Jul", 35),
    IncomeData("Ags", 23),
    IncomeData("Sep", 34),
    IncomeData("Okt", 25),
    IncomeData("Nov", 40),
    IncomeData("Des", 40),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.yearlyBreakdown,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 24.hmea,
        ),
        lineColumnStatsIncomeWidget(context),
        SizedBox(
          height: 24.hmea,
        ),
        Text(
          AppLocalizations.of(context)!.incomeBreakdown,
          style: TextStyle(
            color: Colors.white,
            fontSize: 13.5.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 16.hmea,
        ),
        // MediaQuery.removePadding(
        //   context: context,
        //   removeTop: true,
        //   child: ListView.builder(
        //     itemCount: dataDummyExpenses.length,
        //     shrinkWrap: true,
        //     physics: const NeverScrollableScrollPhysics(),
        //     itemBuilder: (context, index) {
        //       return incomeWidget(
        //         dataDummyExpenses[index],
        //       );
        //     },
        //   ),
        // ),
        SizedBox(
          height: 90.hmea,
        ),
      ],
    );
  }
}

class IncomeData {
  IncomeData(this.x, this.y);
  final String x;
  final double y;
}
