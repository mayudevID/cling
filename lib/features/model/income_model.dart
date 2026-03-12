// ignore_for_file: must_be_immutable

import '../../core/init_database.dart';
import '../../core/static_name_table.dart';
import 'transaction_model.dart';

class IncomeModel implements TransactionModel {

  IncomeModel({
    this.id,
    required this.date,
    this.desc,
    required this.amount,
    required this.incomeSource,
  });

  factory IncomeModel.fromDatabase(Map<String, dynamic> json) => IncomeModel(
        id: json[IncomeMeta.id],
        date: DateTime.parse(json[IncomeMeta.date]),
        desc: json[IncomeMeta.desc],
        amount: json[IncomeMeta.amount]?.toDouble(),
        incomeSource: inSourceData[json[IncomeMeta.idIncomeSource]],
      );
  @override
  int? id;
  @override
  DateTime date;
  String? desc;
  @override
  double amount;
  String incomeSource;

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

  Map<String, dynamic> toMap() => {
        IncomeMeta.id: id,
        IncomeMeta.date: date.toIso8601String(),
        IncomeMeta.desc: desc ?? "-",
        IncomeMeta.amount: amount,
        IncomeMeta.idIncomeSource: incomeSource,
      };

  @override
  TransactionType getType() => TransactionType.income;

  @override
  List<Object?> get props => [
        id,
        date,
        desc,
        amount,
        incomeSource,
      ];

  @override
  bool? get stringify => true;
}
