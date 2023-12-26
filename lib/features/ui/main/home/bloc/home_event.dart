part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class GetIncomeExpenseAmountTotalCurrMonth extends HomeEvent {}

class GetTodayExpenses extends HomeEvent {}

class GetGoalsHome extends HomeEvent {}

class GetNotificationCount extends HomeEvent {}

class GetGoalsCount extends HomeEvent {}

class FreeResourcesHome extends HomeEvent {}
