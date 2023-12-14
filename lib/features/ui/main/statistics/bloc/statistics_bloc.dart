import 'package:cling/core/logger.dart';
import 'package:cling/features/model/pie_data_expense.dart';
import 'package:cling/features/model/pie_data_expense_savings.dart';
import 'package:cling/features/repository/database_repository.dart';
import 'package:cling/features/ui/language_currency/lang_currency_bloc.dart';
import 'package:cling/features/ui/main/main_page.dart';
import 'package:cling/resources/gen/fonts.gen.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../model/chart_data.dart';
import '../../../language_currency/lang_export.dart';
import '../../main_widget/change_date_widget/convert_enum_to_detail_date.dart';

part 'statistics_event.dart';
part 'statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  StatisticsBloc({required DatabaseRepository dbRepo})
      : _dbRepo = dbRepo,
        super(StatisticsState()) {
    on<TypeCategoriesEvent>(_typeCategories);
    on<GetMost>(_getMost);
    on<GetIncomeBreakdown>(_getIncomeBreakdown);
    on<GetExpenseBreakdownAndPieData>(_getExpenseBreakdownAndPieData);
    on<GetIncomeExpenseTotalAllMonth>(_getIncomeExpenseTotalAllMonth);
    on<GetYearlyIncome>(_getYearlyIncome);
    on<ChangeAllStatsChoose>(_changeAllStatsChoose);
    on<ChangeRangeDate>(_changeRangeDate);
    on<ChangeDaily>(_changeDaily);
    on<ChangeMonthly>(_changeMonthly);
    on<ChangeYearly>(_changeYearly);
    on<ChangeDateRangePickerView>(_changeDateRangePickerView);
    on<ChangeDateForPeriod>(_changeDateForPeriod);
    on<FreeResourcesStats>(_freeResources);
  }

  DateTime get timeNow {
    return DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
  }

  final DatabaseRepository _dbRepo;
  var mainContext = MainPage.navKeyMain.currentContext!;

  int _getDaysInMonth(int year, int month) {
    DateTime lastDayOfMonth = DateTime(year, month + 1, 1).subtract(
      const Duration(days: 1),
    );
    return lastDayOfMonth.day;
  }

  void _typeCategories(
    TypeCategoriesEvent event,
    Emitter<StatisticsState> emit,
  ) {
    emit(
      state.copyWith(typeCategories: event.type),
    );
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
    final result = await _dbRepo.getIncomeBreakdown(
      state.startDate,
      state.endDate,
    );

    emit(state.copyWith(
      incomeBreakdownList: (result.isNotEmpty) ? result : List.empty(),
    ));

    Logger.Yellow.log("GetIncomeBreakdown Called");
  }

  void _getExpenseBreakdownAndPieData(event, emit) async {
    List<PieDataExpense> pieDataExpenseList = List.empty(growable: true);
    final result = await _dbRepo.getExpenseBreakdown(
      state.startDate,
      state.endDate,
    );

    if (result.isNotEmpty) {
      for (Map element in result) {
        final getCat = element["Categories"].toString();

        final cat = getCat.substring(getCat.indexOf(" ") + 1);

        final total = element["TotalExpense"] / 100.0;
        pieDataExpenseList.add(
          PieDataExpense(nameCategories: cat, amount: total),
        );
      }

      emit(
        state.copyWith(
          expenseBreakdownList: result,
          pieDataExpenseList: pieDataExpenseList,
        ),
      );
    } else {
      emit(
        state.copyWith(
          expenseBreakdownList: List.empty(),
          pieDataExpenseList: List.empty(),
        ),
      );
    }

    Logger.Yellow.log("GetExpenseBreakdown Called");
  }

  void _getMost(event, emit) async {
    final result = await _dbRepo.getMost(state.allStatsChoose);

    if (result.isNotEmpty) {
      final isIncome = state.allStatsChoose == AllStatsChoose.income;
      emit(
        state.copyWith(
          mostIncomeList: isIncome ? result : List.empty(),
          mostExpenseList: isIncome ? List.empty() : result,
        ),
      );
    } else {
      emit(
        state.copyWith(
          mostIncomeList: List.empty(),
          mostExpenseList: List.empty(),
        ),
      );
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

  void _changeDateForPeriod(ChangeDateForPeriod event, emit) {
    emit(
      state.copyWith(
        startDate: event.startDate,
        endDate: event.endDate,
      ),
    );
    Logger.Green.log(
      "ChangeDateForPeriod (${convertEnumToDetailDate(mainContext, state.dateRangePickerView)})",
    );
    Logger.White.log(DateFormat.yMMMd().format(state.startDate));
    Logger.White.log(DateFormat.yMMMd().format(state.endDate));
    add(GetIncomeBreakdown());
    add(GetExpenseBreakdownAndPieData());
  }

  void _changeAllStatsChoose(ChangeAllStatsChoose event, emit) {
    emit(state.copyWith(allStatsChoose: event.allStatsChoose));
    add(GetMost());
  }

  void _changeRangeDate(ChangeRangeDate event, emit) {
    DateTime startDate;
    DateTime endDate;
    switch (event.rangeDate) {
      case RangeDate.daily:
        startDate = timeNow;
        endDate = timeNow;
        Logger.Green.log("ChangeRangeDate Daily");
        break;
      case RangeDate.monthy:
        startDate = DateTime(
          state.endDate.year,
          state.endDate.month,
          1,
        );
        endDate = DateTime(
          state.endDate.year,
          state.endDate.month,
          _getDaysInMonth(state.endDate.year, state.endDate.month),
        );
        Logger.Green.log("ChangeRangeDate Monthly");
        break;
      case RangeDate.yearly:
        startDate = DateTime(state.endDate.year, 1, 1);
        endDate = DateTime(state.endDate.year, 12, 31);
        Logger.Green.log("ChangeRangeDate Yearly");
        break;
      case RangeDate.period:
        startDate = timeNow.subtract(const Duration(days: 4));
        endDate = timeNow;
        Logger.Green.log("ChangeRangeDate Period");
        break;
    }
    emit(
      state.copyWith(
        rangeDate: event.rangeDate,
        startDate: startDate,
        endDate: endDate,
        dateRangePickerView: (event.rangeDate == RangeDate.period)
            ? DateRangePickerView.month
            : null,
      ),
    );
    Logger.White.log(DateFormat.yMMMd().format(state.startDate));
    Logger.White.log(DateFormat.yMMMd().format(state.endDate));
    add(GetIncomeBreakdown());
    add(GetExpenseBreakdownAndPieData());
  }

  void _changeDaily(ChangeDaily event, emit) async {
    Logger.Green.log("ChangeDaily");
    switch (event.leftOrRightOrPick) {
      case 0:
        final newDate = state.endDate.subtract(const Duration(days: 1));
        emit(state.copyWith(startDate: newDate, endDate: newDate));
        break;
      case 1:
        final newDate = state.endDate.add(const Duration(days: 1));
        emit(state.copyWith(startDate: newDate, endDate: newDate));
        break;
      default:
        DateTime? pickedDate = await showDatePicker(
          context: mainContext,
          initialDate: state.endDate,
          initialDatePickerMode: DatePickerMode.day,
          firstDate: DateTime(1970, 1, 1),
          lastDate: state.endDate.add(const Duration(days: 1000)),
        );
        if (pickedDate != null) {
          emit(
            state.copyWith(startDate: pickedDate, endDate: pickedDate),
          );
        }
        break;
    }
    Logger.White.log(DateFormat.yMMMd().format(state.endDate));
    add(GetIncomeBreakdown());
    add(GetExpenseBreakdownAndPieData());
  }

  void _changeMonthly(ChangeMonthly event, emit) async {
    Logger.Green.log("ChangeMonthly");
    if (event.leftOrRightOrPick == 0 || event.leftOrRightOrPick == 1) {
      int monthModifier = (event.leftOrRightOrPick == 0) ? -1 : 1;

      final newStartDate = DateTime(
        state.startDate.year,
        state.startDate.month + monthModifier,
        1,
      );
      final newEndDate = DateTime(
        state.endDate.year,
        state.endDate.month + monthModifier,
        _getDaysInMonth(
          state.endDate.year,
          state.endDate.month + monthModifier,
        ),
      );
      emit(state.copyWith(startDate: newStartDate, endDate: newEndDate));
    } else {
      final pickedDate = await showMonthYearPicker(
        locale:
            mainContext.read<LangCurrencyBloc>().state.selectedLanguage.value,
        context: mainContext,
        initialDate: state.endDate,
        firstDate: timeNow.subtract(const Duration(days: 10000000)),
        lastDate: timeNow.add(const Duration(days: 10000000)),
      );
      if (pickedDate != null) {
        final newStartDate = DateTime(pickedDate.year, pickedDate.month, 1);
        final newEndDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          _getDaysInMonth(pickedDate.year, pickedDate.month),
        );
        emit(state.copyWith(startDate: newStartDate, endDate: newEndDate));
      }
    }
    Logger.White.log(DateFormat.yMMMd().format(state.startDate));
    Logger.White.log(DateFormat.yMMMd().format(state.endDate));
    add(GetIncomeBreakdown());
    add(GetExpenseBreakdownAndPieData());
  }

  void _changeYearly(ChangeYearly event, emit) async {
    Logger.Green.log("ChangeYearly");
    if (event.leftOrRightOrPick == 0 || event.leftOrRightOrPick == 1) {
      int yearModifier = (event.leftOrRightOrPick == 0) ? -1 : 1;

      final newStartDate = DateTime(state.endDate.year + yearModifier, 1, 1);
      final newEndDate = DateTime(
        state.endDate.year + yearModifier,
        12,
        31,
      );

      emit(state.copyWith(startDate: newStartDate, endDate: newEndDate));
    } else {
      DateTime? pickedDate = await showDialog(
        context: mainContext,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Select Year",
              style: TextStyle(
                fontFamily: FontFamily.cabinetGrotesk,
              ),
            ),
            content: SizedBox(
              width: 300,
              height: 300,
              child: YearPicker(
                firstDate: DateTime(timeNow.year - 100, 1),
                lastDate: DateTime(timeNow.year + 100, 1),
                currentDate: timeNow,
                selectedDate: state.endDate,
                onChanged: (DateTime dateTime) {
                  Navigator.pop(context, dateTime);
                },
              ),
            ),
          );
        },
      );

      if (pickedDate != null) {
        final newStartDate = DateTime(pickedDate.year, 1, 1);
        final newEndDate = DateTime(
          pickedDate.year,
          12,
          _getDaysInMonth(pickedDate.year, pickedDate.month),
        );
        emit(state.copyWith(startDate: newStartDate, endDate: newEndDate));
      }
    }
    Logger.White.log(DateFormat.yMMMd().format(state.startDate));
    Logger.White.log(DateFormat.yMMMd().format(state.endDate));
    add(GetIncomeBreakdown());
    add(GetExpenseBreakdownAndPieData());
  }

  void _changeDateRangePickerView(ChangeDateRangePickerView event, emit) {
    DateTime? newStartDate;
    DateTime? newEndDate;

    switch (event.dateRangePickerView) {
      case DateRangePickerView.month:
        newStartDate = timeNow.subtract(const Duration(days: 4));
        newEndDate = timeNow;
        Logger.Green.log("ChangeDateRangePickerView (By Day)");
        break;
      case DateRangePickerView.year:
        newStartDate = DateTime(state.startDate.year, state.startDate.month, 1);
        newEndDate = DateTime(
          state.endDate.year,
          state.endDate.month,
          _getDaysInMonth(state.endDate.year, state.endDate.month),
        );
        Logger.Green.log("ChangeDateRangePickerView (By Month)");
        break;
      case DateRangePickerView.decade:
        newStartDate = DateTime(state.startDate.year, 1, 1);
        newEndDate = DateTime(state.endDate.year, 12, 31);
        Logger.Green.log("ChangeDateRangePickerView (By Year)");
        break;
      case DateRangePickerView.century:
        break;
    }
    emit(
      state.copyWith(
        dateRangePickerView: event.dateRangePickerView,
        startDate: newStartDate,
        endDate: newEndDate,
      ),
    );
    Logger.White.log(DateFormat.yMMMd().format(state.startDate));
    Logger.White.log(DateFormat.yMMMd().format(state.endDate));
    add(GetIncomeBreakdown());
    add(GetExpenseBreakdownAndPieData());
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
      pieDataExpenseList: List.empty(),
      expenseBreakdownList: List.empty(),
    ));
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
