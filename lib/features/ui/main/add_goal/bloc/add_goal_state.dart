// ignore_for_file: must_be_immutable

part of 'add_goal_bloc.dart';

class AddGoalState extends Equatable {
  AddGoalState({
    this.nameGoal = "",
    this.logoGoal = "",
    this.amountInput = 0,
  });
  String nameGoal;
  String logoGoal;
  double amountInput;

  @override
  List<Object> get props => [
        nameGoal,
        logoGoal,
        amountInput,
      ];

  AddGoalState copyWith({
    String? nameGoal,
    String? logoGoal,
    double? amountInput,
  }) {
    return AddGoalState(
      nameGoal: nameGoal ?? this.nameGoal,
      logoGoal: logoGoal ?? this.logoGoal,
      amountInput: amountInput ?? this.amountInput,
    );
  }
}
