// ignore_for_file: use_build_context_synchronously

import 'package:cling/features/model/expense_model.dart';
import 'package:cling/features/model/goal_model.dart';
import 'package:cling/features/repository/database_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../main_page.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required DatabaseRepository dbRepo,
  })  : _dbRepo = dbRepo,
        super(HomeState()) {
    on<GetIncomeExpenseAmountTotalCurrMonth>(_getTotalIncomeExpenseCurrMonth);
    on<GetGoals>(_getGoals);
    on<GetTodayExpenses>(_getTodayExpenses);
  }

  final DatabaseRepository _dbRepo;
  var mainContext = MainPage.navKeyMain.currentContext!;

  void _getTotalIncomeExpenseCurrMonth(_, emit) async {
    final amount = await _dbRepo.getTotalIncomeExpenseCurrMonth();
    emit(state.copyWith(
      amountIncomeThisMonth: amount['income'],
      amountExpenseThisMonth: amount['expense'],
    ));
  }

  // void _getTotalExpenseCurrMonth(_, emit) async {
  //   final amount = await _dbRepo.getTotalExpense();
  //   emit(state.copyWith(amountExpenseThisMonth: amount.toDouble()));
  // }

  void _getGoals(event, emit) async {
    final listData = await _dbRepo.getGoals();
    emit(state.copyWith(listGoals: listData));
  }

  void _getTodayExpenses(_, emit) async {
    final listData = await _dbRepo.getTodayExpenses();
    emit(state.copyWith(listTodayExpenses: listData));
  }
}
