// ignore_for_file: must_be_immutable
part of 'home_bloc.dart';

class HomeState extends Equatable {
  List<IncomeSourceModel> listInSource;
  List<ExpenseCategoriesModel> listExCategories;
  List<ExpenseModel> listTodayExpenses;
  List<GoalModel> listGoals;
  double amountIncome;
  double amountExpense;
  DateTime selectedDate;
  MapEntry<int, String> selectedCategories;
  String descOrItem;
  String amountInput;
  String nameGoal;
  String logoGoal;

  HomeState({
    List<IncomeSourceModel>? listInSource,
    List<ExpenseCategoriesModel>? listExCategories,
    List<ExpenseModel>? listTodayExpenses,
    List<GoalModel>? listGoals,
    this.amountIncome = 0,
    this.amountExpense = 0,
    DateTime? selectedDate,
    MapEntry<int, String>? selectedCategories,
    this.descOrItem = "",
    this.amountInput = "",
    this.nameGoal = "",
    this.logoGoal = "",
  })  : selectedDate = selectedDate ?? DateTime.now(),
        listTodayExpenses = listTodayExpenses ?? List.empty(),
        listInSource = listInSource ?? List.empty(),
        listExCategories = listExCategories ?? List.empty(),
        selectedCategories = selectedCategories ?? const MapEntry(0, ""),
        listGoals = listGoals ?? List.empty();

  @override
  List<Object?> get props => [
        listInSource,
        listExCategories,
        listTodayExpenses,
        listGoals,
        amountIncome,
        amountExpense,
        selectedDate,
        selectedCategories,
        descOrItem,
        amountInput,
        nameGoal,
        logoGoal,
      ];

  HomeState copyWith({
    List<IncomeSourceModel>? listInSource,
    List<ExpenseCategoriesModel>? listExCategories,
    List<ExpenseModel>? listTodayExpenses,
    List<GoalModel>? listGoals,
    double? amountIncome,
    double? amountExpense,
    DateTime? selectedDate,
    MapEntry<int, String>? selectedCategories,
    String? descOrItem,
    String? amountInput,
    String? nameGoal,
    String? logoGoal,
  }) {
    return HomeState(
      listInSource: listInSource ?? this.listInSource,
      listExCategories: listExCategories ?? this.listExCategories,
      listTodayExpenses: listTodayExpenses ?? this.listTodayExpenses,
      listGoals: listGoals ?? this.listGoals,
      amountIncome: amountIncome ?? this.amountIncome,
      amountExpense: amountExpense ?? this.amountExpense,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      descOrItem: descOrItem ?? this.descOrItem,
      amountInput: amountInput ?? this.amountInput,
      nameGoal: nameGoal ?? this.nameGoal,
      logoGoal: logoGoal ?? this.logoGoal,
    );
  }
}
