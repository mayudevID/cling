import 'package:cling/core/utils.dart';
import 'package:cling/features/ui/main/statistics/widgets/line_column_stats_all_widget.dart';
import 'package:cling/features/ui/main/statistics/widgets/pie_chart_stats_all_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_export.dart';
import '../bloc/statistics_bloc.dart';
import '../widgets/most_expense.dart';
import '../widgets/tag_info.dart';

class StatsAll extends StatelessWidget {
  const StatsAll({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Align(
        //   alignment: Alignment.center,
        //   child: Text(
        //     "${monthIntToString(context: context, time: DateTime.now())} ${DateTime.now().year}",
        //     textAlign: TextAlign.center,
        //     style: TextStyle(
        //       color: Colors.white,
        //       fontSize: 10.sp,
        //       fontFamily: FontFamily.cabinetGrotesk,
        //       fontWeight: FontWeight.w700,
        //     ),
        //   ),
        // ),
        SizedBox(
          height: 8.hmea,
        ),
        const TagInfo(),
        pieChartStatsAllWidget(),
        SizedBox(
          height: 24.hmea,
        ),
        Text(
          '${AppLocalizations.of(context)!.yearlyBreakdown} / ${DateTime.now().year}',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 10.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 24.hmea,
        ),
        lineColumnStatsAllWidget(context),
        SizedBox(
          height: 24.hmea,
        ),
        Text(
          AppLocalizations.of(context)!.mostExpense,
          style: TextStyle(
            color: Colors.white,
            fontSize: 11.5.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 16.hmea,
        ),
        BlocBuilder<StatisticsBloc, StatisticsState>(
          buildWhen: (p, c) {
            return p.mostExpenseList != c.mostExpenseList;
          },
          builder: (context, state) {
            if (state.mostExpenseList.isEmpty) {
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

            return MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                itemCount: state.mostExpenseList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return mostExpense(
                    state.mostExpenseList[index],
                  );
                },
              ),
            );
          },
        ),
        SizedBox(
          height: 128.hmea,
        ),
      ],
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
