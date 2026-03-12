import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_export.dart';
import '../bloc/statistics_bloc.dart';
import '../widgets/custom_indexed_stack.dart';
import '../widgets/tag_chooser.dart';
import 'state_income.dart';
import 'stats_all.dart';
import 'stats_expense.dart';

class StatisticsPage extends StatelessWidget {
  StatisticsPage({super.key});

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.statistics,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 24),
            const TagChooser(),
            const SizedBox(height: 24),
            BlocBuilder<StatisticsBloc, StatisticsState>(
              buildWhen: (previous, current) {
                return previous.typeCategories != current.typeCategories;
              },
              builder: (context, state) {
                return CustomIndexedStack(
                  curve: Curves.fastOutSlowIn,
                  index: state.typeCategories,
                  children: [
                    StatsAll(scrollController: _scrollController),
                    const StatsIncome(),
                    const StatsExpense(),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
