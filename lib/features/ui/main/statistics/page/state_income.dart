import '../widgets/categories_with_amount_widget.dart';
import '../widgets/line_column_stats_income.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_export.dart';
import '../bloc/statistics_bloc.dart';
import '../../main_widget/change_date_widget/choose_date_range.dart';

class StatsIncome extends StatelessWidget {
  const StatsIncome({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${AppLocalizations.of(context)!.yearlyBreakdown} / ${DateTime.now().year}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 24),
        lineColumnStatsIncomeWidget(context),
        const SizedBox(height: 24),
        Text(
          AppLocalizations.of(context)!.incomeBreakdown,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11.5,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        ...chooseDateRange(context),
        const SizedBox(
          height: 16,
        ),
        BlocBuilder<StatisticsBloc, StatisticsState>(
          buildWhen: (p, c) {
            return p.incomeBreakdownList != c.incomeBreakdownList;
          },
          builder: (context, state) {
            if (state.incomeBreakdownList.isEmpty) {
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
                itemCount: state.incomeBreakdownList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return categoriesWithAmount(
                    context: context,
                    data: state.incomeBreakdownList[index],
                    type: ["income", "Source", "TotalIncome"],
                    title: AppLocalizations.of(context)!.incomeBreakdown,
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 4),
              ),
            );
          },
        ),
        const SizedBox(height: 90),
      ],
    );
  }
}
