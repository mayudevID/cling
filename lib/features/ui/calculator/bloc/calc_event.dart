part of 'calc_bloc.dart';

sealed class CalcEvent extends Equatable {
  const CalcEvent();

  @override
  List<Object> get props => [];
}

class InitAmount extends CalcEvent {
  const InitAmount(this.amount);
  final double? amount;
}

class AddExpression extends CalcEvent {
  const AddExpression(this.value);
  final String value;
}
