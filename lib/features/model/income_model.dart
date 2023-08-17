// ignore_for_file: must_be_immutable

import 'package:cling/core/init_database.dart';
import 'package:cling/core/static_name_table.dart';
import 'package:equatable/equatable.dart';

class IncomeModel extends Equatable {
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

  factory IncomeModel.fromDatabase(Map<String, dynamic> json) => IncomeModel(
        id: json[IncomeMeta.id],
        date: DateTime.parse(json[IncomeMeta.date]),
        desc: json[IncomeMeta.desc],
        amount: json[IncomeMeta.amount]?.toDouble(),
        incomeSource: inSourceData[json[IncomeSourceMeta.id]],
      );

  Map<String, dynamic> toMap() => {
        IncomeMeta.id: id,
        IncomeMeta.date: date.toIso8601String(),
        IncomeMeta.desc: desc ?? "-",
        IncomeMeta.amount: amount,
        IncomeMeta.incomeSource: incomeSource,
      };

  @override
  List<Object?> get props => [
        id,
        date,
        desc,
        amount,
        incomeSource,
      ];
}
