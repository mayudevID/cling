// ignore_for_file: must_be_immutable

part of 'add_income_expense_bloc.dart';

class AddIncomeExpenseState extends Equatable {
  AddIncomeExpenseState({
    List<IncomeSourceModel>? listInSource,
    List<ExpenseCategoriesModel>? listExCategories,
    MapEntry<int, String>? selectedCategories,
    DateTime? selectedDate,
    this.descOrItem = "",
    this.amountInput = 0,
    this.selectedWalletId = 1,
    List<WalletModel>? wallets,
  })  : listInSource = listInSource ?? List.empty(),
        selectedDate = selectedDate ?? DateTime.now(),
        selectedCategories = selectedCategories ?? const MapEntry(0, ""),
        listExCategories = listExCategories ?? List.empty(),
        wallets = wallets ?? List.empty();
  List<IncomeSourceModel> listInSource;
  List<ExpenseCategoriesModel> listExCategories;
  DateTime selectedDate;
  String descOrItem;
  double amountInput;
  MapEntry<int, String> selectedCategories;
  List<WalletModel> wallets;
  int selectedWalletId;

  @override
  List<Object> get props => [
        listInSource,
        listExCategories,
        selectedDate,
        selectedCategories,
        descOrItem,
        amountInput,
        wallets,
        selectedWalletId,
      ];

  AddIncomeExpenseState copyWith({
    List<IncomeSourceModel>? listInSource,
    List<ExpenseCategoriesModel>? listExCategories,
    DateTime? selectedDate,
    MapEntry<int, String>? selectedCategories,
    String? descOrItem,
    double? amountInput,
    List<WalletModel>? wallets,
    int? selectedWalletId,
  }) {
    return AddIncomeExpenseState(
      listInSource: listInSource ?? this.listInSource,
      listExCategories: listExCategories ?? this.listExCategories,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      descOrItem: descOrItem ?? this.descOrItem,
      amountInput: amountInput ?? this.amountInput,
      wallets: wallets ?? this.wallets,
      selectedWalletId: selectedWalletId ?? this.selectedWalletId,
    );
  }
}
