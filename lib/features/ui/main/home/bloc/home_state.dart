// ignore_for_file: must_be_immutable
part of 'home_bloc.dart';

class HomeState extends Equatable {
  List<ExpenseModel> listTodayExpenses;
  List<GoalModel> listGoals;
  double amountIncomeThisMonth;
  double amountExpenseThisMonth;

  HomeState({
    List<ExpenseModel>? listTodayExpenses,
    List<GoalModel>? listGoals,
    this.amountIncomeThisMonth = 0,
    this.amountExpenseThisMonth = 0,
  })  : listTodayExpenses = listTodayExpenses ?? List.empty(),
        listGoals = listGoals ?? List.empty();

  @override
  List<Object?> get props => [
        listTodayExpenses,
        listGoals,
        amountIncomeThisMonth,
        amountExpenseThisMonth,
      ];

  HomeState copyWith({
    List<ExpenseModel>? listTodayExpenses,
    List<GoalModel>? listGoals,
    double? amountIncomeThisMonth,
    double? amountExpenseThisMonth,
  }) {
    return HomeState(
      listTodayExpenses: listTodayExpenses ?? this.listTodayExpenses,
      listGoals: listGoals ?? this.listGoals,
      amountIncomeThisMonth:
          amountIncomeThisMonth ?? this.amountIncomeThisMonth,
      amountExpenseThisMonth:
          amountExpenseThisMonth ?? this.amountExpenseThisMonth,
    );
  }
}
