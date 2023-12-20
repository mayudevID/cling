// ignore_for_file: must_be_immutable
part of 'home_bloc.dart';

class HomeState extends Equatable {
  List<ExpenseModel> listTodayExpenses;
  List<GoalModel> listGoals;
  double amountIncomeThisMonth;
  double amountExpenseThisMonth;
  double totalBalance;

  HomeState({
    List<ExpenseModel>? listTodayExpenses,
    List<GoalModel>? listGoals,
    this.amountIncomeThisMonth = 0,
    this.amountExpenseThisMonth = 0,
    this.totalBalance = 0,
  })  : listTodayExpenses = listTodayExpenses ?? List.empty(),
        listGoals = listGoals ?? List.empty();

  @override
  List<Object?> get props => [
        listTodayExpenses,
        listGoals,
        amountIncomeThisMonth,
        amountExpenseThisMonth,
        totalBalance,
      ];

  HomeState copyWith({
    List<ExpenseModel>? listTodayExpenses,
    List<GoalModel>? listGoals,
    double? amountIncomeThisMonth,
    double? amountExpenseThisMonth,
    double? totalBalance,
  }) {
    return HomeState(
      listTodayExpenses: listTodayExpenses ?? this.listTodayExpenses,
      listGoals: listGoals ?? this.listGoals,
      totalBalance: totalBalance ?? this.totalBalance,
      amountIncomeThisMonth:
          amountIncomeThisMonth ?? this.amountIncomeThisMonth,
      amountExpenseThisMonth:
          amountExpenseThisMonth ?? this.amountExpenseThisMonth,
    );
  }
}
