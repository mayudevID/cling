part of 'edit_monthly_bloc.dart';

sealed class EditMonthlyEvent extends Equatable {
  const EditMonthlyEvent();

  @override
  List<Object> get props => [];
}

class SetAmountInput extends EditMonthlyEvent {
  const SetAmountInput(this.newValue);
  final double newValue;
}

class ChangeTempRecDay extends EditMonthlyEvent {

  const ChangeTempRecDay(this.value);
  final int value;
}

class SaveNewMonthly extends EditMonthlyEvent {}

class InitialValue extends EditMonthlyEvent {}
