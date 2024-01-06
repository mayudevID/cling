// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cling/core/logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/expense_model.dart';
import '../../../../model/goal_model.dart';
import '../../../../model/notification_model_class.dart';
import '../../../../repository/database_repository.dart';
import '../../../language_currency/lang_export.dart';
import '../../main_page.dart';
import '../../profile/bloc/profile_bloc.dart';

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
  var mainContext = MainPage.navKeyMain.currentContext!;

  void _getTotalIncomeExpenseCurrMonth(_, emit) async {
    final result = await Future.wait([
      _dbRepo.getTotalIncomeExpenseCurrMonth(),
      _dbRepo.getTotalBalance(),
    ]);
    final amount = result[0] as Map<String, double?>;
    final totalBalance = result[1] as int;
    Logger.Red.log("aetm: ${amount['expense']}");
    emit(
      state.copyWith(
        amountIncomeThisMonth: amount['income'] ?? 0,
        amountExpenseThisMonth: amount['expense'] ?? 0,
        totalBalance: totalBalance.toDouble(),
      ),
    );

    ///* CHECK MONTHLY BUDGET / TYPE 0
    await _monthlyBudgetCheck();

    ///* CHECK CURRENT BALANCE / TYPE 1
    await _currentBalanceCheck();

    ///* CHECK TOTAL BALANCE / TYPE 2
    await _totalBalanceCheck();
  }

  void _getNotificationCount(event, emit) async {
    final total = await _dbRepo.getNotificationCount();
    emit(state.copyWith(totalNotif: total));
  }

  void _getGoalsHomeWithCount(event, emit) async {
    final result = await Future.wait([
      _dbRepo.getGoalsHome(),
      _dbRepo.getGoalsCount(),
    ]);

    emit(state.copyWith(
      listGoals: result[0] as List<GoalModel>,
      totalGoals: result[1] as int,
    ));
  }

  void _getTodayExpenses(_, emit) async {
    final listData = await _dbRepo.getTodayExpenses();
    emit(state.copyWith(listTodayExpenses: listData));
  }

  Future<void> _monthlyBudgetCheck() async {
    final monthlyBudget =
        mainContext.read<ProfileBloc>().state.userModel.monthlyBudget;

    if (state.amountExpenseThisMonth > monthlyBudget) {
      final sendNotifResult = await _dbRepo.checkNotificationMonthlyBudget();
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

        // //! DEBUG TEST
        // for (var i = 0; i < 73; i++) {
        //   await _dbRepo.saveNotification(
        //     NotificationModelClass(
        //       title: Random().nextInt(253654).toString(),
        //       desc: Random().nextInt(253654).toString(),
        //       isRead: false,
        //       date: DateTime.now(),
        //       type: 0,
        //     ),
        //   );
        // }

        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: id,
            channelKey: 'basic_channel',
            category: NotificationCategory.Error,
            actionType: ActionType.Default,
            title: AppLocalizations.of(mainContext)!.alertMonthlyBudget,
            body: AppLocalizations.of(mainContext)!.warningMonthlyBudget,
          ),
        );
        add(GetNotificationCount());
      }
    }
  }

  Future<void> _currentBalanceCheck() async {
    if (state.amountExpenseThisMonth > state.amountIncomeThisMonth) {
      final sendNotifResult = await _dbRepo.checkNotificationCurrentBalance();
      if (sendNotifResult) {
        final id = await _dbRepo.saveNotification(
          NotificationModelClass(
            title: Random().nextInt(253654).toString(),
            desc: Random().nextInt(253654).toString(),
            isRead: false,
            date: DateTime.now(),
            type: 1,
          ),
        );
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: id,
            channelKey: 'basic_channel',
            category: NotificationCategory.Error,
            actionType: ActionType.Default,
            title: AppLocalizations.of(mainContext)!.alertCurrentBalance,
            body: AppLocalizations.of(mainContext)!.warningCurrentBalance,
          ),
        );
        add(GetNotificationCount());
      }
    }
  }

  Future<void> _totalBalanceCheck() async {
    if (state.totalBalance < 0) {
      final sendNotifResult = await _dbRepo.checkNotificationTotalBalance();
      if (sendNotifResult) {
        final id = await _dbRepo.saveNotification(
          NotificationModelClass(
            title: Random().nextInt(253654).toString(),
            desc: Random().nextInt(253654).toString(),
            isRead: false,
            date: DateTime.now(),
            type: 2,
          ),
        );
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: id,
            channelKey: 'basic_channel',
            category: NotificationCategory.Error,
            actionType: ActionType.Default,
            title: AppLocalizations.of(mainContext)!.alertTotalBalance,
            body: AppLocalizations.of(mainContext)!.warningTotalBalance,
          ),
        );
        add(GetNotificationCount());
      }
    }
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
