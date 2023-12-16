part of 'stats_detail_bloc.dart';

sealed class StatsDetailEvent extends Equatable {
  const StatsDetailEvent();

  @override
  List<Object> get props => [];
}

class GetMostIncomeByCategory extends StatsDetailEvent {}

class GetMostExpenseByCategory extends StatsDetailEvent {}

class GetIncomeBreakdownByCategory extends StatsDetailEvent {}

class GetExpenseBreakdownByCategory extends StatsDetailEvent {}

class ChangeRangeDate extends StatsDetailEvent {
  final RangeDate rangeDate;

  const ChangeRangeDate(this.rangeDate);
}

class ChangeDaily extends StatsDetailEvent {
  final int? leftOrRightOrPick;

  const ChangeDaily(this.leftOrRightOrPick);
}

class ChangeMonthly extends StatsDetailEvent {
  final int? leftOrRightOrPick;

  const ChangeMonthly(this.leftOrRightOrPick);
}

class ChangeYearly extends StatsDetailEvent {
  final int? leftOrRightOrPick;

  const ChangeYearly(this.leftOrRightOrPick);
}

class ChangeDateRangePickerView extends StatsDetailEvent {
  final DateRangePickerView dateRangePickerView;

  const ChangeDateRangePickerView(this.dateRangePickerView);
}

class ChangeDateForPeriod extends StatsDetailEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  const ChangeDateForPeriod(
    this.startDate,
    this.endDate,
  );
}
