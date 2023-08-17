// ignore_for_file: must_be_immutable

import 'package:cling/core/init_database.dart';
import 'package:cling/core/static_name_table.dart';
import 'package:equatable/equatable.dart';

class ExpenseModel extends Equatable {
  int? id;
  DateTime date;
  String item;
  double amount;
  String categories;

  ExpenseModel({
    this.id,
    required this.date,
    required this.item,
    required this.amount,
    required this.categories,
  });

  ExpenseModel copyWith({
    int? id,
    DateTime? date,
    String? item,
    double? amount,
    String? categories,
  }) =>
      ExpenseModel(
        id: id ?? this.id,
        date: date ?? this.date,
        item: item ?? this.item,
        amount: amount ?? this.amount,
        categories: categories ?? this.categories,
      );

  factory ExpenseModel.fromDatabase(Map<String, dynamic> json) => ExpenseModel(
        id: json[ExpenseMeta.id],
        date: DateTime.parse(json[ExpenseMeta.date]),
        item: json[ExpenseMeta.item],
        amount: json[ExpenseMeta.amount]?.toDouble(),
        categories: exCategoriesData[json[ExpenseCategoriesMeta.id]],
      );

  Map<String, dynamic> toMap() => {
        ExpenseMeta.id: id,
        ExpenseMeta.date: date.toIso8601String(),
        ExpenseMeta.item: item,
        ExpenseMeta.amount: amount,
        ExpenseMeta.categories: categories,
      };

  @override
  List<Object?> get props => [
        id,
        date,
        item,
        amount,
        categories,
      ];
}
