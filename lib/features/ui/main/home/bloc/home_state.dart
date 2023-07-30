// ignore_for_file: must_be_immutable
part of 'home_bloc.dart';

class HomeState extends Equatable {
  List<IncomeSourceModel> listInSource;
  List<ExpenseCategoriesModel> listExCategories;
  List<ExpenseModel> listTodayExpenses;
  double amountIncome;
  double amountExpense;
  DateTime selectedDate;
  Map<int, String> selectedCategories;

  HomeState({
    List<IncomeSourceModel>? listInSource,
    List<ExpenseCategoriesModel>? listExCategories,
    List<ExpenseModel>? listTodayExpenses,
    this.amountIncome = 0,
    this.amountExpense = 0,
    DateTime? selectedDate,
    Map<int, String>? selectedCategories,
  })  : selectedDate = selectedDate ??
            DateTime(
              dateNow.year,
              dateNow.month,
              dateNow.day,
            ),
        listTodayExpenses = listTodayExpenses ?? List.empty(),
        listInSource = listInSource ?? List.empty(),
        listExCategories = listExCategories ?? List.empty(),
        selectedCategories = selectedCategories ?? {};

  @override
  List<Object?> get props => [
        listInSource,
        listExCategories,
        listTodayExpenses,
        amountIncome,
        amountExpense,
        selectedDate,
        selectedCategories,
      ];

  HomeState copyWith({
    List<IncomeSourceModel>? listInSource,
    List<ExpenseCategoriesModel>? listExCategories,
    List<ExpenseModel>? listTodayExpenses,
    double? amountIncome,
    double? amountExpense,
    DateTime? selectedDate,
    Map<int, String>? selectedCategories,
  }) {
    return HomeState(
      listInSource: listInSource ?? this.listInSource,
      listExCategories: listExCategories ?? this.listExCategories,
      listTodayExpenses: listTodayExpenses ?? this.listTodayExpenses,
      amountIncome: amountIncome ?? this.amountIncome,
      amountExpense: amountExpense ?? this.amountExpense,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedCategories: selectedCategories ?? this.selectedCategories,
    );
  }
}
