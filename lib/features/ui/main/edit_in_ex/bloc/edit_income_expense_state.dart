// ignore_for_file: must_be_immutable

part of 'edit_income_expense_bloc.dart';

class EditIncomeExpenseState extends Equatable {
  List<IncomeSourceModel> listInSource;
  List<ExpenseCategoriesModel> listExCategories;
  DateTime selectedDate;
  FlowType flowType;
  String descOrItem;
  String amountInput;
  MapEntry<int, String> selectedCategories;

  EditIncomeExpenseState({
    List<IncomeSourceModel>? listInSource,
    List<ExpenseCategoriesModel>? listExCategories,
    MapEntry<int, String>? selectedCategories,
    DateTime? selectedDate,
    this.flowType = FlowType.income,
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
        flowType,
      ];

  EditIncomeExpenseState copyWith({
    List<IncomeSourceModel>? listInSource,
    List<ExpenseCategoriesModel>? listExCategories,
    DateTime? selectedDate,
    MapEntry<int, String>? selectedCategories,
    String? descOrItem,
    String? amountInput,
    FlowType? flowType,
  }) {
    return EditIncomeExpenseState(
      listInSource: listInSource ?? this.listInSource,
      listExCategories: listExCategories ?? this.listExCategories,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      descOrItem: descOrItem ?? this.descOrItem,
      amountInput: amountInput ?? this.amountInput,
      flowType: flowType ?? this.flowType,
    );
  }
}
