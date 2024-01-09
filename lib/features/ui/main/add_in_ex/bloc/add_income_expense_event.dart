part of 'add_income_expense_bloc.dart';

sealed class AddIncomeExpenseEvent extends Equatable {
  const AddIncomeExpenseEvent();

  @override
  List<Object> get props => [];
}

class GetIncomeSource extends AddIncomeExpenseEvent {}

class GetExpenseCategories extends AddIncomeExpenseEvent {}

class SetDate extends AddIncomeExpenseEvent {
  const SetDate(this.date);

  final DateTime date;
}

class SetTime extends AddIncomeExpenseEvent {
  const SetTime(this.time);

  final DateTime time;
}

class SetCategories extends AddIncomeExpenseEvent {
  const SetCategories(this.categories);

  final MapEntry<int, String> categories;
}

class SetDescOrItem extends AddIncomeExpenseEvent {
  const SetDescOrItem(this.descOrItem);

  final String descOrItem;
}

class SetAmountInput extends AddIncomeExpenseEvent {
  const SetAmountInput(this.amountInput);

  final double amountInput;
}

class SaveData extends AddIncomeExpenseEvent {
  const SaveData(this.flowType);

  final FlowType flowType;
}
