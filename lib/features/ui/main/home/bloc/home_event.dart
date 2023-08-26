part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class GetIncomeSource extends HomeEvent {}

class GetExpenseCategories extends HomeEvent {}

class ClearDataForm extends HomeEvent {}

class GetTotalIncome extends HomeEvent {}

class GetTotalExpense extends HomeEvent {}

class GetTodayExpenses extends HomeEvent {}

class GetGoals extends HomeEvent {}

class SetDate extends HomeEvent {
  const SetDate(this.date);

  final DateTime date;
}

class SetCategories extends HomeEvent {
  const SetCategories(this.categories);

  final MapEntry<int, String> categories;
}

class SetDescOrItem extends HomeEvent {
  const SetDescOrItem(this.descOrItem);

  final String descOrItem;
}

class SetAmountInput extends HomeEvent {
  const SetAmountInput(this.amountInput);

  final String amountInput;
}

class SaveData extends HomeEvent {
  const SaveData(this.flowType);

  final FlowType flowType;
}

class SetNameGoal extends HomeEvent {
  const SetNameGoal(this.nameGoal);

  final String nameGoal;
}
