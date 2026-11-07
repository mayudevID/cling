// ignore_for_file: must_be_immutable

import '../../core/init_database.dart';
import '../../core/static_name_table.dart';
import '../../core/money_amount.dart';
import '../../core/reference_id.dart';
import 'transaction_model.dart';

class IncomeModel implements TransactionModel {
  IncomeModel({
    this.id,
    required this.date,
    this.desc,
    required this.amount,
    required this.incomeSource,
    this.walletId = 1,
  });

  factory IncomeModel.fromDatabase(Map<String, dynamic> json) => IncomeModel(
        id: json[IncomeMeta.id],
        date: DateTime.parse(json[IncomeMeta.date]),
        desc: json[IncomeMeta.desc],
        amount: MoneyAmount.fromMinorUnits(json[IncomeMeta.amountMinor]),
        incomeSource: displayReference(
          json[IncomeMeta.idIncomeSource],
          inSourceData,
          unknownType: 'income source',
        ),
        walletId: json[IncomeMeta.walletId] as int? ?? 1,
      );
  @override
  int? id;
  @override
  DateTime date;
  String? desc;
  @override
  double amount;
  String incomeSource;
  int walletId;

  IncomeModel copyWith({
    int? id,
    DateTime? date,
    String? desc,
    double? amount,
    String? incomeSource,
    int? walletId,
  }) =>
      IncomeModel(
        id: id ?? this.id,
        date: date ?? this.date,
        desc: desc ?? this.desc,
        amount: amount ?? this.amount,
        incomeSource: incomeSource ?? this.incomeSource,
        walletId: walletId ?? this.walletId,
      );

  Map<String, dynamic> toMap() => {
        IncomeMeta.id: id,
        IncomeMeta.date: date.toIso8601String(),
        IncomeMeta.desc: desc ?? "-",
        IncomeMeta.amount: amount,
        IncomeMeta.amountMinor: MoneyAmount.toMinorUnits(amount),
        IncomeMeta.idIncomeSource: incomeSource,
        IncomeMeta.walletId: walletId,
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
        walletId,
      ];

  @override
  bool? get stringify => true;
}
