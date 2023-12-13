// ignore_for_file: must_be_immutable

part of 'statistics_bloc.dart';

enum RangeDate { daily, monthy, yearly, period }

enum AllStatsChoose { income, expense }

class StatisticsState extends Equatable {
  int typeCategories;
  List<PieDataExSav> pieDataExSavList;
  List<ChartData> yearlyIncomeList;
  List<Map<String, Object?>> mostExpenseList;
  List<Map<String, Object?>> mostIncomeList;
  List<Map<String, Object?>> incomeBreakdownList;
  List<Map<String, Object?>> expenseBreakdownList;
  List<PieDataExpense> pieDataExpenseList;
  List<ChartData> chartDataIncomeList;
  List<ChartData> chartDataExpenseList;
  List<ChartData> chartDataSavingsList;
  double maxValAll;
  double maxValIncome;
  RangeDate rangeDate;
  DateRangePickerView dateRangePickerView;
  DateTime startDate;
  DateTime endDate;
  AllStatsChoose allStatsChoose;

  StatisticsState({
    this.typeCategories = 0,
    this.maxValAll = 0,
    this.maxValIncome = 0,
    this.rangeDate = RangeDate.daily,
    this.dateRangePickerView = DateRangePickerView.month,
    this.allStatsChoose = AllStatsChoose.expense,
    List<PieDataExSav>? pieDataExSavList,
    List<Map<String, Object?>>? mostExpenseList,
    List<Map<String, Object?>>? mostIncomeList,
    List<ChartData>? yearlyIncomeList,
    List<ChartData>? chartDataIncomeList,
    List<ChartData>? chartDataExpenseList,
    List<ChartData>? chartDataSavingsList,
    List<Map<String, Object?>>? incomeBreakdownList,
    List<Map<String, Object?>>? expenseBreakdownList,
    List<PieDataExpense>? pieDataExpenseList,
    DateTime? startDate,
    DateTime? endDate,
  })  : pieDataExSavList = pieDataExSavList ?? List.empty(),
        yearlyIncomeList = yearlyIncomeList ?? List.empty(),
        mostExpenseList = mostExpenseList ?? List.empty(),
        mostIncomeList = mostIncomeList ?? List.empty(),
        incomeBreakdownList = incomeBreakdownList ?? List.empty(),
        chartDataIncomeList = chartDataIncomeList ?? List.empty(),
        chartDataExpenseList = chartDataExpenseList ?? List.empty(),
        chartDataSavingsList = chartDataSavingsList ?? List.empty(),
        pieDataExpenseList = pieDataExpenseList ?? List.empty(),
        expenseBreakdownList = expenseBreakdownList ?? List.empty(),
        startDate = startDate ??
            DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            ),
        endDate = endDate ??
            DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            );

  @override
  List<Object> get props => [
        typeCategories,
        maxValAll,
        maxValIncome,
        pieDataExSavList,
        yearlyIncomeList,
        incomeBreakdownList,
        mostExpenseList,
        mostIncomeList,
        chartDataIncomeList,
        chartDataExpenseList,
        chartDataSavingsList,
        incomeBreakdownList,
        pieDataExpenseList,
        expenseBreakdownList,
        rangeDate,
        dateRangePickerView,
        startDate,
        endDate,
        allStatsChoose,
      ];

  StatisticsState copyWith({
    int? typeCategories,
    double? maxValAll,
    double? maxValIncome,
    List<PieDataExSav>? pieDataExSavList,
    List<Map<String, Object?>>? mostExpenseList,
    List<Map<String, Object?>>? mostIncomeList,
    List<ChartData>? yearlyIncomeList,
    List<ChartData>? chartDataIncomeList,
    List<ChartData>? chartDataExpenseList,
    List<ChartData>? chartDataSavingsList,
    List<Map<String, Object?>>? incomeBreakdownList,
    List<Map<String, Object?>>? expenseBreakdownList,
    List<PieDataExpense>? pieDataExpenseList,
    DateTime? startDate,
    DateTime? endDate,
    RangeDate? rangeDate,
    DateRangePickerView? dateRangePickerView,
    AllStatsChoose? allStatsChoose,
  }) {
    return StatisticsState(
      maxValAll: maxValAll ?? this.maxValAll,
      maxValIncome: maxValIncome ?? this.maxValIncome,
      typeCategories: typeCategories ?? this.typeCategories,
      pieDataExSavList: pieDataExSavList ?? this.pieDataExSavList,
      mostExpenseList: mostExpenseList ?? this.mostExpenseList,
      mostIncomeList: mostIncomeList ?? this.mostIncomeList,
      yearlyIncomeList: yearlyIncomeList ?? this.yearlyIncomeList,
      chartDataIncomeList: chartDataIncomeList ?? this.chartDataIncomeList,
      chartDataExpenseList: chartDataExpenseList ?? this.chartDataExpenseList,
      chartDataSavingsList: chartDataSavingsList ?? this.chartDataSavingsList,
      incomeBreakdownList: incomeBreakdownList ?? this.incomeBreakdownList,
      pieDataExpenseList: pieDataExpenseList ?? this.pieDataExpenseList,
      expenseBreakdownList: expenseBreakdownList ?? this.expenseBreakdownList,
      dateRangePickerView: dateRangePickerView ?? this.dateRangePickerView,
      rangeDate: rangeDate ?? this.rangeDate,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      allStatsChoose: allStatsChoose ?? this.allStatsChoose,
    );
  }
}
