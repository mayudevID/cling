import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home/bloc/home_bloc.dart';
import '../transaction/bloc/transaction_bloc.dart';
import '../statistics/bloc/statistics_bloc.dart';
import '../stats_detail/bloc/stats_detail_bloc.dart';
import '../stats_detail/page/stats_detail_per_categories_page.dart';

/// Invalidate *all* finance projections after a committed transaction write.
/// Queries retain their currently selected date/category filters.
void refreshFinancialViews(BuildContext context) {
  context.read<HomeBloc>()
    ..add(GetIncomeExpenseAmountTotalCurrMonth())
    ..add(GetTodayExpenses())
    ..add(GetGoalsHomeWithCount())
    ..add(GetNotificationCount());
  context.read<TransactionBloc>().add(GetData());
  context.read<StatisticsBloc>()
    ..add(GetIncomeExpenseTotalAllMonth())
    ..add(GetMost())
    ..add(GetYearlyIncome())
    ..add(GetIncomeBreakdown())
    ..add(GetExpenseBreakdownAndPieData());

  final detail = StatsDetailPerCategoriesPage.navKey.currentContext;
  if (detail != null && detail.mounted) {
    detail.read<StatsDetailBloc>().add(RefreshCurrentCategory());
  }
}
