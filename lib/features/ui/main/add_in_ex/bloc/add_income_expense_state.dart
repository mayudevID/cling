// ignore_for_file: must_be_immutable

part of 'add_income_expense_bloc.dart';

class AddIncomeExpenseState extends Equatable {
  List<IncomeSourceModel> listInSource;
  List<ExpenseCategoriesModel> listExCategories;
  DateTime selectedDate;
  String descOrItem;
  String amountInput;
  MapEntry<int, String> selectedCategories;

  AddIncomeExpenseState({
    List<IncomeSourceModel>? listInSource,
    List<ExpenseCategoriesModel>? listExCategories,
    MapEntry<int, String>? selectedCategories,
    DateTime? selectedDate,
    this.descOrItem = "",
    this.amountInput = "",
  })  : listInSource = listInSource ?? List.empty(),
        selectedDate = selectedDate ?? DateTime.now(),
        selectedCategories = selectedCategories ?? const MapEntry(0, ""),
        listExCategories = listExCategories ?? List.empty();

  @override
  List<Object> get props => [
        listInSource,
        listExCategories,
        selectedDate,
        selectedCategories,
        descOrItem,
        amountInput,
      ];

  AddIncomeExpenseState copyWith({
    List<IncomeSourceModel>? listInSource,
    List<ExpenseCategoriesModel>? listExCategories,
    DateTime? selectedDate,
    MapEntry<int, String>? selectedCategories,
    String? descOrItem,
    String? amountInput,
  }) {
    return AddIncomeExpenseState(
      listInSource: listInSource ?? this.listInSource,
      listExCategories: listExCategories ?? this.listExCategories,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      descOrItem: descOrItem ?? this.descOrItem,
      amountInput: amountInput ?? this.amountInput,
    );
  }
}
