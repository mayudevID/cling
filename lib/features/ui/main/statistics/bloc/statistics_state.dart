// ignore_for_file: must_be_immutable

part of 'statistics_bloc.dart';

class StatisticsState extends Equatable {
  int typeCategories;
  double expenseTotal;
  double incomeTotal;

  StatisticsState({
    this.typeCategories = 0,
    this.expenseTotal = 0,
    this.incomeTotal = 0,
  });

  @override
  List<Object> get props => [
        typeCategories,
        expenseTotal,
        incomeTotal,
      ];

  StatisticsState copyWith({
    int? typeCategories,
    double? incomeTotal,
    double? expenseTotal,
  }) {
    return StatisticsState(
      typeCategories: typeCategories ?? this.typeCategories,
      incomeTotal: incomeTotal ?? this.incomeTotal,
      expenseTotal: expenseTotal ?? this.expenseTotal,
    );
  }
}
