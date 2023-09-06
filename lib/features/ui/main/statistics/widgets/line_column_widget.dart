import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_currency_bloc.dart';
import '../bloc/statistics_bloc.dart';

Widget lineColumnWidget(BuildContext mainContext) {
  return BlocBuilder<StatisticsBloc, StatisticsState>(
    builder: (context, state) {
      return SizedBox(
        width: double.infinity,
        height: 193.hmea,
        child: SfCartesianChart(
          plotAreaBorderWidth: 0,
          plotAreaBorderColor: Colors.transparent,
          primaryXAxis: CategoryAxis(
            labelStyle: TextStyle(
              color: Colors.white,
              fontSize: 10.5.sp,
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.w700,
            ),
          ),
          primaryYAxis: NumericAxis(
            labelStyle: TextStyle(
              color: Colors.white,
              fontSize: 10.5.sp,
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.w700,
            ),
            labelFormat:
                "${mainContext.watch<LangCurrencyBloc>().state.selectedCurrency.name} {value} K ",
            //maximumLabels: 2,
            majorGridLines: const MajorGridLines(
              color: Color(0xFF343437),
              dashArray: <double>[20, 2],
            ),
          ),
          series: [
            ColumnSeries<ChartData, String>(
              color: const Color(0xFFE54C19),
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              // Sets the corner radius
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
              width: 1,
              spacing: 0.4,
            ),
            ColumnSeries<ChartData, String>(
              color: const Color(0xFF07AC65),
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              // Sets the corner radius
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
              width: 1,
              spacing: 0.4,
            ),
            ColumnSeries<ChartData, String>(
              color: const Color(0xFF006DE9),
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
              width: 1,
              spacing: 0.4,
            )
          ],
        ),
      );
    },
  );
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}

final List<ChartData> chartData = [
  ChartData("2023", 35),
  ChartData("2024", 23),
  ChartData("2025", 34),
  ChartData("2026", 25),
  ChartData("2027", 40)
];
