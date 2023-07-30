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

  final Map<int, String> categories;
}
