import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../core/common_widget.dart';
import '../../../../../core/logger.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../../model/pie_data_expense.dart';
import '../bloc/statistics_bloc.dart';

Widget pieChartStatsExpense() {
  return BlocBuilder<StatisticsBloc, StatisticsState>(
    buildWhen: (p, c) {
      return p.pieDataExpenseList != c.pieDataExpenseList;
    },
    builder: (context, state) {
      if (state.pieDataExpenseList.isEmpty) {
        return const SizedBox(
          height: 248.5,
          child: Center(
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

      double dataTot = 0.0;
      for (final PieDataExpense element in state.pieDataExpenseList) {
        dataTot += element.amount;
      }

      return SizedBox(
        width: double.infinity,
        height: 248.5,
        child: SfCircularChart(
          tooltipBehavior: TooltipBehavior(
            enable: true,
            builder: (
              dynamic data,
              dynamic point,
              dynamic series,
              int pointIndex,
              int seriesIndex,
            ) {
              final newData = data as PieDataExpense;
              Logger.Red.log("${newData.amount}");
              return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      newData.nameCategories,
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: FontFamily.cabinetGrotesk,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    NominalMoneyFormatter(
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontFamily: FontFamily.cabinetGrotesk,
                      ),
                      amount: newData.amount,
                      isWithName: true,
                    ),
                  ],
                ),
              );
            },
          ),
          legend: const Legend(
            isResponsive: true,
            isVisible: true,
            position: LegendPosition.right,
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 10.061,
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.w700,
            ),
          ),
          series: <DoughnutSeries<PieDataExpense, String>>[
            DoughnutSeries<PieDataExpense, String>(
              dataSource: state.pieDataExpenseList,
              legendIconType: LegendIconType.circle,
              xValueMapper: (PieDataExpense data, _) => data.nameCategories,
              yValueMapper: (PieDataExpense data, _) => data.amount,
              dataLabelMapper: (PieDataExpense data, _) {
                return "${((data.amount / dataTot) * 100).round()}%";
              },
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
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
