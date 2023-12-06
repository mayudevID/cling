import 'package:cling/features/ui/main/statistics/widgets/change_date_widget/range_date_yearly.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/statistics_bloc.dart';
import 'range_date_daily.dart';
import 'range_date_monthly.dart';
import 'range_date_period.dart';

Widget chooseDateBasedRangeDate(BuildContext context) {
  return BlocBuilder<StatisticsBloc, StatisticsState>(
    buildWhen: (p, c) {
      return (p.rangeDate.name != c.rangeDate.name) ||
          (p.dateRight != c.dateRight) ||
          (p.dateLeft != c.dateLeft);
    },
    builder: (context, state) {
      switch (state.rangeDate) {
        case RangeDate.daily:
          return rangeDateDaily(context, state);
        case RangeDate.period:
          return rangeDatePeriod(context, state);
        case RangeDate.monthy:
          return rangeDateMonthly(context, state);
        case RangeDate.yearly:
          return rangeDateYearly(context, state);
      }
    },
  );
}
