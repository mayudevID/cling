// ignore_for_file: must_be_immutable

part of 'calc_bloc.dart';

class CalcState extends Equatable {

  CalcState({
    List<String>? listInput,
    this.expressionFromCount = "",
  }) : listInput = listInput ?? [""];
  List<String> listInput;
  String expressionFromCount;

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
