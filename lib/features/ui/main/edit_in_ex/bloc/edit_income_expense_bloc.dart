// ignore_for_file: use_build_context_synchronously

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../../core/common_widget.dart';
import '../../../../../core/logger.dart';
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
import '../../main_widget/enum_flowtype.dart';
import '../../stats_detail/bloc/stats_detail_bloc.dart';
import '../../stats_detail/page/stats_detail_per_categories_page.dart';
import '../../transaction/bloc/transaction_bloc.dart';
import '../../statistics/bloc/statistics_bloc.dart';

part 'edit_income_expense_event.dart';
part 'edit_income_expense_state.dart';

class EditIncomeExpenseBloc
    extends Bloc<EditIncomeExpenseEvent, EditIncomeExpenseState> {
  EditIncomeExpenseBloc({
    required BuildContext context,
    required DatabaseRepository dbRepo,
    required SettingsRepository settingsRepo,
    required String descOrItem,
    required double amount,
  })  : _context = context,
        _dbRepo = dbRepo,
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

  final BuildContext _context;
  final DatabaseRepository _dbRepo;
  var mainContext = MainPage.navKeyMain.currentContext!;
  var detailStatsContext = StatsDetailPerCategoriesPage.navKey.currentContext;

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
    emit(state.copyWith(amountInput: event.amountInput * 1.0));
  }

  void _saveData(SaveData event, emit) async {
    if (state.selectedCategories == const MapEntry(0, "")) {
      errorToast(AppLocalizations.of(_context)!.pleaseSelectCategories);
      return;
    }

    if (state.amountInput == 0) {
      errorToast(AppLocalizations.of(_context)!.pleaseFillAmount);
      return;
    }

    try {
      TransactionModel data;
      switch (state.flowType) {
        case FlowType.income:
          data = IncomeModel(
            id: state.id,
            date: state.selectedDate,
            amount: state.amountInput,
            desc: state.descOrItem,
            incomeSource:
                '${state.selectedCategories.key} ${state.selectedCategories.value}',
          );
          await _dbRepo.updateIncome(data as IncomeModel);

          ///* Update UI
          mainContext.read<StatisticsBloc>()
            ..add(GetIncomeBreakdown())
            ..add(GetYearlyIncome());

          break;
        case FlowType.expense:
          data = ExpenseModel(
            id: state.id,
            date: state.selectedDate,
            amount: state.amountInput,
            item: state.descOrItem,
            categories:
                '${state.selectedCategories.key} ${state.selectedCategories.value}',
          );
          await _dbRepo.updateExpense(data as ExpenseModel);

          ///* Update UI
          mainContext.read<HomeBloc>().add(GetTodayExpenses());
          mainContext
              .read<StatisticsBloc>()
              .add(GetExpenseBreakdownAndPieData());

          break;
      }

      ///* Update UI
      mainContext.read<HomeBloc>().add(GetIncomeExpenseAmountTotalCurrMonth());
      mainContext.read<StatisticsBloc>()
        ..add(GetIncomeExpenseTotalAllMonth())
        ..add(GetMost());
      detailStatsContext?.read<StatsDetailBloc>().add(UpdateFromEdit(data));

      if (mainContext.read<TransactionBloc>().state.date ==
          DateTime(DateTime.now().year, DateTime.now().month, 1)) {
        mainContext.read<TransactionBloc>().add(GetData());
      }

      Navigator.pop(mainContext);
    } on FormatException {
      errorToast(AppLocalizations.of(_context)!.invalidAmount);
    } on DatabaseException catch (e) {
      errorToast(e.toString());
      Logger.Red.log(e.toString());
    }
  }

  void _deleteData(DeleteData event, emit) async {
    final result = await dialogDelete(_context);
    if (!result) return;

    switch (state.flowType) {
      case FlowType.income:
        await _dbRepo.deleteIncome(state.id);

        ///* Update UI
        mainContext.read<StatisticsBloc>()
          ..add(GetIncomeBreakdown())
          ..add(GetYearlyIncome());

        Logger.Green.log("Delete Income ${state.id} and Updated");
        break;
      case FlowType.expense:
        await _dbRepo.deleteExpense(state.id);

        ///* Update UI
        mainContext.read<HomeBloc>().add(GetTodayExpenses());
        mainContext.read<StatisticsBloc>().add(GetExpenseBreakdownAndPieData());

        Logger.Green.log("Delete Expense ${state.id} and Updated");
        break;
    }

    ///* Update UI
    mainContext.read<HomeBloc>().add(GetIncomeExpenseAmountTotalCurrMonth());
    mainContext.read<StatisticsBloc>()
      ..add(GetIncomeExpenseTotalAllMonth())
      ..add(GetMost());
    detailStatsContext?.read<StatsDetailBloc>().add(DeleteFromEdit(state.id));

    if (mainContext.read<TransactionBloc>().state.date ==
        DateTime(DateTime.now().year, DateTime.now().month, 1)) {
      mainContext.read<TransactionBloc>().add(GetData());
    }

    Logger.Green.log("Updated --> Back");
    Navigator.pop(_context);
  }
}
