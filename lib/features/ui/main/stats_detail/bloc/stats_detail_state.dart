// ignore_for_file: must_be_immutable

part of 'stats_detail_bloc.dart';

class StatsDetailState extends Equatable {
  List<ExpenseModel> listExpenseModel;
  List<IncomeModel> listIncomeModel;

  StatsDetailState({
    List<ExpenseModel>? listExpenseModel,
    List<IncomeModel>? listIncomeModel,
  })  : listExpenseModel = listExpenseModel ?? List.empty(),
        listIncomeModel = listIncomeModel ?? List.empty();

  @override
  List<Object> get props => [listExpenseModel, listIncomeModel];

  StatsDetailState copyWith({
    List<ExpenseModel>? listExpenseModel,
    List<IncomeModel>? listIncomeModel,
  }) {
    return StatsDetailState(
      listExpenseModel: listExpenseModel ?? this.listExpenseModel,
      listIncomeModel: listIncomeModel ?? this.listIncomeModel,
    );
  }
}
