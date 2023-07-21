import 'package:cling/features/main/statistics/widgets/tag_info.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../core/utils.dart';
import '../../../resources/gen/fonts.gen.dart';

class StatisticsPage extends StatelessWidget {
  StatisticsPage({super.key});

  final tagFlow = [
    "All",
    "Income",
    "Expense",
  ];

  final dataPieChart = [
    _PieData("Expense", 30000, "exp"),
    _PieData("Income", 100000, "inc"),
    _PieData("Savings", 15000, "save"),
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
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Utils.w(20).w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Utils.h(16).h,
            ),
            Text(
              'Statistics',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: Utils.h(24).h,
            ),
            Row(
              children: tagFlow.map(
                (e) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Utils.w(16).w,
                      vertical: Utils.h(8).h,
                    ),
                    margin: EdgeInsets.only(right: Utils.w(12).w),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF599DA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      e,
                      style: TextStyle(
                        color: const Color(0xFF101010),
                        fontSize: 13.5.sp,
                        fontFamily: FontFamily.cabinetGrotesk,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
            SizedBox(
              height: Utils.h(24).h,
            ),
            const TagInfo(),
            SizedBox(
              width: double.infinity,
              height: Utils.w(248.5).w,
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
            )
          ],
        ),
      ),
    );
  }
}

class _PieData {
  _PieData(this.nameData, this.amount, this.text);
  final String nameData;
  final double amount;
  final String text;
}
