// ignore_for_file: must_be_immutable

part of 'verification_onboard_bloc.dart';

enum VerifOnboardPos { income, spent }

class VerificationOnboardState extends Equatable {
  VerificationOnboardState({
    required this.state,
    required this.monBudgetIncome,
    required this.monBudgetSpent,
  });
  VerifOnboardPos state;
  double monBudgetIncome;
  double monBudgetSpent;

  @override
  List<Object> get props => [state, monBudgetIncome, monBudgetSpent];

  VerificationOnboardState copyWith({
    VerifOnboardPos? state,
    double? monBudgetIncome,
    double? monBudgetSpent,
  }) {
    return VerificationOnboardState(
      state: state ?? this.state,
      monBudgetIncome: monBudgetIncome ?? this.monBudgetIncome,
      monBudgetSpent: monBudgetSpent ?? this.monBudgetSpent,
    );
  }
}
