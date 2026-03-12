import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_export.dart';
import '../../main_widget/change_date_widget/choose_date_range.dart';
import '../bloc/statistics_bloc.dart';
import '../widgets/categories_with_amount_widget.dart';
import '../widgets/pie_chart_stats_expense.dart';

class StatsExpense extends StatelessWidget {
  const StatsExpense({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...chooseDateRange(context),
        const SizedBox(height: 4),
        pieChartStatsExpense(),
        Text(
          AppLocalizations.of(context)!.expenseBreakdown,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11.5,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        BlocBuilder<StatisticsBloc, StatisticsState>(
          buildWhen: (p, c) {
            return p.expenseBreakdownList != c.expenseBreakdownList;
          },
          builder: (context, state) {
            if (state.expenseBreakdownList.isEmpty) {
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
              child: ListView.separated(
                itemCount: state.expenseBreakdownList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, index) {
                  return categoriesWithAmount(
                    context: context,
                    data: state.expenseBreakdownList[index],
                    type: ["expense", "Categories", "TotalExpense"],
                    title: AppLocalizations.of(context)!.expenseBreakdown,
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 4);
                },
              ),
            );
          },
        ),
        const SizedBox(height: 90),
      ],
    );
  }
}
