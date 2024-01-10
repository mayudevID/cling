import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../core/common_widget.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../../model/pie_data_expense_savings.dart';
import '../bloc/statistics_bloc.dart';

Widget pieChartStatsAllWidget() {
  return BlocBuilder<StatisticsBloc, StatisticsState>(
    buildWhen: (previous, current) {
      return previous.pieDataExSavList != current.pieDataExSavList;
    },
    builder: (context, state) {
      final pieData = state.pieDataExSavList;
      if (pieData.isEmpty ||
          (pieData[0].amount == 0 && pieData[1].amount == 0)) {
        return Padding(
          padding: EdgeInsets.only(top: 24.hmea),
          child: SizedBox(
            height: 200.hmea,
            child: const Center(
              child: Text(
                "No data :(",
                style: TextStyle(
                  fontFamily: FontFamily.cabinetGrotesk,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      }

      double dataTot = 0.0;
      for (PieDataExSav element in pieData) {
        dataTot += element.amount;
      }

      return SizedBox(
        height: 248.5.hmea,
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
              final newData = data as PieDataExSav;
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
                      newData.nameData,
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
          series: <DoughnutSeries<PieDataExSav, String>>[
            DoughnutSeries<PieDataExSav, String>(
              pointColorMapper: (datum, index) {
                switch (index) {
                  case 0:
                    return const Color(0xFFE54C19);
                  case 1:
                    return const Color(0xFF006DE9);
                }
                return null;
              },
              dataSource: pieData,
              xValueMapper: (PieDataExSav data, _) => data.nameData,
              yValueMapper: (PieDataExSav data, _) => data.amount,
              dataLabelMapper: (PieDataExSav data, _) {
                return "${((data.amount / dataTot) * 100).round()}%";
              },
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 9.5.sp,
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
