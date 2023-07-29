part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class GetIncomeSource extends HomeEvent {}

class GetExpenseCategories extends HomeEvent {}

class ClearListDropdown extends HomeEvent {}
