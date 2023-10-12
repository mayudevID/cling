// ignore_for_file: must_be_immutable

part of 'statistics_bloc.dart';

class StatisticsState extends Equatable {
  int typeCategories;
  List<PieDataExSav> pieDataExSavList;
  List<ChartData> yearlyIncomeList;
  List<ExpenseModel> mostExpenseList;
  List<ChartData> chartDataIncomeList;
  List<ChartData> chartDataExpenseList;
  List<ChartData> chartDataSavingsList;
  List<Map<String, Object?>> incomeBreakdownList;
  List<PieDataExpense> expenseBreakdownList;
  List expenseDateRangeList;
  DateTime dateRight;
  double maxValAll;
  double maxValIncome;

  StatisticsState({
    this.typeCategories = 0,
    this.maxValAll = 0,
    this.maxValIncome = 0,
    List<PieDataExSav>? pieDataExSavList,
    List<ExpenseModel>? mostExpenseList,
    List<ChartData>? yearlyIncomeList,
    List<ChartData>? chartDataIncomeList,
    List<ChartData>? chartDataExpenseList,
    List<ChartData>? chartDataSavingsList,
    List<Map<String, Object?>>? incomeBreakdownList,
    List<PieDataExpense>? expenseBreakdownList,
    List? expenseDateRangeList,
    DateTime? dateLeft,
    DateTime? dateRight,
  })  : pieDataExSavList = pieDataExSavList ?? List.empty(),
        yearlyIncomeList = yearlyIncomeList ?? List.empty(),
        mostExpenseList = mostExpenseList ?? List.empty(),
        incomeBreakdownList = incomeBreakdownList ?? List.empty(),
        chartDataIncomeList = chartDataIncomeList ?? List.empty(),
        chartDataExpenseList = chartDataExpenseList ?? List.empty(),
        chartDataSavingsList = chartDataSavingsList ?? List.empty(),
        expenseBreakdownList = expenseBreakdownList ?? List.empty(),
        expenseDateRangeList = expenseDateRangeList ?? List.empty(),
        dateRight = dateRight ?? DateTime.now();

  @override
  List<Object> get props => [
        typeCategories,
        maxValAll,
        maxValIncome,
        pieDataExSavList,
        yearlyIncomeList,
        incomeBreakdownList,
        mostExpenseList,
        chartDataIncomeList,
        chartDataExpenseList,
        chartDataSavingsList,
        incomeBreakdownList,
        expenseBreakdownList,
        expenseDateRangeList,
        dateRight,
      ];

  StatisticsState copyWith({
    int? typeCategories,
    double? maxValAll,
    double? maxValIncome,
    List<PieDataExSav>? pieDataExSavList,
    List<ExpenseModel>? mostExpenseList,
    List<ChartData>? yearlyIncomeList,
    List<ChartData>? chartDataIncomeList,
    List<ChartData>? chartDataExpenseList,
    List<ChartData>? chartDataSavingsList,
    List<Map<String, Object?>>? incomeBreakdownList,
    List<PieDataExpense>? expenseBreakdownList,
    List? expenseDateRangeList,
    DateTime? dateRight,
  }) {
    return StatisticsState(
      maxValAll: maxValAll ?? this.maxValAll,
      maxValIncome: maxValIncome ?? this.maxValIncome,
      typeCategories: typeCategories ?? this.typeCategories,
      pieDataExSavList: pieDataExSavList ?? this.pieDataExSavList,
      mostExpenseList: mostExpenseList ?? this.mostExpenseList,
      yearlyIncomeList: yearlyIncomeList ?? this.yearlyIncomeList,
      chartDataIncomeList: chartDataIncomeList ?? this.chartDataIncomeList,
      chartDataExpenseList: chartDataExpenseList ?? this.chartDataExpenseList,
      chartDataSavingsList: chartDataSavingsList ?? this.chartDataSavingsList,
      incomeBreakdownList: incomeBreakdownList ?? this.incomeBreakdownList,
      expenseBreakdownList: expenseBreakdownList ?? this.expenseBreakdownList,
      expenseDateRangeList: expenseDateRangeList ?? this.expenseDateRangeList,
      dateRight: dateRight ?? this.dateRight,
    );
  }
}
