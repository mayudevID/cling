import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../resources/gen/fonts.gen.dart';
import '../../home/page/home_page.dart';
import '../widgets/income_widget.dart';

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
              ColumnSeries<IncomeData, String>(
                color: const Color(0xFF07AC65),
                dataSource: chartData,
                xValueMapper: (IncomeData data, _) => data.x,
                yValueMapper: (IncomeData data, _) => data.y,
                // Sets the corner radius
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
                width: 0.6,
                spacing: 0.2,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 24.hmea,
        ),
        Text(
          'Income Breakdown',
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
              return incomeWidget(
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

class IncomeData {
  IncomeData(this.x, this.y);
  final String x;
  final double y;
}
