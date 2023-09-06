import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../resources/gen/fonts.gen.dart';
import '../../../../model/pie_data_expense_savings.dart';
import '../bloc/statistics_bloc.dart';

Widget pieChartWidget() {
  return BlocBuilder<StatisticsBloc, StatisticsState>(
    buildWhen: (previous, current) {
      return previous.pieDataExSavList != current.pieDataExSavList;
    },
    builder: (context, state) {
      final pieData = state.pieDataExSavList;
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

      if (pieData[0].amount == 0 && pieData[1].amount == 0) {
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
        height: 248.5.hmea,
        child: SfCircularChart(
          series: <DoughnutSeries<PieDataExSav, String>>[
            DoughnutSeries<PieDataExSav, String>(
              pointColorMapper: (datum, index) {
                switch (index) {
                  case 0:
                    return const Color(0xFFE54C19);
                  // case 1:
                  //   return const Color(0xFF07AC65);
                  case 1:
                    return const Color(0xFF006DE9);
                }
                return null;
              },
              dataSource: pieData,
              xValueMapper: (PieDataExSav data, _) => data.nameData,
              yValueMapper: (PieDataExSav data, _) => data.amount,
              dataLabelMapper: (PieDataExSav data, _) {
                return "${countPercentage(data.amount, pieData).round()}%";
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

double countPercentage(double count, List<PieDataExSav> dataList) {
  var data = 0.0;
  for (var element in dataList) {
    data += element.amount;
  }
  return (count / data) * 100;
}
