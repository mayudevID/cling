import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cling/core/common_widget.dart';
import 'package:cling/core/logger.dart';
import 'package:cling/features/model/expense_categories_model.dart';
import 'package:cling/features/model/expense_model.dart';
import 'package:cling/features/model/income_model.dart';
import 'package:cling/features/model/income_source_model.dart';
import 'package:cling/features/repository/database_repository.dart';
import 'package:cling/features/ui/main/home/page/add_in_ex_page.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../widgets/dialog_add_success.dart';

part 'home_event.dart';
part 'home_state.dart';

final dateNow = DateTime.now();

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required DatabaseRepository dbRepo})
      : _dbRepo = dbRepo,
        super(HomeState()) {
    on<GetIncomeSource>(_getIncomeSource);
    on<GetExpenseCategories>(_getExpenseCategories);
    on<ClearDataForm>(_clearDataForm);
    on<GetTotalIncome>(_getTotalIncome);
    on<GetTotalExpense>(_getTotalExpense);
    on<GetGoals>(_getGoals);
    on<GetTodayExpenses>(_getTodayExpenses);
    on<SetDate>(_setDate);
    on<SetCategories>(_setCategories);
    on<SetDescOrItem>(_setDescOrItem);
    on<SetAmountInput>(_setAmountInput);
    on<SaveData>(_saveData);
  }

  final DatabaseRepository _dbRepo;

  void _getTotalIncome(_, emit) async {
    final amount = await _dbRepo.getTotalIncome();
    emit(state.copyWith(amountIncome: amount.toDouble()));
  }

  void _getTotalExpense(_, emit) async {
    final amount = await _dbRepo.getTotalExpense();
    emit(state.copyWith(amountExpense: amount.toDouble()));
  }

  void _getGoals(event, emit) async {}

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
    emit(state.copyWith(amountInput: event.amountInput));
  }

  void _saveData(SaveData event, emit) async {
    if (state.selectedCategories == const MapEntry(0, "")) {
      errorToast("Please select categories");
    }

    if (state.amountInput.trim().isEmpty || state.amountInput.trim() == "0") {
      errorToast("Please fill amount, above 0");
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
          add(GetTotalIncome());
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
          add(GetTotalExpense());
          add(GetTodayExpenses());
          break;
      }
      Future.microtask(() {
        dialogAddSuccess(
          event.context,
          (event.flowType == FlowType.income) ? "Income" : "Expense",
        );
      });
    } on FormatException {
      errorToast("Amount not valid");
    } on DatabaseException catch (e) {
      errorToast(e.toString());
      Logger.Red.log(e.toString());
    }
  }

  void _clearDataForm(ClearDataForm event, emit) {
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
      ),
    );
  }
}
