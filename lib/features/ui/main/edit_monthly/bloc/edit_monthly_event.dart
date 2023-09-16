part of 'edit_monthly_bloc.dart';

sealed class EditMonthlyEvent extends Equatable {
  const EditMonthlyEvent();

  @override
  List<Object> get props => [];
}

class SetAmountInput extends EditMonthlyEvent {
  final String newValue;
  const SetAmountInput(this.newValue);
}

class SaveNewMonthly extends EditMonthlyEvent {}

class InitialValue extends EditMonthlyEvent {}
