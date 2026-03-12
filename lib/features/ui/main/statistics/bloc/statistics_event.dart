part of 'statistics_bloc.dart';

abstract class StatisticsEvent extends Equatable {
  const StatisticsEvent();

  @override
  List<Object> get props => [];
}

class TypeCategoriesEvent extends StatisticsEvent {
  const TypeCategoriesEvent({required this.type});

  final int type;
}

class GetIncomeExpenseTotalAllMonth extends StatisticsEvent {}

class GetIncomeBreakdown extends StatisticsEvent {}

class GetExpenseBreakdownAndPieData extends StatisticsEvent {}

class GetMost extends StatisticsEvent {}

class GetYearlyIncome extends StatisticsEvent {}

class GetExpenseDateRange extends StatisticsEvent {}

class ChangeAllStatsChoose extends StatisticsEvent {

  const ChangeAllStatsChoose(this.allStatsChoose);
  final AllStatsChoose allStatsChoose;
}

class ChangeRangeDate extends StatisticsEvent {

  const ChangeRangeDate(this.rangeDate);
  final RangeDate rangeDate;
}

class ChangeDaily extends StatisticsEvent {

  const ChangeDaily(this.leftOrRightOrPick);
  final int? leftOrRightOrPick;
}

class ChangeMonthly extends StatisticsEvent {

  const ChangeMonthly(this.leftOrRightOrPick);
  final int? leftOrRightOrPick;
}

class ChangeYearly extends StatisticsEvent {

  const ChangeYearly(this.leftOrRightOrPick);
  final int? leftOrRightOrPick;
}

class ChangeDateRangePickerView extends StatisticsEvent {

  const ChangeDateRangePickerView(this.dateRangePickerView);
  final DateRangePickerView dateRangePickerView;
}

class ChangeDateForPeriod extends StatisticsEvent {

  const ChangeDateForPeriod(
    this.startDate,
    this.endDate,
  );
  final DateTime? startDate;
  final DateTime? endDate;
}

class FreeResourcesStats extends StatisticsEvent {}
