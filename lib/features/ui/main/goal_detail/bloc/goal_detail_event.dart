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

class InitTempNameEdit extends GoalDetailEvent {}

class InitTempAmountEdit extends GoalDetailEvent {}

class SaveEdit extends GoalDetailEvent {}

class SetDateGoalInput extends GoalDetailEvent {
  final DateTime time;

  const SetDateGoalInput(this.time);
}

class SetTempAmountInput extends GoalDetailEvent {
  final double tempAmount;

  const SetTempAmountInput(this.tempAmount);
}

class SetAmountInput extends GoalDetailEvent {
  final double amount;

  const SetAmountInput(this.amount);
}

class AddSaving extends GoalDetailEvent {}

class DeleteSaving extends GoalDetailEvent {
  final GoalSavingModel goalSaving;

  const DeleteSaving(this.goalSaving);
}

class DeleteGoal extends GoalDetailEvent {}
