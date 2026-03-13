import '../../../../../core/utils.dart';
import '../../../language_currency/lang_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../resources/gen/fonts.gen.dart';
import '../../../../model/chart_data.dart';
import '../../../language_currency/lang_currency_bloc.dart';
import '../bloc/statistics_bloc.dart';

Widget lineColumnStatsAllWidget(BuildContext mainContext) {
  return BlocBuilder<StatisticsBloc, StatisticsState>(
    buildWhen: (p, c) {
      return (p.chartDataExpenseList != c.chartDataExpenseList) ||
          (p.chartDataIncomeList != c.chartDataIncomeList) ||
          (p.chartDataSavingsList != c.chartDataSavingsList);
    },
    builder: (context, state) {
      if (state.chartDataExpenseList.isEmpty &&
          state.chartDataIncomeList.isEmpty &&
          state.chartDataSavingsList.isEmpty) {
        return const SizedBox(
          height: 200,
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

      final double monthNow = DateTime.now().month.toDouble();

      return SizedBox(
        height: 193,
        child: SfCartesianChart(
          tooltipBehavior: TooltipBehavior(
            enable: true,
            decimalPlaces: 2,
            textStyle: const TextStyle(
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.w700,
            ),
          ),
          zoomPanBehavior: ZoomPanBehavior(
            enablePanning: true,
          ),
          plotAreaBorderWidth: 0,
          plotAreaBorderColor: Colors.transparent,
          primaryXAxis: CategoryAxis(
            initialVisibleMinimum: monthNow - 2,
            initialVisibleMaximum: monthNow + 2,
            labelStyle: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.w700,
            ),
          ),
          primaryYAxis: NumericAxis(
            interval: setInterval(state.maxValAll),
            labelStyle: const TextStyle(
              color: Colors.white,
              fontSize: 12,
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
                "${mainContext.watch<LangCurrencyBloc>().state.selectedCurrency.name} {value}",
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
              name: AppLocalizations.of(context)!.expense,
              color: const Color(0xFFE54C19),
              dataSource: state.chartDataExpenseList,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              // Sets the corner radius
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              width: 1,
              spacing: 0.4,
            ),
            ColumnSeries<ChartData, String>(
              name: AppLocalizations.of(context)!.income,
              color: const Color(0xFF07AC65),
              dataSource: state.chartDataIncomeList,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              // Sets the corner radius
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              width: 1,
              spacing: 0.4,
            ),
            ColumnSeries<ChartData, String>(
              name: AppLocalizations.of(context)!.savings,
              color: const Color(0xFF006DE9),
              dataSource: state.chartDataSavingsList,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              width: 1,
              spacing: 0.4,
            )
          ],
        ),
      );
    },
  );
}
