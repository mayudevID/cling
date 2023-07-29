import 'package:cling/core/static_name_table.dart';
import 'package:equatable/equatable.dart';

class IncomeSourceModel extends Equatable {
  final int id;
  final String incomeSource;

  const IncomeSourceModel({
    required this.id,
    required this.incomeSource,
  });

  factory IncomeSourceModel.fromMap(Map<String, dynamic> json) =>
      IncomeSourceModel(
        id: json[IncomeSourceMeta.id],
        incomeSource: json[IncomeSourceMeta.incomeSource],
      );

  @override
  List<Object?> get props => [id, incomeSource];
}
