// ignore_for_file: must_be_immutable

part of 'monthly_data_bloc.dart';

enum VerifOnboardPos { income, budget }

class MonthlyDataState extends Equatable {
  MonthlyDataState({
    this.state = VerifOnboardPos.income,
    this.monIncome = "",
    this.monBudget = "",
  });

  VerifOnboardPos state;
  String monIncome;
  String monBudget;

  @override
  List<Object> get props => [
        state,
        monIncome,
        monBudget,
      ];

  MonthlyDataState copyWith({
    VerifOnboardPos? state,
    String? monIncome,
    String? monBudget,
  }) {
    return MonthlyDataState(
      state: state ?? this.state,
      monIncome: monIncome ?? this.monIncome,
      monBudget: monBudget ?? this.monBudget,
    );
  }
}
