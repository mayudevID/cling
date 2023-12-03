import 'package:bloc/bloc.dart';
import 'package:cling/core/logger.dart';
import 'package:cling/features/model/pie_data_expense.dart';
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
    on<GetIncomeBreakdown>(_getIncomeBreakdown);
    on<GetIncomeExpenseTotalAllMonth>(_getIncomeExpenseTotalAllMonth);
    on<GetYearlyIncome>(_getYearlyIncome);
    on<GetExpenseBreakdown>(_getExpenseBreakdown);
    on<ChangeRangeDate>(_changeRangeDate);
    on<ChangeDaily>(_changeDaily);
    on<FreeResourcesStats>(_freeResources);
  }

  final DatabaseRepository _dbRepo;
  var mainContext = MainPage.navKeyMain.currentContext!;

  void _typeCategories(
    TypeCategoriesEvent event,
    Emitter<StatisticsState> emit,
  ) {
    emit(state.copyWith(
      typeCategories: event.type,
    ));
  }

  void _getIncomeExpenseTotalAllMonth(
    GetIncomeExpenseTotalAllMonth event,
    Emitter<StatisticsState> emit,
  ) async {
    double max = 0;
    double totalExpense = 0;
    double totalSavings = 0;

    List<ChartData> incomeData = List.empty(growable: true);
    List<ChartData> expenseData = List.empty(growable: true);
    List<ChartData> savingsData = List.empty(growable: true);

    final result = await _dbRepo.getTotalIncomeExpenseAllMonth();

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

        totalExpense += expense;
        totalSavings += savings;

        final maxLocal = (income > expense) ? income : expense;
        max = (max > maxLocal) ? max : maxLocal;

        incomeData.add(ChartData(x: key, y: income));
        expenseData.add(ChartData(x: key, y: expense));
        savingsData.add(ChartData(x: key, y: (savings < 0) ? 0 : savings));
      });

      Logger.White.log("MaxAll: $max");

      final pieData = [
        PieDataExSav(
          nameData: "Expense",
          amount: totalExpense,
          text: "Ex",
        ),
        PieDataExSav(
          nameData: "Savings",
          amount: (totalSavings < 0) ? 0 : totalSavings,
          text: "Save",
        ),
      ];

      emit(
        state.copyWith(
          chartDataIncomeList: incomeData,
          chartDataExpenseList: expenseData,
          chartDataSavingsList: savingsData,
          maxValAll: max,
          pieDataExSavList: pieData,
        ),
      );
    }
  }

  void _getIncomeBreakdown(event, emit) async {
    final result = await _dbRepo.getIncomeBreakdown();

    if (result.isNotEmpty) {
      emit(state.copyWith(incomeBreakdownList: result));
    }
  }

  void _getExpenseBreakdown(event, emit) async {
    List<PieDataExpense> expenseBreakdownList = List.empty(growable: true);
    final result = await _dbRepo.getExpenseBreakdown();

    if (result.isNotEmpty) {
      for (Map element in result) {
        final getCat = element["Categories"].toString();

        final cat = getCat.substring(getCat.indexOf(" ") + 1);

        final total = element["TotalExpense"] / 100.0;
        expenseBreakdownList.add(
          PieDataExpense(
            nameCategories: cat,
            amount: total,
          ),
        );
      }

      emit(state.copyWith(expenseBreakdownList: expenseBreakdownList));
    }
  }

  void _getMostExpense(event, emit) async {
    final result = await _dbRepo.getMostExpense();

    if (result.isNotEmpty) {
      emit(state.copyWith(mostExpenseList: result));
    }
  }

  void _getYearlyIncome(event, emit) async {
    List<ChartData> yearlyIncomeList = List.empty(growable: true);
    double max = 0;
    final result = await _dbRepo.getYearlyIncome();

    if (!result.values.every((value) => value == 0)) {
      result.forEach((key, value) {
        final splitKey = key.split("-");
        key = monthDataInExToString(
          context: MainPage.navKeyMain.currentContext!,
          time: splitKey[1],
        );

        value = value / 100.0;

        yearlyIncomeList.add(ChartData(x: key, y: value));

        max = (value > max) ? value : max;
      });

      emit(state.copyWith(
        yearlyIncomeList: yearlyIncomeList,
        maxValIncome: max.toDouble(),
      ));
    }
  }

  void _changeRangeDate(ChangeRangeDate event, emit) {
    emit(state.copyWith(rangeDate: event.rangeDate));
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

  void _changeDaily(ChangeDaily event, emit) async {
    if (event.leftOrRightOrPick == 0) {
      emit(
        state.copyWith(
          dateRight: state.dateRight.subtract(const Duration(days: 1)),
        ),
      );
    } else if (event.leftOrRightOrPick == 1) {
      emit(
        state.copyWith(
          dateRight: state.dateRight.add(const Duration(days: 1)),
        ),
      );
    } else {
      DateTime? pickedDate = await showDatePicker(
        context: mainContext,
        initialDate: state.dateRight,
        firstDate: DateTime(1970, 1, 1),
        lastDate: state.dateRight,
      );
      if (pickedDate != null) {
        emit(
          state.copyWith(dateRight: pickedDate),
        );
      }
    }
  }

  void _freeResources(FreeResourcesStats event, emit) {
    emit(state.copyWith(
      pieDataExSavList: List.empty(),
      yearlyIncomeList: List.empty(),
      mostExpenseList: List.empty(),
      incomeBreakdownList: List.empty(),
      chartDataIncomeList: List.empty(),
      chartDataExpenseList: List.empty(),
      chartDataSavingsList: List.empty(),
      expenseBreakdownList: List.empty(),
      expenseDateRangeList: List.empty(),
    ));
  }
}
