// ignore_for_file: must_be_immutable

import '../../core/static_name_table.dart';
import '../../core/money_amount.dart';
import 'package:equatable/equatable.dart';

class GoalSavingModel extends Equatable {
  GoalSavingModel({
    this.id,
    required this.goalId,
    required this.date,
    required this.amount,
  });

  factory GoalSavingModel.fromDatabase(Map<String, dynamic> json) =>
      GoalSavingModel(
        id: json[GoalSavingMeta.id],
        goalId: json[GoalSavingMeta.idGoal],
        date: DateTime.parse(json[GoalSavingMeta.date]),
        amount: MoneyAmount.fromMinorUnits(json[GoalSavingMeta.amountMinor]),
      );
  int? id;
  int goalId;
  DateTime date;
  double amount;

  GoalSavingModel copyWith({
    int? id,
    int? goalId,
    DateTime? date,
    double? amount,
  }) {
    return GoalSavingModel(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      date: date ?? this.date,
      amount: amount ?? this.amount,
    );
  }

  @override
  List<Object?> get props => [
        id,
        goalId,
        date,
        amount,
      ];
}
