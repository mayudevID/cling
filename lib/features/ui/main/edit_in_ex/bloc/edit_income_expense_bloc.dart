// ignore_for_file: use_buildmainContext_synchronously, use_build_context_synchronously

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../../core/common_widget.dart';
import '../../../../../core/money_amount.dart';
import '../../../../../core/logger.dart';
import '../../../../../main.dart';
import '../../../../model/expense_categories_model.dart';
import '../../../../model/expense_model.dart';
import '../../../../model/income_model.dart';
import '../../../../model/income_source_model.dart';
import '../../../../model/transaction_model.dart';
import '../../../../repository/database_repository.dart';
import '../../../../repository/settings_repository.dart';
import '../../../language_currency/lang_export.dart';
import '../../main_widget/finance_refresh.dart';
import '../../main_widget/enum_flowtype.dart';

part 'edit_income_expense_event.dart';
part 'edit_income_expense_state.dart';

class EditIncomeExpenseBloc
    extends Bloc<EditIncomeExpenseEvent, EditIncomeExpenseState> {
  EditIncomeExpenseBloc({
    required DatabaseRepository dbRepo,
    required SettingsRepository settingsRepo,
    required String descOrItem,
    required double amount,
  })  : _dbRepo = dbRepo,
        super(
          EditIncomeExpenseState(
            descOrItem: descOrItem,
            amountInput: amount,
          ),
        ) {
    on<SetDate>(_setDate);
    on<SetTime>(_setTime);
    on<SetCategories>(_setCategories);
    on<SetDescOrItem>(_setDescOrItem);
    on<SetAmountInput>(_setAmountInput);
    on<SaveData>(_saveData);
    on<GetIncomeSource>(_getIncomeSource);
    on<GetExpenseCategories>(_getExpenseCategories);
    on<DeleteData>(_deleteData);
  }

  final DatabaseRepository _dbRepo;
  BuildContext get mainContext => MainApp.navKeyGlobal.currentContext!;

  void _setDate(SetDate event, emit) {
    final DateTime oldDateTime = state.selectedDate;
    final DateTime newDateTime = DateTime(
      event.date.year,
      event.date.month,
      event.date.day,
      oldDateTime.hour,
      oldDateTime.minute,
    );
    emit(state.copyWith(selectedDate: newDateTime));
  }

  void _setTime(SetTime event, emit) {
    final DateTime oldDateTime = state.selectedDate;
    final DateTime newDateTime = DateTime(
      oldDateTime.year,
      oldDateTime.month,
      oldDateTime.day,
      event.time.hour,
      event.time.minute,
    );
    emit(state.copyWith(selectedDate: newDateTime));
  }

  void _setCategories(SetCategories event, emit) {
    emit(state.copyWith(selectedCategories: event.categories));
  }

  void _getIncomeSource(GetIncomeSource event, emit) async {
    final dataIncomeSource = await _dbRepo.getIncomeSource();

    final loc = dataIncomeSource.firstWhere(
      (e) =>
          (event.transactionModel as IncomeModel).incomeSource ==
          e.incomeSource,
    );

    emit(
      state.copyWith(
        id: event.transactionModel.id,
        flowType: FlowType.income,
        selectedDate: event.transactionModel.date,
        listInSource: dataIncomeSource,
        selectedCategories: MapEntry(loc.id, loc.incomeSource),
      ),
    );
  }

  void _getExpenseCategories(GetExpenseCategories event, emit) async {
    final dataExCategories = await _dbRepo.getExpenseCategories();

    final loc = dataExCategories.firstWhere(
      (e) =>
          (event.transactionModel as ExpenseModel).categories ==
          e.expenseCategories,
    );

    emit(
      state.copyWith(
        id: event.transactionModel.id,
        flowType: FlowType.expense,
        selectedDate: event.transactionModel.date,
        listExCategories: dataExCategories,
        selectedCategories: MapEntry(loc.id, loc.expenseCategories),
      ),
    );
  }

  void _setDescOrItem(
    SetDescOrItem event,
    Emitter<EditIncomeExpenseState> emit,
  ) {
    emit(state.copyWith(descOrItem: event.descOrItem));
  }

  void _setAmountInput(
    SetAmountInput event,
    Emitter<EditIncomeExpenseState> emit,
  ) {
    emit(state.copyWith(amountInput: event.amountInput));
  }

  Future<void> _saveData(
    SaveData event,
    Emitter<EditIncomeExpenseState> emit,
  ) async {
    if (state.selectedCategories == const MapEntry(0, "")) {
      errorToast(AppLocalizations.of(mainContext)!.pleaseSelectCategories);
      return;
    }
    if (!state.amountInput.isFinite || state.amountInput <= 0) {
      errorToast(AppLocalizations.of(mainContext)!.pleaseFillAmount);
      return;
    }

    try {
      MoneyAmount.toMinorUnits(state.amountInput);
      switch (state.flowType) {
        case FlowType.income:
          await _dbRepo.updateIncome(
            IncomeModel(
              id: state.id,
              date: state.selectedDate,
              amount: state.amountInput,
              desc: state.descOrItem,
              incomeSource:
                  '${state.selectedCategories.key} ${state.selectedCategories.value}',
            ),
          );
          break;
        case FlowType.expense:
          await _dbRepo.updateExpense(
            ExpenseModel(
              id: state.id,
              date: state.selectedDate,
              amount: state.amountInput,
              item: state.descOrItem,
              categories:
                  '${state.selectedCategories.key} ${state.selectedCategories.value}',
            ),
          );
          break;
      }
      refreshFinancialViews(mainContext);
      Navigator.pop(mainContext);
    } on FormatException {
      errorToast(AppLocalizations.of(mainContext)!.invalidAmount);
    } on DatabaseException catch (e) {
      errorToast(e.toString());
      Logger.Red.log(e.toString());
    }
  }

  Future<void> _deleteData(
    DeleteData event,
    Emitter<EditIncomeExpenseState> emit,
  ) async {
    final confirmed = await dialogDelete(mainContext);
    if (!confirmed) return;

    try {
      switch (state.flowType) {
        case FlowType.income:
          await _dbRepo.deleteIncome(state.id);
          break;
        case FlowType.expense:
          await _dbRepo.deleteExpense(state.id);
          break;
      }
      refreshFinancialViews(mainContext);
      Navigator.pop(mainContext);
    } on DatabaseException catch (e) {
      errorToast(e.toString());
      Logger.Red.log(e.toString());
    }
  }
}
