part of 'calc_bloc.dart';

sealed class CalcEvent extends Equatable {
  const CalcEvent();

  @override
  List<Object> get props => [];
}

class InitAmount extends CalcEvent {
  final double? amount;
  const InitAmount(this.amount);
}

class AddExpression extends CalcEvent {
  final String value;
  const AddExpression(this.value);
}
