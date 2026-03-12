part of 'goal_detail_bloc.dart';

// ignore: must_be_immutable
class GoalDetailState extends Equatable {

  GoalDetailState({
    GoalModel? goalModel,
    List<GoalSavingModel>? dataSavingsList,
    DateTime? selectedDate,
    this.tempLogoGoal = "",
    this.tempAmount = 0,
    this.amount = 0,
  })  : goalModel = goalModel ?? GoalModel.empty(),
        dataSavingsList = dataSavingsList ?? List.empty(),
        selectedDate = selectedDate ?? DateTime.now();
  GoalModel goalModel;
  List<GoalSavingModel> dataSavingsList;
  DateTime selectedDate;
  double amount;
  double tempAmount;
  String tempLogoGoal;

  @override
  List<Object> get props => [
        goalModel,
        dataSavingsList,
        selectedDate,
        amount,
        tempLogoGoal,
        tempAmount,
      ];

  GoalDetailState copyWith({
    GoalModel? goalModel,
    List<GoalSavingModel>? dataSavingsList,
    DateTime? selectedDate,
    double? amount,
    String? tempLogoGoal,
    double? tempAmount,
  }) {
    return GoalDetailState(
      goalModel: goalModel ?? this.goalModel,
      dataSavingsList: dataSavingsList ?? this.dataSavingsList,
      selectedDate: selectedDate ?? this.selectedDate,
      amount: amount ?? this.amount,
      tempAmount: tempAmount ?? this.tempAmount,
      tempLogoGoal: tempLogoGoal ?? this.tempLogoGoal,
    );
  }
}
