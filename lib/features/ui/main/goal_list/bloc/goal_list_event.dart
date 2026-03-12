part of 'goal_list_bloc.dart';

sealed class GoalListEvent extends Equatable {
  const GoalListEvent();

  @override
  List<Object> get props => [];
}

class GetGoalsList extends GoalListEvent {}

class DeleteGoalFromGL extends GoalListEvent {

  const DeleteGoalFromGL(this.id);
  final int id;
}

class UpdateGoalFromGL extends GoalListEvent {

  const UpdateGoalFromGL(this.newGoalModel);
  final GoalModel newGoalModel;
}
