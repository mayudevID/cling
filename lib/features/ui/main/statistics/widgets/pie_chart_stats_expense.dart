import 'package:cling/core/utils.dart';
import 'package:cling/features/ui/main/statistics/bloc/statistics_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../resources/gen/fonts.gen.dart';
import '../../../../model/pie_data_expense.dart';

Widget pieChartStatsExpense() {
  return BlocBuilder<StatisticsBloc, StatisticsState>(
    buildWhen: (p, c) {
      return p.expenseBreakdownList != c.expenseBreakdownList;
    },
    builder: (context, state) {
      final pieData = state.expenseBreakdownList;
      if (pieData.isEmpty) {
        return Padding(
          padding: EdgeInsets.only(top: 24.hmea),
          child: const Center(
            child: Text(
              "No data :(",
              style: TextStyle(
                fontFamily: FontFamily.cabinetGrotesk,
                color: Colors.white,
              ),
            ),
          ),
        );
      }

      return SizedBox(
        width: double.infinity,
        height: 248.5.wmea,
        child: SfCircularChart(
          tooltipBehavior: TooltipBehavior(
            enable: true,
          ),
          legend: Legend(
            isResponsive: true,
            isVisible: true,
            overflowMode: LegendItemOverflowMode.wrap,
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 10.5.sp,
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.w700,
            ),
          ),
          series: <DoughnutSeries<PieDataExpense, String>>[
            DoughnutSeries<PieDataExpense, String>(
              dataSource: pieData,
              xValueMapper: (PieDataExpense data, _) => data.nameCategories,
              yValueMapper: (PieDataExpense data, _) => data.amount,
              dataLabelMapper: (PieDataExpense data, _) {
                return "${_countPercentage(data.amount, pieData).round()}%";
              },
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 10.5.sp,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

double _countPercentage(double count, List<PieDataExpense> dataPieChart) {
  var data = 0.0;
  for (var element in dataPieChart) {
    data += element.amount;
  }
  return (count / data) * 100;
}
