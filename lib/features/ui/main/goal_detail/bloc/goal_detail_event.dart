part of 'goal_detail_bloc.dart';

sealed class GoalDetailEvent extends Equatable {
  const GoalDetailEvent();

  @override
  List<Object> get props => [];
}

class InitGoal extends GoalDetailEvent {

  const InitGoal(this.goalModelId);
  final int goalModelId;
}

class ChangeIcon extends GoalDetailEvent {

  const ChangeIcon(this.icon);
  final String icon;
}

class InitTempEdit extends GoalDetailEvent {}

class SaveEdit extends GoalDetailEvent {}

class SetDateGoalInput extends GoalDetailEvent {

  const SetDateGoalInput(this.time);
  final DateTime time;
}

class SetTempAmountInput extends GoalDetailEvent {

  const SetTempAmountInput(this.tempAmount);
  final double tempAmount;
}

class SetAmountInput extends GoalDetailEvent {

  const SetAmountInput(this.amount);
  final double amount;
}

class AddSaving extends GoalDetailEvent {}

class DeleteSaving extends GoalDetailEvent {

  const DeleteSaving(this.goalSaving);
  final GoalSavingModel goalSaving;
}

class DeleteGoal extends GoalDetailEvent {}
