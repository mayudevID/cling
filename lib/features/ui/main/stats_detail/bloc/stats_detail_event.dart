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

  const ChangeRangeDate(this.rangeDate);
  final RangeDate rangeDate;
}

class ChangeDaily extends StatsDetailEvent {

  const ChangeDaily(this.leftOrRightOrPick);
  final int? leftOrRightOrPick;
}

class ChangeMonthly extends StatsDetailEvent {

  const ChangeMonthly(this.leftOrRightOrPick);
  final int? leftOrRightOrPick;
}

class ChangeYearly extends StatsDetailEvent {

  const ChangeYearly(this.leftOrRightOrPick);
  final int? leftOrRightOrPick;
}

class ChangeDateRangePickerView extends StatsDetailEvent {

  const ChangeDateRangePickerView(this.dateRangePickerView);
  final DateRangePickerView dateRangePickerView;
}

class ChangeDateForPeriod extends StatsDetailEvent {

  const ChangeDateForPeriod(
    this.startDate,
    this.endDate,
  );
  final DateTime? startDate;
  final DateTime? endDate;
}

class UpdateFromEdit extends StatsDetailEvent {

  const UpdateFromEdit(this.transactionModel);
  final TransactionModel transactionModel;
}

class DeleteFromEdit extends StatsDetailEvent {

  const DeleteFromEdit(this.id);
  final int id;
}
