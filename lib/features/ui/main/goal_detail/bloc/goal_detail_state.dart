part of 'goal_detail_bloc.dart';

// ignore: must_be_immutable
class GoalDetailState extends Equatable {
  GoalModel goalModel;
  List<Map<String, Object?>> dataSavingsList;
  GoalDetailState({
    GoalModel? goalModel,
    List<Map<String, Object?>>? dataSavingsList,
  })  : goalModel = goalModel ?? GoalModel.empty(),
        dataSavingsList = dataSavingsList ?? List.empty();

  @override
  List<Object> get props => [
        goalModel,
        dataSavingsList,
      ];

  GoalDetailState copyWith({
    GoalModel? goalModel,
    List<Map<String, Object?>>? dataSavingsList,
  }) {
    return GoalDetailState(
      goalModel: goalModel ?? this.goalModel,
      dataSavingsList: dataSavingsList ?? this.dataSavingsList,
    );
  }
}
