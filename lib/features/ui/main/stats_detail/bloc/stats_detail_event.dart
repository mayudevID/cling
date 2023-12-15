part of 'stats_detail_bloc.dart';

sealed class StatsDetailEvent extends Equatable {
  const StatsDetailEvent();

  @override
  List<Object> get props => [];
}

class GetMostIncomeByCategories extends StatsDetailEvent {
  final String source;

  const GetMostIncomeByCategories(this.source);
}

class GetMostExpenseByCategories extends StatsDetailEvent {
  final String source;

  const GetMostExpenseByCategories(this.source);
}
