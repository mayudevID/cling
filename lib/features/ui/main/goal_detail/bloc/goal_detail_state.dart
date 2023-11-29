part of 'goal_detail_bloc.dart';

// ignore: must_be_immutable
class GoalDetailState extends Equatable {
  GoalModel goalModel;
  List<Map<String, Object?>> dataSavingsList;
  DateTime selectedDate;
  String amount;

  GoalDetailState({
    GoalModel? goalModel,
    List<Map<String, Object?>>? dataSavingsList,
    DateTime? selectedDate,
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
      ];

  GoalDetailState copyWith({
    GoalModel? goalModel,
    List<Map<String, Object?>>? dataSavingsList,
    DateTime? selectedDate,
    String? amount,
  }) {
    return GoalDetailState(
      goalModel: goalModel ?? this.goalModel,
      dataSavingsList: dataSavingsList ?? this.dataSavingsList,
      selectedDate: selectedDate ?? this.selectedDate,
      amount: amount ?? this.amount,
    );
  }
}
