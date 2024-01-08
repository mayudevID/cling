part of 'calc_bloc.dart';

sealed class CalcEvent extends Equatable {
  const CalcEvent();

  @override
  List<Object> get props => [];
}

class AddExpression extends CalcEvent {
  final String value;
  const AddExpression(this.value);
}
