import 'package:bloc/bloc.dart';
import 'package:cling/core/logger.dart';
import 'package:cling/features/model/pie_data_expense_savings.dart';
import 'package:cling/features/repository/database_repository.dart';
import 'package:cling/features/ui/main/main_page.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../model/chart_data.dart';
import '../../../../model/expense_model.dart';
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
    on<GetYearlyIncome>(_getYearlyIncome);
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
    double max = 0;
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

        final income = value['TotalIncome'] / 100.0;
        final expense = value['TotalExpense'] / 100.0;
        final savings = income - expense;

        final maxLocal = (income > expense) ? income : expense;
        max = (max > maxLocal) ? max : maxLocal;

        incomeData.add(ChartData(x: key, y: income));
        expenseData.add(ChartData(x: key, y: expense));
        savingsData.add(ChartData(x: key, y: (savings < 0) ? 0 : savings));
      });

      emit(state.copyWith(
        chartDataIncomeList: incomeData,
        chartDataExpenseList: expenseData,
        chartDataSavingsList: savingsData,
        maxValAll: max,
      ));
    }
  }

  void _getMostExpense(event, emit) async {
    final result = await _dbRepo.getMostExpense();

    emit(state.copyWith(mostExpenseList: result));
  }

  void _getYearlyIncome(event, emit) async {
    List<ChartData> yearlyIncomeList = List.empty(growable: true);
    int max = 0;
    final result = await _dbRepo.getYearlyIncome();

    if (result.isNotEmpty) {
      for (var element in result) {
        yearlyIncomeList.add(
          ChartData(x: element["Month"], y: element["TotalIncome"] / 100.0),
        );
        max = (element["TotalIncome"] > max) ? element["TotalIncome"] : max;
      }

      emit(state.copyWith(
        yearlyIncomeList: yearlyIncomeList,
        maxValIncome: max.toDouble(),
      ));
    }
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
