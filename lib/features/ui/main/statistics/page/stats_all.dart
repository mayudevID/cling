import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../home/page/home_page.dart';
import '../widgets/most_expense.dart';
import '../widgets/tag_info.dart';

class StatsAll extends StatelessWidget {
  StatsAll({super.key});

  final dataPieChart = [
    _PieData("Expense", 30000, "exp"),
    _PieData("Income", 100000, "inc"),
    _PieData("Savings", 15000, "save"),
  ];

  final List<ChartData> chartData = [
    ChartData(2023, 35),
    ChartData(2024, 23),
    ChartData(2025, 34),
    ChartData(2026, 25),
    ChartData(2027, 40)
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
        const TagInfo(),
        SizedBox(
          width: double.infinity,
          height: 248.5.hmea,
          child: SfCircularChart(
            series: <DoughnutSeries<_PieData, String>>[
              DoughnutSeries<_PieData, String>(
                pointColorMapper: (datum, index) {
                  switch (index) {
                    case 0:
                      return const Color(0xFFE54C19);
                    case 1:
                      return const Color(0xFF07AC65);
                    case 2:
                      return const Color(0xFF006DE9);
                  }
                  return null;
                },
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
        Text(
          'Yearly Breakdown',
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
        SizedBox(
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
              labelFormat: "IDR {value} K ",
              //maximumLabels: 2,
              majorGridLines: const MajorGridLines(
                color: Color(0xFF343437),
                dashArray: <double>[20, 2],
              ),
            ),
            series: [
              ColumnSeries<ChartData, int>(
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
              ColumnSeries<ChartData, int>(
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
              ColumnSeries<ChartData, int>(
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
        ),
        SizedBox(
          height: 24.hmea,
        ),
        Text(
          'Most Expense',
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
        MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView.builder(
            itemCount: dataDummyExpenses.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return mostExpense(
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
  _PieData(this.nameData, this.amount, this.text);
  final String nameData;
  final double amount;
  final String text;
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}

class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final double y;
}
