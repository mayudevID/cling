// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

import '../../core/static_name_table.dart';

class GoalModel extends Equatable {
  int? id;
  String name;
  String image;
  double target;
  double collected;

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
        target: json[GoalMeta.target]?.toDouble(),
        collected: json[GoalMeta.collected]?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        GoalMeta.id: id,
        GoalMeta.name: name,
        GoalMeta.image: image,
        GoalMeta.target: target,
        GoalMeta.collected: collected,
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
