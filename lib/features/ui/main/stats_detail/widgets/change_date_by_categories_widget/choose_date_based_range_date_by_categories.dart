import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../main_widget/enum_range_date.dart';
import '../../bloc/stats_detail_bloc.dart';
import 'range_date_daily_by_categories.dart';
import 'range_date_monthly_by_categories.dart';
import 'range_date_period_by_categories.dart';
import 'range_date_yearly_by_categories.dart';

Widget chooseDateBasedRangeDateByCategories(BuildContext context) {
  return BlocBuilder<StatsDetailBloc, StatsDetailState>(
    buildWhen: (p, c) {
      return p.rangeDate.name != c.rangeDate.name;
    },
    builder: (context, state) {
      switch (state.rangeDate) {
        case RangeDate.daily:
          return rangeDateDailyByCategories(context);
        case RangeDate.period:
          return rangeDatePeriodByCategories(context);
        case RangeDate.monthy:
          return rangeDateMonthlyByCategories(context);
        case RangeDate.yearly:
          return rangeDateYearlyByCategories(context);
      }
    },
  );
}
