import 'dart:convert';

IncomeModel incomeModelFromMap(String str) =>
    IncomeModel.fromMap(json.decode(str));

String incomeModelToMap(IncomeModel data) => json.encode(data.toMap());

class IncomeModel {
  int? id;
  DateTime date;
  String? desc;
  double amount;
  String incomeSource;

  IncomeModel({
    this.id,
    required this.date,
    this.desc,
    required this.amount,
    required this.incomeSource,
  });

  IncomeModel copyWith({
    int? id,
    DateTime? date,
    String? desc,
    double? amount,
    String? incomeSource,
  }) =>
      IncomeModel(
        id: id ?? this.id,
        date: date ?? this.date,
        desc: desc ?? this.desc,
        amount: amount ?? this.amount,
        incomeSource: incomeSource ?? this.incomeSource,
      );

  factory IncomeModel.fromMap(Map<String, dynamic> json) => IncomeModel(
        id: json["id"],
        date: DateTime.parse(json["date"]),
        desc: json["desc"],
        amount: json["amount"]?.toDouble(),
        incomeSource: json["income_source"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "date": date.toIso8601String(),
        "desc": desc,
        "amount": amount,
        "income_source": incomeSource,
      };
}
