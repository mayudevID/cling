// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:cling/core/common_widget.dart';
import 'package:cling/core/logger.dart';
import 'package:cling/core/utils.dart';
import 'package:cling/features/model/expense_categories_model.dart';
import 'package:cling/features/model/expense_model.dart';
import 'package:cling/features/model/goal_model.dart';
import 'package:cling/features/model/income_model.dart';
import 'package:cling/features/model/income_source_model.dart';
import 'package:cling/features/repository/database_repository.dart';
import 'package:cling/features/ui/language_currency/lang_export.dart';
import 'package:cling/features/ui/main/home_features/page/add_in_ex_page.dart';
import 'package:cling/features/ui/main/statistics/bloc/statistics_bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../main_page.dart';
import '../widgets/dialog_add_success.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required DatabaseRepository dbRepo,
  })  : _dbRepo = dbRepo,
        super(HomeState()) {
    on<GetIncomeSource>(_getIncomeSource);
    on<GetExpenseCategories>(_getExpenseCategories);
    on<ClearDataForm>(_clearDataForm);
    on<GetIncomeExpenseAmountTotalCurrMonth>(_getTotalIncomeExpenseCurrMonth);
    on<GetGoals>(_getGoals);
    on<GetTodayExpenses>(_getTodayExpenses);
    on<SetDate>(_setDate);
    on<SetCategories>(_setCategories);
    on<SetDescOrItem>(_setDescOrItem);
    on<SetAmountInput>(_setAmountInput);
    on<SaveData>(_saveData);
    on<SetNameGoal>(_setNameGoal);
    on<SetLogoGoal>(_setLogoGoal);
    on<SaveDataGoal>(_saveDataGoal);
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

  //* ADD INCOME AND EXPENSE

  void _setDate(SetDate event, emit) {
    emit(state.copyWith(selectedDate: event.date));
  }

  void _setCategories(SetCategories event, emit) {
    emit(state.copyWith(selectedCategories: event.categories));
  }

  void _getIncomeSource(GetIncomeSource event, emit) async {
    final dataIncomeSource = await _dbRepo.getIncomeSource();
    await Future.delayed(const Duration(milliseconds: 250));
    emit(
      state.copyWith(
        listInSource: dataIncomeSource,
      ),
    );
  }

  void _getExpenseCategories(GetExpenseCategories event, emit) async {
    final dataExCategories = await _dbRepo.getExpenseCategories();
    await Future.delayed(const Duration(milliseconds: 250));
    emit(
      state.copyWith(
        listExCategories: dataExCategories,
      ),
    );
  }

  void _setDescOrItem(SetDescOrItem event, Emitter<HomeState> emit) {
    emit(state.copyWith(descOrItem: event.descOrItem));
  }

  void _setAmountInput(SetAmountInput event, Emitter<HomeState> emit) {
    final replaceDot = event.amountInput.removeDot;
    emit(state.copyWith(amountInput: replaceDot));
  }

  void _saveData(SaveData event, emit) async {
    if (state.selectedCategories == const MapEntry(0, "")) {
      errorToast(AppLocalizations.of(mainContext)!.pleaseSelectCategories);
      return;
    }

    if (state.amountInput.trim().isEmpty || state.amountInput.trim() == "0") {
      errorToast(AppLocalizations.of(mainContext)!.pleaseFillAmount);
      return;
    }

    try {
      switch (event.flowType) {
        case FlowType.income:
          final data = IncomeModel(
            date: state.selectedDate,
            amount: double.parse(state.amountInput),
            desc: state.descOrItem,
            incomeSource:
                '${state.selectedCategories.key} ${state.selectedCategories.value}',
          );
          await _dbRepo.insertIncome(data);

          break;
        case FlowType.expense:
          final data = ExpenseModel(
            date: state.selectedDate,
            amount: double.parse(state.amountInput),
            item: state.descOrItem,
            categories:
                '${state.selectedCategories.key} ${state.selectedCategories.value}',
          );
          await _dbRepo.insertExpense(data);

          ///* Update UI
          add(GetTodayExpenses());
          mainContext.read<StatisticsBloc>().add(GetMostExpense());

          break;
      }

      ///* Update UI
      add(GetIncomeExpenseAmountTotalCurrMonth());
      mainContext.read<StatisticsBloc>()
        ..add(GetIncomeExpenseTotalCurrMonth())
        ..add(GetIncomeExpenseTotalSixMonth());

      dialogAddSuccess(mainContext, event.flowType);
    } on FormatException {
      errorToast(AppLocalizations.of(mainContext)!.invalidAmount);
    } on DatabaseException catch (e) {
      errorToast(e.toString());
      Logger.Red.log(e.toString());
    }
  }

  void _clearDataForm(ClearDataForm event, Emitter<HomeState> emit) {
    final dateNow = DateTime.now();

    emit(
      state.copyWith(
        listInSource: List.empty(),
        listExCategories: List.empty(),
        selectedCategories: const MapEntry(0, ""),
        selectedDate: DateTime(
          dateNow.year,
          dateNow.month,
          dateNow.day,
        ),
        descOrItem: "",
        amountInput: "",
        nameGoal: "",
        logoGoal: "",
      ),
    );
  }

  //* ADD GOAL

  void _setNameGoal(SetNameGoal event, Emitter<HomeState> emit) {
    emit(state.copyWith(nameGoal: event.nameGoal));
  }

  void _setLogoGoal(SetLogoGoal event, Emitter<HomeState> emit) {
    emit(state.copyWith(logoGoal: event.logoGoal));
  }

  void _saveDataGoal(SaveDataGoal event, Emitter<HomeState> emit) async {
    if (state.logoGoal.trim().isEmpty) {
      errorToast(AppLocalizations.of(mainContext)!.pleaseSelectLogo);
      return;
    }

    if (state.nameGoal.trim().isEmpty) {
      errorToast(AppLocalizations.of(mainContext)!.pleaseFillName);
      return;
    }

    if (state.amountInput.trim().isEmpty || state.amountInput.trim() == "0") {
      errorToast(AppLocalizations.of(mainContext)!.pleaseFillAmount);
      return;
    }

    try {
      final goalData = GoalModel(
        name: state.nameGoal.trim(),
        image: state.logoGoal,
        target: double.parse(state.amountInput),
        collected: 0,
      );
      await _dbRepo.insertGoal(goalData);
      add(GetGoals());
      Future.microtask(() {
        dialogAddSuccess(
          mainContext,
          null,
        );
      });
    } on FormatException {
      errorToast(
        AppLocalizations.of(mainContext)!.invalidAmount,
      );
    } on DatabaseException catch (e) {
      errorToast(e.toString());
      Logger.Red.log(e.toString());
    }
  }
}
