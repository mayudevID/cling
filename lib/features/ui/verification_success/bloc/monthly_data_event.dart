part of 'monthly_data_bloc.dart';

sealed class MonthlyDataEvent extends Equatable {
  const MonthlyDataEvent();

  @override
  List<Object> get props => [];
}

class SetIncome extends MonthlyDataEvent {
  const SetIncome(this.input);
  final String input;
  @override
  List<Object> get props => [input];
}

class SetBudget extends MonthlyDataEvent {
  const SetBudget(this.input);
  final String input;
  @override
  List<Object> get props => [input];
}

class RecDay extends MonthlyDataEvent {
  const RecDay(this.dateRec);
  final int dateRec;
  @override
  List<Object> get props => [dateRec];
}

class SetState extends MonthlyDataEvent {
  const SetState(this.state, {this.currentInput});
  final VerifOnboardPos state;
  final String? currentInput;
  @override
  List<Object> get props => [state, if (currentInput != null) currentInput!];
}

class SetFinish extends MonthlyDataEvent {}
