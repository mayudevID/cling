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

class GetPieDataExpense extends StatisticsEvent {}

class GetMostExpense extends StatisticsEvent {}

class GetYearlyIncome extends StatisticsEvent {}

class GetExpenseDateRange extends StatisticsEvent {}

class ChangeRangeDate extends StatisticsEvent {
  final RangeDate rangeDate;

  const ChangeRangeDate(this.rangeDate);
}

class ChangeDaily extends StatisticsEvent {
  final int? leftOrRightOrPick;

  const ChangeDaily(this.leftOrRightOrPick);
}

class ChangeMonthly extends StatisticsEvent {
  final int? leftOrRightOrPick;

  const ChangeMonthly(this.leftOrRightOrPick);
}

class ChangeYearly extends StatisticsEvent {
  final int? leftOrRightOrPick;

  const ChangeYearly(this.leftOrRightOrPick);
}

class ChangeDateRangePickerView extends StatisticsEvent {
  final DateRangePickerView dateRangePickerView;

  const ChangeDateRangePickerView(this.dateRangePickerView);
}

class ChangeDateForPeriod extends StatisticsEvent {
  final DateTime? dateLeft;
  final DateTime? dateRight;

  const ChangeDateForPeriod(
    this.dateLeft,
    this.dateRight,
  );
}

class FreeResourcesStats extends StatisticsEvent {}
