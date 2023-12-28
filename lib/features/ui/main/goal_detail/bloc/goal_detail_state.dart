part of 'goal_detail_bloc.dart';

// ignore: must_be_immutable
class GoalDetailState extends Equatable {
  GoalModel goalModel;
  List<GoalSavingModel> dataSavingsList;
  DateTime selectedDate;
  String amount;
  String tempLogoGoal;

  GoalDetailState({
    GoalModel? goalModel,
    List<GoalSavingModel>? dataSavingsList,
    DateTime? selectedDate,
    this.tempLogoGoal = "",
    this.amount = "0",
  })  : goalModel = goalModel ?? GoalModel.empty(),
        dataSavingsList = dataSavingsList ?? List.empty(),
        selectedDate = selectedDate ?? DateTime.now();

  @override
  List<Object> get props => [
        goalModel,
        dataSavingsList,
        selectedDate,
        amount,
        tempLogoGoal,
      ];

  GoalDetailState copyWith({
    GoalModel? goalModel,
    List<GoalSavingModel>? dataSavingsList,
    DateTime? selectedDate,
    String? amount,
    String? tempLogoGoal,
  }) {
    return GoalDetailState(
      goalModel: goalModel ?? this.goalModel,
      dataSavingsList: dataSavingsList ?? this.dataSavingsList,
      selectedDate: selectedDate ?? this.selectedDate,
      amount: amount ?? this.amount,
      tempLogoGoal: tempLogoGoal ?? this.tempLogoGoal,
    );
  }
}
