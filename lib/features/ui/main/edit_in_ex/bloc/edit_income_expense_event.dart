part of 'edit_income_expense_bloc.dart';

sealed class EditIncomeExpenseEvent extends Equatable {
  const EditIncomeExpenseEvent();

  @override
  List<Object> get props => [];
}

class GetIncomeSource extends EditIncomeExpenseEvent {}

class GetExpenseCategories extends EditIncomeExpenseEvent {}

class SetDate extends EditIncomeExpenseEvent {
  const SetDate(this.date);

  final DateTime date;
}

class SetTime extends EditIncomeExpenseEvent {
  const SetTime(this.time);

  final DateTime time;
}

class SetCategories extends EditIncomeExpenseEvent {
  const SetCategories(this.categories);

  final MapEntry<int, String> categories;
}

class SetDescOrItem extends EditIncomeExpenseEvent {
  const SetDescOrItem(this.descOrItem);

  final String descOrItem;
}

class SetAmountInput extends EditIncomeExpenseEvent {
  const SetAmountInput(this.amountInput);

  final String amountInput;
}

class SaveData extends EditIncomeExpenseEvent {
  const SaveData(this.flowType);

  final FlowType flowType;
}
