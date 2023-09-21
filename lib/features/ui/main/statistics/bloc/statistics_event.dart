part of 'statistics_bloc.dart';

abstract class StatisticsEvent extends Equatable {
  const StatisticsEvent();

  @override
  List<Object> get props => [];
}

class TypeCategoriesEvent extends StatisticsEvent {
  const TypeCategoriesEvent({required this.type});

  final int type;
}

class GetIncomeExpenseTotalCurrMonth extends StatisticsEvent {}

class GetIncomeExpenseTotalSixMonth extends StatisticsEvent {}

class GetMostExpense extends StatisticsEvent {}

class GetYearlyIncome extends StatisticsEvent {}
