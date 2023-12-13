import 'package:cling/core/utils.dart';
import 'package:cling/features/ui/main/statistics/bloc/statistics_bloc.dart';
import 'package:cling/features/ui/main/statistics/widgets/change_date_widget/choose_date_range.dart';
import 'package:cling/features/ui/main/statistics/widgets/pie_chart_stats_expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_export.dart';
import '../widgets/expense_date_range_widget.dart';

class StatsExpense extends StatelessWidget {
  const StatsExpense({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...chooseDateRange(context),
        pieChartStatsExpense(),
        Text(
          AppLocalizations.of(context)!.expenseBreakdown,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 11.5.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 16.hmea),
        BlocBuilder<StatisticsBloc, StatisticsState>(
          buildWhen: (p, c) {
            return p.expenseDateRangeList != c.expenseDateRangeList;
          },
          builder: (context, state) {
            if (state.expenseDateRangeList.isEmpty) {
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
                itemCount: state.expenseDateRangeList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, index) {
                  return expenseDateRangeWidget(
                    state.expenseDateRangeList[index],
                  );
                },
              ),
            );
          },
        ),
        SizedBox(height: 90.hmea),
      ],
    );
  }
}
