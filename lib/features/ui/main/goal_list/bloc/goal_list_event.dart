part of 'goal_list_bloc.dart';

sealed class GoalListEvent extends Equatable {
  const GoalListEvent();

  @override
  List<Object> get props => [];
}

class GetGoalsList extends GoalListEvent {}
