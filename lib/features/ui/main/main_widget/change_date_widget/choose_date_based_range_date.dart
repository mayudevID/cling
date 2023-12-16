import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../statistics/bloc/statistics_bloc.dart';
import '../enum_range_date.dart';
import 'range_date_daily.dart';
import 'range_date_monthly.dart';
import 'range_date_period.dart';
import 'range_date_yearly.dart';

Widget chooseDateBasedRangeDate(BuildContext context) {
  return BlocBuilder<StatisticsBloc, StatisticsState>(
    buildWhen: (p, c) {
      return p.rangeDate.name != c.rangeDate.name;
    },
    builder: (context, state) {
      switch (state.rangeDate) {
        case RangeDate.daily:
          return rangeDateDaily(context);
        case RangeDate.period:
          return rangeDatePeriod(context);
        case RangeDate.monthy:
          return rangeDateMonthly(context);
        case RangeDate.yearly:
          return rangeDateYearly(context);
      }
    },
  );
}
