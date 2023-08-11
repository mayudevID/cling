// ignore_for_file: must_be_immutable

part of 'monthly_budget_bloc.dart';

sealed class MonthlyBudgetEvent extends Equatable {
  const MonthlyBudgetEvent();

  @override
  List<Object> get props => [];
}

class SetIncome extends MonthlyBudgetEvent {}

class SetSpent extends MonthlyBudgetEvent {}

class SetState extends MonthlyBudgetEvent {
  SetState(this.state);

  VerifOnboardPos state;
}
