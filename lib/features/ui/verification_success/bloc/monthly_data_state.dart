part of 'monthly_data_bloc.dart';

enum VerifOnboardPos { income, budget }

class MonthlyDataState extends Equatable {
  const MonthlyDataState({
    this.state = VerifOnboardPos.income,
    this.monIncome = "",
    this.monBudget = "",
    this.dateRec = 0,
  });

  final VerifOnboardPos state;
  final String monIncome;
  final String monBudget;
  final int dateRec;

  @override
  List<Object> get props => [
        state,
        monIncome,
        monBudget,
        dateRec,
      ];

  MonthlyDataState copyWith({
    VerifOnboardPos? state,
    String? monIncome,
    String? monBudget,
    int? dateRec,
  }) {
    return MonthlyDataState(
      state: state ?? this.state,
      monIncome: monIncome ?? this.monIncome,
      monBudget: monBudget ?? this.monBudget,
      dateRec: dateRec ?? this.dateRec,
    );
  }
}
