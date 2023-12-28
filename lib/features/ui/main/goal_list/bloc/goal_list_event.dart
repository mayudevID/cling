part of 'goal_list_bloc.dart';

sealed class GoalListEvent extends Equatable {
  const GoalListEvent();

  @override
  List<Object> get props => [];
}

class GetGoalsList extends GoalListEvent {}

class DeleteGoalFromGL extends GoalListEvent {
  final int id;

  const DeleteGoalFromGL(this.id);
}

class UpdateGoalFromGL extends GoalListEvent {
  final GoalModel newGoalModel;

  const UpdateGoalFromGL(this.newGoalModel);
}
