// ignore_for_file: must_be_immutable

part of 'monthly_budget_bloc.dart';

enum VerifOnboardPos { income, spent }

class MonthlyBudgetState extends Equatable {
  MonthlyBudgetState({
    this.state = VerifOnboardPos.income,
    this.monBudgetIncome = "",
    this.monBudgetSpent = "",
  });

  VerifOnboardPos state;
  String monBudgetIncome;
  String monBudgetSpent;

  @override
  List<Object> get props => [
        state,
        monBudgetIncome,
        monBudgetSpent,
      ];

  MonthlyBudgetState copyWith({
    VerifOnboardPos? state,
    String? monBudgetIncome,
    String? monBudgetSpent,
  }) {
    return MonthlyBudgetState(
      state: state ?? this.state,
      monBudgetIncome: monBudgetIncome ?? this.monBudgetIncome,
      monBudgetSpent: monBudgetSpent ?? this.monBudgetSpent,
    );
  }
}
