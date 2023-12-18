// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cling/features/model/expense_model.dart';
import 'package:cling/features/model/goal_model.dart';
import 'package:cling/features/repository/database_repository.dart';
import 'package:cling/features/ui/language_currency/lang_export.dart';
import 'package:cling/features/ui/main/profile/bloc/profile_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/notification_model_class.dart';
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
    on<FreeResourcesHome>(_freeResources);
  }

  final DatabaseRepository _dbRepo;
  var mainContext = MainPage.navKeyMain.currentContext!;

  void _getTotalIncomeExpenseCurrMonth(_, emit) async {
    final amount = await _dbRepo.getTotalIncomeExpenseCurrMonth();
    emit(
      state.copyWith(
        amountIncomeThisMonth: amount['income'],
        amountExpenseThisMonth: amount['expense'],
      ),
    );

    final monthlyBudget =
        mainContext.read<ProfileBloc>().state.userModel.monthlyBudget;

    if (state.amountExpenseThisMonth > monthlyBudget) {
      final sendNotifResult = await _dbRepo.checkNotification();
      if (sendNotifResult) {
        final id = await _dbRepo.saveNotification(
          NotificationModelClass(
            title: Random().nextInt(253654).toString(),
            desc: Random().nextInt(253654).toString(),
            isRead: false,
            date: DateTime.now(),
            type: 0,
          ),
        );
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: id,
            channelKey: 'basic_channel',
            actionType: ActionType.Default,
            title: AppLocalizations.of(mainContext)!.alert,
            body: AppLocalizations.of(mainContext)!.warningMonthlyBudget,
          ),
        );
      }
    }
  }

  void _getGoals(event, emit) async {
    final listData = await _dbRepo.getGoals();
    emit(state.copyWith(listGoals: listData));
  }

  void _getTodayExpenses(_, emit) async {
    final listData = await _dbRepo.getTodayExpenses();
    emit(state.copyWith(listTodayExpenses: listData));
  }

  void _freeResources(FreeResourcesHome event, emit) {
    emit(state.copyWith(
      listTodayExpenses: List.empty(),
      listGoals: List.empty(),
      amountIncomeThisMonth: 0,
      amountExpenseThisMonth: 0,
    ));
  }
}
