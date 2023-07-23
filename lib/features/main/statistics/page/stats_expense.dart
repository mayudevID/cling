import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../core/utils.dart';
import '../../../../resources/gen/fonts.gen.dart';

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
          height: Utils.w(248.5).w,
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
      ],
    );
  }
}

class _PieData {
  _PieData(this.nameData, this.amount);
  final String nameData;
  final double amount;
}
