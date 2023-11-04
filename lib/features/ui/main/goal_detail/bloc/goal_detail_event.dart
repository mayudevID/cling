part of 'goal_detail_bloc.dart';

sealed class GoalDetailEvent extends Equatable {
  const GoalDetailEvent();

  @override
  List<Object> get props => [];
}

class InitGoal extends GoalDetailEvent {
  final GoalModel goalModel;

  const InitGoal(this.goalModel);
}

class ChangeIcon extends GoalDetailEvent {}
