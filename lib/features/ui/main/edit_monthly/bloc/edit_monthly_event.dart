part of 'edit_monthly_bloc.dart';

sealed class EditMonthlyEvent extends Equatable {
  const EditMonthlyEvent();

  @override
  List<Object> get props => [];
}

class SetAmountInput extends EditMonthlyEvent {
  final double newValue;
  const SetAmountInput(this.newValue);
}

class ChangeTempRecDay extends EditMonthlyEvent {
  final int value;

  const ChangeTempRecDay(this.value);
}

class SaveNewMonthly extends EditMonthlyEvent {}

class InitialValue extends EditMonthlyEvent {}
