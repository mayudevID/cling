import 'package:cling/features/main/statistics/bloc/statistics_bloc.dart';
import 'package:cling/features/main/statistics/page/state_income.dart';
import 'package:cling/features/main/statistics/page/stats_all.dart';
import 'package:cling/features/main/statistics/page/stats_expense.dart';
import 'package:cling/features/main/statistics/widgets/tag_chooser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sizer/sizer.dart';

import '../../../../core/utils.dart';
import '../../../../resources/gen/fonts.gen.dart';
import '../widgets/custom_indexed_stack.dart';

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
              height: 24.hmea,
            ),
            TagChooser(),
            SizedBox(
              height: 24.hmea,
            ),
            BlocBuilder<StatisticsBloc, StatisticsState>(
              builder: (context, state) {
                return CustomIndexedStack(
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
