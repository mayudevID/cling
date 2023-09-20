part of 'add_goal_bloc.dart';

sealed class AddGoalEvent extends Equatable {
  const AddGoalEvent();

  @override
  List<Object> get props => [];
}

class SetNameGoal extends AddGoalEvent {
  const SetNameGoal(this.nameGoal);

  final String nameGoal;
}

class SetLogoGoal extends AddGoalEvent {
  const SetLogoGoal(this.logoGoal);

  final String logoGoal;
}

class SetAmountInput extends AddGoalEvent {
  const SetAmountInput(this.amountInput);

  final String amountInput;
}

class SaveDataGoal extends AddGoalEvent {}
