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
  List<ChartData> chartDataIncomeList;
  List<ChartData> chartDataExpenseList;
  List<ChartData> chartDataSavingsList;
  List<Map<String, Object?>> incomeBreakdownList;
  List<PieDataExpense> pieDataExpenseList;
  List expenseDateRangeList;
  double maxValAll;
  double maxValIncome;
  RangeDate rangeDate;
  DateRangePickerView dateRangePickerView;
  DateTime dateLeft;
  DateTime dateRight;
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
    List<PieDataExpense>? pieDataExpenseList,
    List? expenseDateRangeList,
    DateTime? dateLeft,
    DateTime? dateRight,
  })  : pieDataExSavList = pieDataExSavList ?? List.empty(),
        yearlyIncomeList = yearlyIncomeList ?? List.empty(),
        mostExpenseList = mostExpenseList ?? List.empty(),
        mostIncomeList = mostIncomeList ?? List.empty(),
        incomeBreakdownList = incomeBreakdownList ?? List.empty(),
        chartDataIncomeList = chartDataIncomeList ?? List.empty(),
        chartDataExpenseList = chartDataExpenseList ?? List.empty(),
        chartDataSavingsList = chartDataSavingsList ?? List.empty(),
        pieDataExpenseList = pieDataExpenseList ?? List.empty(),
        expenseDateRangeList = expenseDateRangeList ?? List.empty(),
        dateLeft = dateLeft ??
            DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            ),
        dateRight = dateRight ??
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
        expenseDateRangeList,
        rangeDate,
        dateRangePickerView,
        dateLeft,
        dateRight,
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
    List<PieDataExpense>? pieDataExpenseList,
    List? expenseDateRangeList,
    DateTime? dateLeft,
    DateTime? dateRight,
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
      expenseDateRangeList: expenseDateRangeList ?? this.expenseDateRangeList,
      dateRangePickerView: dateRangePickerView ?? this.dateRangePickerView,
      rangeDate: rangeDate ?? this.rangeDate,
      dateLeft: dateLeft ?? this.dateLeft,
      dateRight: dateRight ?? this.dateRight,
      allStatsChoose: allStatsChoose ?? this.allStatsChoose,
    );
  }
}
