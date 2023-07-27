import 'dart:convert';

ExpenseModel expenseModelFromMap(String str) =>
    ExpenseModel.fromMap(json.decode(str));

String expenseModelToMap(ExpenseModel data) => json.encode(data.toMap());

class ExpenseModel {
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

  factory ExpenseModel.fromMap(Map<String, dynamic> json) => ExpenseModel(
        id: json["id"],
        date: DateTime.parse(json["date"]),
        item: json["item"],
        amount: json["amount"]?.toDouble(),
        categories: json["categories"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "date": date.toIso8601String(),
        "item": item,
        "amount": amount,
        "categories": categories,
      };
}
