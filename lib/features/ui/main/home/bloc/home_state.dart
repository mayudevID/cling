// ignore_for_file: must_be_immutable
part of 'home_bloc.dart';

class HomeState extends Equatable {
  List<IncomeSourceModel>? listInSource;
  List<ExpenseCategoriesModel>? listExCategories;
  bool isLoadDataDropdown;

  HomeState({
    this.listInSource,
    this.listExCategories,
    this.isLoadDataDropdown = false,
  });

  @override
  List<Object?> get props => [
        listInSource,
        listExCategories,
        isLoadDataDropdown,
      ];

  HomeState copyWith({
    List<IncomeSourceModel>? listInSource,
    List<ExpenseCategoriesModel>? listExCategories,
    bool? isLoadDataDropdown,
  }) {
    return HomeState(
      listInSource: listInSource ?? this.listInSource,
      listExCategories: listExCategories ?? this.listExCategories,
      isLoadDataDropdown: isLoadDataDropdown ?? this.isLoadDataDropdown,
    );
  }
}
