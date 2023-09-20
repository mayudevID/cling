part of 'goal_detail_bloc.dart';

// ignore: must_be_immutable
class GoalDetailState extends Equatable {
  GoalModel goalModel;
  GoalDetailState({
    GoalModel? goalModel,
  }) : goalModel = goalModel ?? GoalModel.empty();

  @override
  List<Object> get props => [goalModel];
}
