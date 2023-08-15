import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_export.dart';
import '../bloc/statistics_bloc.dart';
import '../widgets/custom_indexed_stack.dart';
import '../widgets/tag_chooser.dart';
import 'state_income.dart';
import 'stats_all.dart';
import 'stats_expense.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.wmea),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 16.hmea,
            ),
            Text(
              AppLocalizations.of(context)!.statistics,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 24.hmea,
            ),
            const TagChooser(),
            SizedBox(
              height: 24.hmea,
            ),
            BlocBuilder<StatisticsBloc, StatisticsState>(
              buildWhen: (previous, current) {
                return previous.typeCategories != current.typeCategories;
              },
              builder: (context, state) {
                return CustomIndexedStack(
                  curve: Curves.fastOutSlowIn,
                  index: state.typeCategories,
                  children: [
                    StatsAll(),
                    StatsIncome(),
                    StatsExpense(),
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
