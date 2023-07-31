// ignore_for_file: must_be_immutable
part of 'home_bloc.dart';

class HomeState extends Equatable {
  List<IncomeSourceModel> listInSource;
  List<ExpenseCategoriesModel> listExCategories;
  List<ExpenseModel> listTodayExpenses;
  double amountIncome;
  double amountExpense;
  DateTime selectedDate;
  MapEntry<int, String> selectedCategories;
  String descOrItem;
  String amountInput;

  HomeState({
    List<IncomeSourceModel>? listInSource,
    List<ExpenseCategoriesModel>? listExCategories,
    List<ExpenseModel>? listTodayExpenses,
    this.amountIncome = 0,
    this.amountExpense = 0,
    DateTime? selectedDate,
    MapEntry<int, String>? selectedCategories,
    this.descOrItem = "",
    this.amountInput = "",
  })  : selectedDate = selectedDate ??
            DateTime(
              dateNow.year,
              dateNow.month,
              dateNow.day,
            ),
        listTodayExpenses = listTodayExpenses ?? List.empty(),
        listInSource = listInSource ?? List.empty(),
        listExCategories = listExCategories ?? List.empty(),
        selectedCategories = selectedCategories ?? const MapEntry(0, "");

  @override
  List<Object?> get props => [
        listInSource,
        listExCategories,
        listTodayExpenses,
        amountIncome,
        amountExpense,
        selectedDate,
        selectedCategories,
        descOrItem,
        amountInput,
      ];

  HomeState copyWith({
    List<IncomeSourceModel>? listInSource,
    List<ExpenseCategoriesModel>? listExCategories,
    List<ExpenseModel>? listTodayExpenses,
    double? amountIncome,
    double? amountExpense,
    DateTime? selectedDate,
    MapEntry<int, String>? selectedCategories,
    String? descOrItem,
    String? amountInput,
  }) {
    return HomeState(
      listInSource: listInSource ?? this.listInSource,
      listExCategories: listExCategories ?? this.listExCategories,
      listTodayExpenses: listTodayExpenses ?? this.listTodayExpenses,
      amountIncome: amountIncome ?? this.amountIncome,
      amountExpense: amountExpense ?? this.amountExpense,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      descOrItem: descOrItem ?? this.descOrItem,
      amountInput: amountInput ?? this.amountInput,
    );
  }
}
