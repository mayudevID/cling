import 'package:cling/core/utils.dart';
import 'package:cling/resources/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../resources/gen/fonts.gen.dart';
import 'dart:math' as math;
import '../../../language_currency/lang_export.dart';
import '../../home/page/home_page.dart';
import '../widgets/expense_widget.dart';

class StatsExpense extends StatelessWidget {
  StatsExpense({super.key});

  final dataPieChart = [
    _PieData("Makan", 30000),
    _PieData("Minum", 100000),
    _PieData("Beli Hero", 15000),
    _PieData("Beli lambo", 22333),
    _PieData("Beli ayam", 85762),
    _PieData("Beli bebek", 6645),
    _PieData("Beli kuda", 343211),
    _PieData("Beli sapi", 99546),
    _PieData("Beli sapi 2", 99546),
    _PieData("Beli sapi 3", 99546),
    _PieData("Beli sapi 4", 99546),
  ];

  double countPercentage(double count) {
    var data = 0.0;
    for (var element in dataPieChart) {
      data += element.amount;
    }
    return (count / data) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
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
            series: <DoughnutSeries<_PieData, String>>[
              DoughnutSeries<_PieData, String>(
                dataSource: dataPieChart,
                xValueMapper: (_PieData data, _) => data.nameData,
                yValueMapper: (_PieData data, _) => data.amount,
                dataLabelMapper: (_PieData data, _) {
                  return "${countPercentage(data.amount).round()}%";
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
        ),
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
                fontSize: 13.5.sp,
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Assets.lib.resources.images.fluentChevronLeft24Filled.svg(),
            SizedBox(
              width: 8.wmea,
            ),
            Text(
              '01/01/23 - 01/01/23',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.5.sp,
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              width: 8.wmea,
            ),
            Transform.rotate(
              angle: math.pi,
              child:
                  Assets.lib.resources.images.fluentChevronLeft24Filled.svg(),
            ),
          ],
        ),
        SizedBox(height: 16.hmea),
        MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView.builder(
            itemCount: dataDummyExpenses.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return expenseWidget(
                dataDummyExpenses[index],
              );
            },
          ),
        ),
        SizedBox(
          height: 90.hmea,
        ),
      ],
    );
  }
}

class _PieData {
  _PieData(this.nameData, this.amount);
  final String nameData;
  final double amount;
}
