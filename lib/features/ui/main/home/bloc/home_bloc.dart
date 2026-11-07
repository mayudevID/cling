// ignore_for_file: use_build_context_synchronously


import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../main.dart';
import '../../../../model/expense_model.dart';
import '../../../../model/goal_model.dart';
import '../../../../repository/database_repository.dart';
import '../../profile/bloc/profile_bloc.dart';
import '../../../language_currency/lang_export.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required DatabaseRepository dbRepo,
  })  : _dbRepo = dbRepo,
        super(HomeState()) {
    on<GetIncomeExpenseAmountTotalCurrMonth>(_getTotalIncomeExpenseCurrMonth);
    on<GetGoalsHomeWithCount>(_getGoalsHomeWithCount);
    on<GetTodayExpenses>(_getTodayExpenses);
    on<GetNotificationCount>(_getNotificationCount);
    on<FreeResourcesHome>(_freeResources);
  }

  final DatabaseRepository _dbRepo;
  BuildContext get mainContext => MainApp.navKeyGlobal.currentContext!;

  Future<void> _getTotalIncomeExpenseCurrMonth(
    GetIncomeExpenseAmountTotalCurrMonth event,
    Emitter<HomeState> emit,
  ) async {
    final revision = _dbRepo.revision;
    final result = await Future.wait([
      _dbRepo.getTotalIncomeExpenseCurrMonth(),
      _dbRepo.getTotalBalance(),
    ]);
    if (isClosed || revision != _dbRepo.revision) return;
    final amount = result[0] as Map<String, double?>;
    final totalBalance = result[1] as double;

    emit(
      state.copyWith(
        amountIncomeThisMonth: amount['income'] ?? 0.0,
        amountExpenseThisMonth: amount['expense'] ?? 0.0,
        totalBalance: totalBalance.toDouble(),
      ),
    );

    ///* CHECK MONTHLY BUDGET / TYPE 0
    if (revision == _dbRepo.revision) await _monthlyBudgetCheck(revision);

    ///* CHECK CURRENT BALANCE / TYPE 1
    if (revision == _dbRepo.revision) await _currentBalanceCheck(revision);

    ///* CHECK TOTAL BALANCE / TYPE 2
    if (revision == _dbRepo.revision) await _totalBalanceCheck(revision);
  }

  Future<void> _getNotificationCount(
    GetNotificationCount event,
    Emitter<HomeState> emit,
  ) async {
    final revision = _dbRepo.revision;
    final total = await _dbRepo.getNotificationCount();
    if (isClosed || revision != _dbRepo.revision) return;
    emit(state.copyWith(totalNotif: total));
  }

  Future<void> _getGoalsHomeWithCount(
    GetGoalsHomeWithCount event,
    Emitter<HomeState> emit,
  ) async {
    final revision = _dbRepo.revision;
    final result = await Future.wait([
      _dbRepo.getGoalsHome(),
      _dbRepo.getGoalsCount(),
    ]);
    if (isClosed || revision != _dbRepo.revision) return;

    emit(
      state.copyWith(
        listGoals: result[0] as List<GoalModel>,
        totalGoals: result[1] as int,
      ),
    );
  }

  Future<void> _getTodayExpenses(
    GetTodayExpenses event,
    Emitter<HomeState> emit,
  ) async {
    final revision = _dbRepo.revision;
    final listData = await _dbRepo.getTodayExpenses();
    if (isClosed || revision != _dbRepo.revision) return;
    emit(state.copyWith(listTodayExpenses: listData));
  }

  Future<void> _monthlyBudgetCheck(int revision) async {
    final user = mainContext.read<ProfileBloc>().state.userModel;
    if (_dbRepo.activeUserId == null || user.uid != _dbRepo.activeUserId) {
      return;
    }
    final budget = user.monthlyBudget;
    // Zero means "not configured", not "already over budget".
    if (!budget.isFinite || budget <= 0 ||
        state.amountExpenseThisMonth <= budget) return;
    await _saveWarning(
      type: 0,
      title: AppLocalizations.of(mainContext)!.alertMonthlyBudget,
      message: AppLocalizations.of(mainContext)!.warningMonthlyBudget,
      revision: revision,
    );
  }

  Future<void> _currentBalanceCheck(int revision) async {
    if (state.amountExpenseThisMonth <= state.amountIncomeThisMonth) return;
    await _saveWarning(
      type: 1,
      title: AppLocalizations.of(mainContext)!.alertCurrentBalance,
      message: AppLocalizations.of(mainContext)!.warningCurrentBalance,
      revision: revision,
    );
  }

  Future<void> _totalBalanceCheck(int revision) async {
    if (state.totalBalance >= 0) return;
    await _saveWarning(
      type: 2,
      title: AppLocalizations.of(mainContext)!.alertTotalBalance,
      message: AppLocalizations.of(mainContext)!.warningTotalBalance,
      revision: revision,
    );
  }

  Future<void> _saveWarning({
    required int type,
    required String title,
    required String message,
    required int revision,
  }) async {
    if (isClosed || revision != _dbRepo.revision ||
        _dbRepo.activeUserId == null) return;
    if (await _dbRepo.saveWarningNotificationOnce(
      type: type,
      title: title,
      description: message,
      date: DateTime.now(),
    )) {
      if (!isClosed && revision == _dbRepo.revision) {
        add(GetNotificationCount());
      }
    }
  }

  void _freeResources(FreeResourcesHome event, Emitter<HomeState> emit) {
    emit(
      state.copyWith(
        listTodayExpenses: List.empty(),
        listGoals: List.empty(),
        amountIncomeThisMonth: 0,
        amountExpenseThisMonth: 0,
        totalBalance: 0,
        totalGoals: 0,
        totalNotif: 0,
      ),
    );
  }
}
