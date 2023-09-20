import 'package:bloc/bloc.dart';
import 'package:cling/core/logger.dart';
import 'package:cling/features/model/pie_data_expense_savings.dart';
import 'package:cling/features/repository/database_repository.dart';
import 'package:cling/features/ui/main/main_page.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../model/chart_data.dart';
import '../../../language_currency/lang_export.dart';

part 'statistics_event.dart';
part 'statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  StatisticsBloc({required DatabaseRepository dbRepo})
      : _dbRepo = dbRepo,
        super(StatisticsState()) {
    on<TypeCategoriesEvent>(_typeCategories);
    on<GetMostExpense>(_getMostExpense);
    on<GetIncomeExpenseTotalCurrMonth>(_getIncomeExpenseTotalCurrMonth);
    on<GetIncomeExpenseTotalSixMonth>(_getIncomeExpenseTotalSixMonth);
  }

  final DatabaseRepository _dbRepo;

  void _typeCategories(
    TypeCategoriesEvent event,
    Emitter<StatisticsState> emit,
  ) {
    emit(state.copyWith(
      typeCategories: event.type,
    ));
  }

  void _getIncomeExpenseTotalCurrMonth(
    GetIncomeExpenseTotalCurrMonth event,
    Emitter<StatisticsState> emit,
  ) async {
    final data = await _dbRepo.getTotalIncomeExpenseCurrMonth();
    final expense = data['expense'] ?? 0;
    final income = data['income'] ?? 0;
    final saving = income - expense;
    emit(state.copyWith(
      pieDataExSavList: [
        PieDataExSav(
          nameData: "Expense",
          amount: expense,
          text: "Ex",
        ),
        PieDataExSav(
          nameData: "Savings",
          amount: (saving < 0) ? 0 : saving,
          text: "Save",
        ),
      ],
    ));
  }

  void _getIncomeExpenseTotalSixMonth(
    GetIncomeExpenseTotalSixMonth event,
    Emitter<StatisticsState> emit,
  ) async {
    List<ChartData> incomeData = List.empty(growable: true);
    List<ChartData> expenseData = List.empty(growable: true);
    List<ChartData> savingsData = List.empty(growable: true);

    final result = await _dbRepo.getTotalIncomeExpenseSixMonth();

    if (result != null) {
      result.forEach((key, value) {
        final splitKey = key.split("-");
        key = "${monthDataInExToString(
          context: MainPage.navKeyMain.currentContext!,
          time: splitKey[1],
        )} ${splitKey[0]}";

        Logger.White.log("Month Year: $key");
        Logger.White.log("Income ${value['TotalIncome']}");
        Logger.White.log("Expense ${value['TotalExpense']}");

        final income = double.parse(value['TotalIncome'].toString()) / 100.0;
        final expense = double.parse(value['TotalExpense'].toString()) / 100.0;
        final savings = income - expense;

        incomeData.add(ChartData(x: key, y: income));
        expenseData.add(ChartData(x: key, y: expense));
        savingsData.add(ChartData(x: key, y: (savings < 0) ? 0 : savings));
      });

      emit(state.copyWith(
        chartDataIncomeList: incomeData,
        chartDataExpenseList: expenseData,
        chartDataSavingsList: savingsData,
      ));
    }
  }

  void _getMostExpense(event, emit) async {
    await _dbRepo.getMostExpense();
  }

  String monthDataInExToString({
    required BuildContext context,
    required String time,
    bool compact = false,
  }) {
    var lion = AppLocalizations.of(context)!;
    switch (time) {
      case "01":
        return lion.jan;
      case "02":
        return lion.feb;
      case "03":
        return lion.mar;
      case "04":
        return lion.apr;
      case "05":
        return lion.may;
      case "06":
        return lion.jun;
      case "07":
        return lion.jul;
      case "08":
        return lion.aug;
      case "09":
        return lion.sept;
      case "10":
        return lion.oct;
      case "11":
        return lion.nov;
      case "12":
        return lion.dec;
      default:
        return "-";
    }
  }
}
