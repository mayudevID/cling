// ignore_for_file: use_build_context_synchronously

import 'package:cling/core/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../../core/common_widget.dart';
import '../../../../../core/logger.dart';
import '../../../../model/currency.dart';
import '../../../../model/expense_categories_model.dart';
import '../../../../model/expense_model.dart';
import '../../../../model/income_model.dart';
import '../../../../model/income_source_model.dart';
import '../../../../model/transaction_model.dart';
import '../../../../repository/database_repository.dart';
import '../../../../repository/settings_repository.dart';
import '../../../language_currency/lang_export.dart';
import '../../home/bloc/home_bloc.dart';
import '../../main_page.dart';
import '../../main_widget/dialog_add_success.dart';
import '../../main_widget/enum_flowtype.dart';
import '../../transaction/bloc/transaction_bloc.dart';
import '../../statistics/bloc/statistics_bloc.dart';

part 'edit_income_expense_event.dart';
part 'edit_income_expense_state.dart';

class EditIncomeExpenseBloc
    extends Bloc<EditIncomeExpenseEvent, EditIncomeExpenseState> {
  EditIncomeExpenseBloc({
    required BuildContext context,
    required FlowType flowType,
    required TransactionModel transactionModel,
    required DatabaseRepository dbRepo,
    required SettingsRepository settingsRepo,
  })  : _context = context,
        _dbRepo = dbRepo,
        super(
          EditIncomeExpenseState(
            flowType: flowType,
            selectedDate: transactionModel.date,
            descOrItem: (flowType == FlowType.income)
                ? (transactionModel as IncomeModel).desc ?? ""
                : (transactionModel as ExpenseModel).item,
            amountInput: NumberFormat.currency(
              locale: (settingsRepo.getCurrentCurrency() != null
                      ? Currency.values
                          .where((item) =>
                              item.value.countryCode ==
                              settingsRepo.getCurrentCurrency())
                          .first
                      : Currency.idr)
                  .value
                  .toLanguageTag(),
              decimalDigits: 2,
              //customPattern: '\u00a4###,###.00',
              name: "",
            ).format(transactionModel.amount / 100.0),
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
  }

  final BuildContext _context;
  final DatabaseRepository _dbRepo;
  var mainContext = MainPage.navKeyMain.currentContext!;

  void _setDate(SetDate event, emit) {
    DateTime oldDateTime = state.selectedDate;
    DateTime newDateTime = DateTime(
      event.date.year,
      event.date.month,
      event.date.day,
      oldDateTime.hour,
      oldDateTime.minute,
    );
    emit(state.copyWith(selectedDate: newDateTime));
  }

  void _setTime(SetTime event, emit) {
    DateTime oldDateTime = state.selectedDate;
    DateTime newDateTime = DateTime(
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
    //await Future.delayed(const Duration(milliseconds: 250));

    final loc = dataIncomeSource.firstWhere(
      (e) => event.categoriesOrSource == e.incomeSource,
    );

    emit(state.copyWith(
      listInSource: dataIncomeSource,
      selectedCategories: MapEntry(loc.id, loc.incomeSource),
    ));
  }

  void _getExpenseCategories(GetExpenseCategories event, emit) async {
    final dataExCategories = await _dbRepo.getExpenseCategories();
    //await Future.delayed(const Duration(milliseconds: 250));

    final loc = dataExCategories.firstWhere(
      (e) => event.categoriesOrSource == e.expenseCategories,
    );
    Logger.Red.log(loc);
    emit(state.copyWith(
      listExCategories: dataExCategories,
      selectedCategories: MapEntry(loc.id, loc.expenseCategories),
    ));
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
    final replaceDot = event.amountInput.removeDot;
    emit(state.copyWith(amountInput: replaceDot));
  }

  void _saveData(SaveData event, emit) async {
    if (state.selectedCategories == const MapEntry(0, "")) {
      errorToast(AppLocalizations.of(_context)!.pleaseSelectCategories);
      return;
    }

    if (state.amountInput.trim().isEmpty || state.amountInput.trim() == "0") {
      errorToast(AppLocalizations.of(_context)!.pleaseFillAmount);
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

          ///* Update UI
          mainContext.read<StatisticsBloc>()
            ..add(GetIncomeBreakdown())
            ..add(GetYearlyIncome());

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
          mainContext.read<HomeBloc>().add(GetTodayExpenses());
          mainContext
              .read<StatisticsBloc>()
              .add(GetExpenseBreakdownAndPieData());

          break;
      }

      ///* Update UI
      mainContext.read<HomeBloc>().add(GetIncomeExpenseAmountTotalCurrMonth());
      mainContext.read<TransactionBloc>().add(GetData());
      mainContext.read<StatisticsBloc>()
        ..add(GetIncomeExpenseTotalAllMonth())
        ..add(GetMost());

      dialogAddSuccess(_context, event.flowType);
    } on FormatException {
      errorToast(AppLocalizations.of(_context)!.invalidAmount);
    } on DatabaseException catch (e) {
      errorToast(e.toString());
      Logger.Red.log(e.toString());
    }
  }
}
