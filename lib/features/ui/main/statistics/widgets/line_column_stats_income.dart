import 'package:cling/core/utils.dart';
import 'package:cling/features/model/chart_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_currency_bloc.dart';
import '../bloc/statistics_bloc.dart';

Widget lineColumnStatsIncomeWidget(BuildContext mainContext) {
  return BlocBuilder<StatisticsBloc, StatisticsState>(
    buildWhen: (p, c) {
      return p.yearlyIncomeList != c.yearlyIncomeList;
    },
    builder: (context, state) {
      if (state.yearlyIncomeList.isEmpty) {
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

      return SizedBox(
        width: double.infinity,
        height: 193.hmea,
        child: SfCartesianChart(
          // zoomPanBehavior: ZoomPanBehavior(
          //   enablePanning: true,
          // ),
          tooltipBehavior: TooltipBehavior(
            enable: true,
            decimalPlaces: 2,
            textStyle: const TextStyle(
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.w700,
            ),
          ),
          plotAreaBorderWidth: 0,
          plotAreaBorderColor: Colors.transparent,
          primaryXAxis: CategoryAxis(
            interval: 1,
            labelStyle: TextStyle(
              color: Colors.white,
              fontSize: 7.5.sp,
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.w700,
            ),
          ),
          primaryYAxis: NumericAxis(
            interval: setInterval(state.maxValIncome),
            labelStyle: TextStyle(
              color: Colors.white,
              fontSize: 9.5.sp,
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.w700,
            ),
            numberFormat: NumberFormat.compactCurrency(
              locale: mainContext
                  .watch<LangCurrencyBloc>()
                  .state
                  .selectedCurrency
                  .value
                  .toLanguageTag(),
              decimalDigits: 2,
              name: "",
            ),
            labelFormat:
                "${context.watch<LangCurrencyBloc>().state.selectedCurrency.name} {value}",
            //maximumLabels: 2,
            majorGridLines: const MajorGridLines(
              width: 1,
              color: Color(0xFF343437),
              dashArray: <double>[20, 2],
            ),
            minorGridLines: const MinorGridLines(
              color: Color(0xFF343437),
              dashArray: <double>[20, 2],
              width: 1,
            ),
          ),
          series: [
            ColumnSeries<ChartData, String>(
              name: "",
              color: const Color(0xFF07AC65),
              dataSource: state.yearlyIncomeList,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              // Sets the corner radius
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
              width: 0.6,
              spacing: 0.2,
            ),
          ],
        ),
      );
    },
  );
}
