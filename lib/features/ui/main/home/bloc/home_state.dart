// ignore_for_file: must_be_immutable
part of 'home_bloc.dart';

class HomeState extends Equatable {

  HomeState({
    List<ExpenseModel>? listTodayExpenses,
    List<GoalModel>? listGoals,
    this.totalGoals = 0,
    this.totalNotif = 0,
    this.amountIncomeThisMonth = 0,
    this.amountExpenseThisMonth = 0,
    this.totalBalance = 0,
  })  : listTodayExpenses = listTodayExpenses ?? List.empty(),
        listGoals = listGoals ?? List.empty();
  List<ExpenseModel> listTodayExpenses;
  List<GoalModel> listGoals;
  int totalGoals;
  int totalNotif;
  double amountIncomeThisMonth;
  double amountExpenseThisMonth;
  double totalBalance;

  @override
  List<Object?> get props => [
        listTodayExpenses,
        listGoals,
        amountIncomeThisMonth,
        amountExpenseThisMonth,
        totalBalance,
        totalGoals,
        totalNotif,
      ];

  HomeState copyWith({
    List<ExpenseModel>? listTodayExpenses,
    List<GoalModel>? listGoals,
    double? amountIncomeThisMonth,
    double? amountExpenseThisMonth,
    double? totalBalance,
    int? totalGoals,
    int? totalNotif,
  }) {
    return HomeState(
      totalGoals: totalGoals ?? this.totalGoals,
      listTodayExpenses: listTodayExpenses ?? this.listTodayExpenses,
      listGoals: listGoals ?? this.listGoals,
      totalNotif: totalNotif ?? this.totalNotif,
      totalBalance: totalBalance ?? this.totalBalance,
      amountIncomeThisMonth:
          amountIncomeThisMonth ?? this.amountIncomeThisMonth,
      amountExpenseThisMonth:
          amountExpenseThisMonth ?? this.amountExpenseThisMonth,
    );
  }
}
