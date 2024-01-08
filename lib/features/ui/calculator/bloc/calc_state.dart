// ignore_for_file: must_be_immutable

part of 'calc_bloc.dart';

class CalcState extends Equatable {
  List<String> listInput;
  String expressionFromCount;

  CalcState({
    List<String>? listInput,
    this.expressionFromCount = "",
  }) : listInput = listInput ?? [""];

  @override
  List<Object> get props => [listInput, expressionFromCount];

  CalcState copyWith({
    List<String>? listInput,
    String? expressionFromCount,
  }) {
    return CalcState(
      listInput: listInput ?? this.listInput,
      expressionFromCount: expressionFromCount ?? this.expressionFromCount,
    );
  }
}
