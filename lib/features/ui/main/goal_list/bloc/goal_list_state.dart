// ignore_for_file: must_be_immutable

part of 'goal_list_bloc.dart';

class GoalListState extends Equatable {

  GoalListState({
    List<GoalModel>? listGoalModel,
    RefreshController? refreshController,
  })  : listGoalModel = listGoalModel ?? List.empty(),
        refreshController = refreshController ??
            RefreshController(initialLoadStatus: LoadStatus.loading);
  List<GoalModel> listGoalModel;
  RefreshController refreshController;

  @override
  List<Object> get props => [listGoalModel, refreshController];

  GoalListState copyWith({
    List<GoalModel>? listGoalModel,
    RefreshController? refreshController,
  }) {
    return GoalListState(
      listGoalModel: listGoalModel ?? this.listGoalModel,
      refreshController: refreshController ?? this.refreshController,
    );
  }
}
