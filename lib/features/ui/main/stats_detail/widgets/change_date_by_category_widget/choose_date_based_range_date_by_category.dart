import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../main_widget/enum_range_date.dart';
import '../../bloc/stats_detail_bloc.dart';
import 'range_date_daily_by_category.dart';
import 'range_date_monthly_by_category.dart';
import 'range_date_period_by_category.dart';
import 'range_date_yearly_by_category.dart';

Widget chooseDateBasedRangeDateByCategory(BuildContext context) {
  return BlocBuilder<StatsDetailBloc, StatsDetailState>(
    buildWhen: (p, c) {
      return p.rangeDate.name != c.rangeDate.name;
    },
    builder: (context, state) {
      switch (state.rangeDate) {
        case RangeDate.daily:
          return rangeDateDailyByCategory(context);
        case RangeDate.period:
          return rangeDatePeriodByCategory(context);
        case RangeDate.monthy:
          return rangeDateMonthlyByCategory(context);
        case RangeDate.yearly:
          return rangeDateYearlyByCategory(context);
      }
    },
  );
}
