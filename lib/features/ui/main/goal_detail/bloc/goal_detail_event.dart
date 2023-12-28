part of 'goal_detail_bloc.dart';

sealed class GoalDetailEvent extends Equatable {
  const GoalDetailEvent();

  @override
  List<Object> get props => [];
}

class InitGoal extends GoalDetailEvent {
  final int goalModelId;

  const InitGoal(this.goalModelId);
}

class ChangeIcon extends GoalDetailEvent {
  final String icon;

  const ChangeIcon(this.icon);
}

class InitNameEdit extends GoalDetailEvent {}

class InitAmountEdit extends GoalDetailEvent {}

class SaveEdit extends GoalDetailEvent {}

class SetDateGoalInput extends GoalDetailEvent {
  final DateTime time;

  const SetDateGoalInput(this.time);
}

class SetAmountInput extends GoalDetailEvent {
  final String amount;

  const SetAmountInput(this.amount);
}

class AddSaving extends GoalDetailEvent {}

class DeleteGoal extends GoalDetailEvent {}
