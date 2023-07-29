import 'package:equatable/equatable.dart';

import '../../core/static_name_table.dart';

class ExpenseCategoriesModel extends Equatable {
  final int id;
  final String expenseCategories;

  const ExpenseCategoriesModel({
    required this.id,
    required this.expenseCategories,
  });

  factory ExpenseCategoriesModel.fromMap(Map<String, dynamic> json) =>
      ExpenseCategoriesModel(
        id: json[ExpenseCategoriesMeta.id],
        expenseCategories: json[ExpenseCategoriesMeta.expenseCategories],
      );

  @override
  List<Object?> get props => [id, expenseCategories];
}
