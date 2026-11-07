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
    this.targetDate,
    this.contributionFrequency = 'monthly',
    this.planningPriority,
    this.planningWalletId,
  });

  factory GoalModel.fromDatabase(Map<String, dynamic> json) => GoalModel(
        id: json[GoalMeta.id],
        name: json[GoalMeta.name],
        image: json[GoalMeta.image],
        target: MoneyAmount.fromMinorUnits(json[GoalMeta.targetMinor]),
        collected: MoneyAmount.fromMinorUnits(json[GoalMeta.collectedMinor]),
        targetDate:
            DateTime.tryParse(json[GoalMeta.targetDate] as String? ?? ''),
        contributionFrequency:
            json[GoalMeta.contributionFrequency] as String? ?? 'monthly',
        planningPriority: json[GoalMeta.planningPriority] as int?,
        planningWalletId: json[GoalMeta.planningWalletId] as int?,
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
  DateTime? targetDate;
  String contributionFrequency;
  int? planningPriority;
  int? planningWalletId;

  GoalModel copyWith({
    int? id,
    String? name,
    String? image,
    double? target,
    double? collected,
    DateTime? targetDate,
    bool clearTargetDate = false,
    String? contributionFrequency,
    int? planningPriority,
    bool clearPlanningPriority = false,
    int? planningWalletId,
    bool clearPlanningWalletId = false,
  }) {
    return GoalModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      target: target ?? this.target,
      collected: collected ?? this.collected,
      targetDate: clearTargetDate ? null : targetDate ?? this.targetDate,
      contributionFrequency:
          contributionFrequency ?? this.contributionFrequency,
      planningPriority: clearPlanningPriority
          ? null
          : planningPriority ?? this.planningPriority,
      planningWalletId: clearPlanningWalletId
          ? null
          : planningWalletId ?? this.planningWalletId,
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
        GoalMeta.targetDate: targetDate?.toIso8601String().substring(0, 10),
        GoalMeta.contributionFrequency: contributionFrequency,
        GoalMeta.planningPriority: planningPriority,
        GoalMeta.planningWalletId: planningWalletId,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        image,
        target,
        collected,
        targetDate,
        contributionFrequency,
        planningPriority,
        planningWalletId,
      ];
}
