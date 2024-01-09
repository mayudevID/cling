// ignore_for_file: must_be_immutable

part of 'monthly_data_bloc.dart';

sealed class MonthlyDataEvent extends Equatable {
  const MonthlyDataEvent();

  @override
  List<Object> get props => [];
}

class SetIncome extends MonthlyDataEvent {}

class SetBudget extends MonthlyDataEvent {}

class RecDay extends MonthlyDataEvent {
  RecDay(this.dateRec);

  int dateRec;
}

class SetState extends MonthlyDataEvent {
  SetState(this.state);

  VerifOnboardPos state;
}

class SetFinish extends MonthlyDataEvent {}
