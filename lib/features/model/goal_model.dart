// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

import '../../core/static_name_table.dart';
import '../../core/money_amount.dart';

class GoalModel extends Equatable {
  GoalModel({
    this.id,
    required this.name,
    required this.image,
    required this.target,
    required this.collected,
  });

  factory GoalModel.fromDatabase(Map<String, dynamic> json) => GoalModel(
        id: json[GoalMeta.id],
        name: json[GoalMeta.name],
        image: json[GoalMeta.image],
        target: MoneyAmount.fromMinorUnits(json[GoalMeta.targetMinor]),
        collected: MoneyAmount.fromMinorUnits(json[GoalMeta.collectedMinor]),
      );

  factory GoalModel.empty() => GoalModel(
        name: "",
        image: "",
        target: 0,
        collected: 0,
      );
  int? id;
  String name;
  String image;
  double target;
  double collected;

  GoalModel copyWith({
    int? id,
    String? name,
    String? image,
    double? target,
    double? collected,
  }) {
    return GoalModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      target: target ?? this.target,
      collected: collected ?? this.collected,
    );
  }

  Map<String, dynamic> toMap() => {
        GoalMeta.id: id,
        GoalMeta.name: name,
        GoalMeta.image: image,
        GoalMeta.target: target,
        GoalMeta.targetMinor: MoneyAmount.toMinorUnits(target),
        GoalMeta.collected: collected,
        GoalMeta.collectedMinor:
            MoneyAmount.toMinorUnits(collected, allowZero: true),
      };

  @override
  List<Object?> get props => [
        id,
        name,
        image,
        target,
        collected,
      ];
}
